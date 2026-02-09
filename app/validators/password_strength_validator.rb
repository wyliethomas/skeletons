# frozen_string_literal: true

# Password Strength Validator
#
# Validates password meets strong security requirements:
# - Minimum 8 characters (configurable)
# - At least one uppercase letter
# - At least one lowercase letter
# - At least one digit
# - At least one special character
#
# Usage:
#   validates :password, password_strength: true
#   validates :password, password_strength: { min_length: 12 }
class PasswordStrengthValidator < ActiveModel::EachValidator
  DEFAULT_MIN_LENGTH = 8

  def validate_each(record, attribute, value)
    return if value.blank?

    min_length = options[:min_length] || DEFAULT_MIN_LENGTH
    errors = []

    # Check minimum length
    if value.length < min_length
      errors << "must be at least #{min_length} characters long"
    end

    # Check for uppercase letter
    unless value.match?(/[A-Z]/)
      errors << "must include at least one uppercase letter"
    end

    # Check for lowercase letter
    unless value.match?(/[a-z]/)
      errors << "must include at least one lowercase letter"
    end

    # Check for digit
    unless value.match?(/\d/)
      errors << "must include at least one number"
    end

    # Check for special character
    unless value.match?(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/)
      errors << "must include at least one special character (!@#$%^&*...)"
    end

    # Add errors to record
    errors.each do |error|
      record.errors.add(attribute, error)
    end
  end
end
