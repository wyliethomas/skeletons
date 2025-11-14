json.user do
  json.jwt @user.jwt
  json.user_key @user.apikey
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.name @user.name
  json.status @user.status
  json.role @user.role
end
