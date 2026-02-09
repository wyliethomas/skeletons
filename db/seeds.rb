# frozen_string_literal: true

# This file should be idempotent - safe to run multiple times
#
# Usage:
#   rails db:seed

# Create super admin user (no client association)
super_admin = User.find_or_initialize_by(email: 'admin@example.com')
unless super_admin.persisted?
  super_admin.assign_attributes(
    first_name: 'Super',
    last_name: 'Admin',
    password: 'Admin123!',
    password_confirmation: 'Admin123!',
    role: 'super_admin'
  )
  super_admin.save!
  puts "✓ Created super_admin: admin@example.com / Admin123!"
end

# Create sample client with admin user (for development/testing)
if Rails.env.development?
  client = Client.find_or_initialize_by(name: 'Sample Organization')
  unless client.persisted?
    client.save!
    puts "✓ Created sample client: Sample Organization"
  end

  admin_user = User.find_or_initialize_by(email: 'demo@example.com')
  unless admin_user.persisted?
    admin_user.assign_attributes(
      first_name: 'Demo',
      last_name: 'User',
      password: 'Demo123!',
      password_confirmation: 'Demo123!',
      role: 'admin',
      client: client
    )
    admin_user.save!
    puts "✓ Created demo user: demo@example.com / Demo123!"
  end

  member_user = User.find_or_initialize_by(email: 'member@example.com')
  unless member_user.persisted?
    member_user.assign_attributes(
      first_name: 'Member',
      last_name: 'User',
      password: 'Member123!',
      password_confirmation: 'Member123!',
      role: 'member',
      client: client
    )
    member_user.save!
    puts "✓ Created member user: member@example.com / Member123!"
  end
end

puts "\n✅ Database seeded successfully!"
puts "\n📝 Default Credentials:"
puts "   Super Admin: admin@example.com / Admin123!"
puts "   Demo Admin:  demo@example.com / Demo123!"   if Rails.env.development?
puts "   Member:      member@example.com / Member123!" if Rails.env.development?
puts "\n⚠️  IMPORTANT: Change these passwords in production!"
