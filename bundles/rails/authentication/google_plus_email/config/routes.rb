# frozen_string_literal: true

# Authentication routes for Email + Google OAuth
#
# Add these routes to your config/routes.rb file:
#
# Rails.application.routes.draw do
#   # ... your existing routes ...
#
#   # Authentication routes (copy from below)
# end

# Email/Password Authentication
get  '/signin',  to: 'auth#signin',  as: :signin
post '/signin',  to: 'auth#signin_do'

get  '/signup',  to: 'auth#signup',  as: :signup
post '/signup',  to: 'auth#signup_do'

get  '/signout', to: 'auth#signout', as: :signout

# Google OAuth
post '/gsi',         to: 'auth#gsi'
get  '/gsi/session', to: 'auth#gsi_session', as: :gsi_session

# Password Reset
get  '/forgot',          to: 'auth#forgot',          as: :forgot
post '/forgot',          to: 'auth#forgot_do'
get  '/reset-password/:reset_token', to: 'auth#reset_password', as: :reset_password
post '/reset-password',  to: 'auth#reset_password_do'
