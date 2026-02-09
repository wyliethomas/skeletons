# Customization Guide

This guide shows you how to extend and customize the Rails Multi-Tenant Seed Project for your specific needs.

## Table of Contents

- [Adding New Models](#adding-new-models)
- [Extending the User Model](#extending-the-user-model)
- [Customizing Authentication](#customizing-authentication)
- [Adding Authorization Rules](#adding-authorization-rules)
- [Multi-Tenant Best Practices](#multi-tenant-best-practices)
- [Adding Admin Features](#adding-admin-features)
- [Customizing the UI](#customizing-the-ui)
- [Adding Background Jobs](#adding-background-jobs)

---

## Adding New Models

### 1. Basic Multi-Tenant Model

Example: Adding a `Project` model that belongs to a client.

```bash
rails generate model Project name:string description:text client:references
```

Edit the migration to add urlkey and soft delete:

```ruby
# db/migrate/XXXXXX_create_projects.rb
class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.references :client, null: false, foreign_key: true

      # URL key for pretty URLs
      t.string :urlkey, null: false

      # Soft delete fields
      t.datetime :deleted_at
      t.bigint :deleted_by_id

      t.timestamps
    end

    add_index :projects, :urlkey, unique: true
    add_index :projects, :deleted_at
  end
end
```

Update the model:

```ruby
# app/models/project.rb
class Project < ApplicationRecord
  include Urlkeyable
  include SoftDeletable

  belongs_to :client

  validates :name, presence: true

  # Scope to active projects only
  scope :active, -> { where(deleted_at: nil) }
end
```

Update the Client model:

```ruby
# app/models/client.rb
class Client < ApplicationRecord
  # ... existing code ...
  has_many :projects, dependent: :destroy
end
```

### 2. Adding a Controller

```bash
rails generate controller Projects index show new create edit update destroy
```

Update the controller to be multi-tenant aware:

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    # Automatically scoped to current client
    @projects = current_client.projects.active
  end

  def show
  end

  def new
    @project = current_client.projects.new
  end

  def create
    @project = current_client.projects.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.soft_delete!
    redirect_to projects_path, notice: 'Project deleted successfully.'
  end

  private

  def set_project
    # Use urlkey for lookup and scope to current client
    @project = current_client.projects.find_by!(urlkey: params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
```

Add routes:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ... existing routes ...

  resources :projects
end
```

---

## Extending the User Model

### Adding Custom Fields

1. Generate a migration:

```bash
rails generate migration AddFieldsToUsers phone:string department:string
```

2. Update the migration:

```ruby
class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :department, :string

    add_index :users, :phone
  end
end
```

3. Update validations in `app/models/user.rb`:

```ruby
class User < ApplicationRecord
  # ... existing code ...

  validates :phone, format: { with: /\A\+?[\d\s\-()]+\z/, allow_blank: true }
end
```

4. Update controller permitted params:

```ruby
# app/controllers/accounts_controller.rb
def user_params
  params.require(:user).permit(
    :first_name, :last_name, :email,
    :phone, :department,  # Add your new fields
    :new_password, :new_password_confirmation
  )
end
```

---

## Customizing Authentication

### Adding a New OAuth Provider (e.g., GitHub)

1. Add gem to Gemfile:

```ruby
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
```

2. Create an initializer:

```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
           ENV['GITHUB_CLIENT_ID'],
           ENV['GITHUB_CLIENT_SECRET'],
           scope: 'user:email'
end
```

3. Add OAuth callback to User model:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # ... existing code ...

  def self.from_github(auth)
    user = find_by_email(auth.info.email)

    unless user
      password = SecureRandom.hex(15)
      user = new(
        email: auth.info.email,
        first_name: auth.info.name.split.first,
        last_name: auth.info.name.split.last,
        provider: 'GitHub',
        oauth_sub: auth.uid,
        password: password,
        password_confirmation: password
      )

      user.save
    end

    user
  end
end
```

4. Add routes and controller action:

```ruby
# config/routes.rb
get '/auth/github/callback', to: 'auth#github_callback'

# app/controllers/auth_controller.rb
def github_callback
  auth = request.env['omniauth.auth']
  user = User.from_github(auth)

  if user
    create_user_session(user)
    redirect_to root_path
  else
    redirect_to signin_path, alert: 'Authentication failed'
  end
end
```

### Custom Password Requirements

Edit `app/validators/password_strength_validator.rb`:

```ruby
class PasswordStrengthValidator < ActiveModel::EachValidator
  DEFAULT_MIN_LENGTH = 12  # Change from 8 to 12

  def validate_each(record, attribute, value)
    return if value.blank?

    min_length = options[:min_length] || DEFAULT_MIN_LENGTH
    errors = []

    # Your custom rules here
    if value.length < min_length
      errors << "must be at least #{min_length} characters long"
    end

    # Add custom requirement: no common passwords
    common_passwords = %w[password123 admin123 qwerty]
    if common_passwords.include?(value.downcase)
      errors << "cannot be a common password"
    end

    # ... rest of validation
  end
end
```

---

## Adding Authorization Rules

### Extending AdminPrivileges Concern

```ruby
# app/models/concerns/admin_privileges.rb
module AdminPrivileges
  extend ActiveSupport::Concern

  def can_manage_credits?
    super_admin?
  end

  def can_view_all_clients?
    super_admin?
  end

  def can_manage_team?
    admin? || super_admin?
  end

  # Add your custom permission methods
  def can_delete_projects?
    admin? || super_admin?
  end

  def can_export_data?
    admin? || super_admin?
  end

  def can_view_analytics?
    true  # All users can view analytics
  end
end
```

### Using Permissions in Controllers

```ruby
class ProjectsController < ApplicationController
  def destroy
    unless current_user.can_delete_projects?
      redirect_to projects_path, alert: "You don't have permission to delete projects"
      return
    end

    @project.soft_delete!
    redirect_to projects_path, notice: 'Project deleted'
  end
end
```

### Creating a Pundit-Style Authorization System

1. Add Pundit gem:

```ruby
# Gemfile
gem 'pundit'
```

2. Install and generate:

```bash
bundle install
rails generate pundit:install
```

3. Create a policy:

```ruby
# app/policies/project_policy.rb
class ProjectPolicy < ApplicationPolicy
  def create?
    user.admin? || user.super_admin?
  end

  def update?
    user.admin? || user.super_admin? || record.created_by == user
  end

  def destroy?
    user.can_delete_projects?
  end
end
```

4. Use in controller:

```ruby
class ProjectsController < ApplicationController
  def create
    @project = current_client.projects.new(project_params)
    authorize @project  # Pundit authorization

    if @project.save
      redirect_to @project
    else
      render :new
    end
  end
end
```

---

## Multi-Tenant Best Practices

### 1. Always Scope Queries to Current Client

```ruby
# GOOD: Scoped to current client
@projects = current_client.projects

# BAD: Could leak data across clients
@projects = Project.all
```

### 2. Use URL Keys Instead of IDs

```ruby
# GOOD: Uses urlkey
@project = current_client.projects.find_by!(urlkey: params[:id])

# BAD: Uses database ID (security risk)
@project = Project.find(params[:id])
```

### 3. Add Client Foreign Keys to All Tenant-Scoped Models

```ruby
class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :client, null: false, foreign_key: true, index: true
      # ... other fields
    end
  end
end
```

### 4. Prevent Cross-Client Data Leaks

Add this to ApplicationController for extra safety:

```ruby
class ApplicationController < ActionController::Base
  after_action :verify_tenant_isolation, if: -> { current_client.present? }

  private

  def verify_tenant_isolation
    # Verify any instance variables are scoped to current client
    instance_variables.each do |var|
      value = instance_variable_get(var)
      next unless value.is_a?(ApplicationRecord)

      if value.respond_to?(:client_id) && value.client_id != current_client.id
        raise "Cross-tenant data leak detected: #{var}"
      end
    end
  end
end
```

---

## Adding Admin Features

### Creating a New Admin Controller

```ruby
# app/controllers/admin/projects_controller.rb
module Admin
  class ProjectsController < BaseController
    def index
      # Super admin can see ALL projects across ALL clients
      @projects = Project.includes(:client).order(created_at: :desc)
    end

    def destroy
      @project = Project.find(params[:id])
      @project.destroy!  # Hard delete for admin
      redirect_to admin_projects_path, notice: 'Project permanently deleted'
    end
  end
end
```

Add route:

```ruby
# config/routes.rb
namespace :admin do
  resources :projects, only: [:index, :destroy]
end
```

---

## Customizing the UI

### Adding Tailwind Components

The project uses Tailwind CSS 4.x. Add custom styles in `app/assets/tailwind/application.css`:

```css
@import "tailwindcss";

/* Custom components */
@layer components {
  .btn-primary {
    @apply bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition;
  }

  .card {
    @apply bg-white shadow-md rounded-lg p-6;
  }
}
```

### Creating Layouts

Create custom layouts for different sections:

```erb
<!-- app/views/layouts/admin.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>Admin - <%= content_for(:title) || 'My App' %></title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body class="bg-gray-100">
    <nav class="bg-gray-900 text-white p-4">
      <!-- Admin navigation -->
    </nav>

    <main class="container mx-auto mt-8">
      <%= yield %>
    </main>
  </body>
</html>
```

---

## Adding Background Jobs

The project includes Solid Queue for background jobs.

### Creating a Job

```bash
rails generate job SendWelcomeEmail
```

```ruby
# app/jobs/send_welcome_email_job.rb
class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    # Send email logic here
    UserMailer.welcome(user).deliver_now
  end
end
```

### Enqueuing a Job

```ruby
# In your controller or model
SendWelcomeEmailJob.perform_later(user.id)
```

### Scheduled Jobs

Add to `config/recurring.yml`:

```yaml
# config/recurring.yml
daily_cleanup:
  class: DailyCleanupJob
  schedule: every day at 3am
```

---

## Common Customization Scenarios

### Scenario 1: Adding a Subscription/Billing Model

See pxp-consultant source project for full billing implementation with Stripe.

### Scenario 2: Adding Team Invitations

1. Create InviteToken model
2. Add invite controller
3. Email invitation with token
4. Accept invitation flow

### Scenario 3: Adding File Uploads

1. Use Active Storage (already included)
2. Add has_one_attached or has_many_attached to models
3. Configure cloud storage (S3, etc.)

---

## Next Steps

- Review the [README.md](README.md) for general usage
- Check security settings in `config/initializers/rack_attack.rb`
- Customize email templates (when you add ActionMailer)
- Add your business logic models
- Build out your admin panel

## Questions?

This seed project is meant to be a starting point. Don't hesitate to:
- Remove features you don't need
- Refactor to fit your conventions
- Add new patterns that work for your team

Happy building!
