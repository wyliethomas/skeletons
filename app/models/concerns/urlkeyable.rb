# frozen_string_literal: true

module Urlkeyable
  extend ActiveSupport::Concern

  included do
    before_create :generate_urlkey
    validates :urlkey, uniqueness: true, presence: true, on: :update
  end

  # Override to_param to use urlkey instead of id in URLs
  def to_param
    urlkey
  end

  private

  def generate_urlkey
    return if urlkey.present?

    loop do
      self.urlkey = SecureRandom.alphanumeric(12)
      break unless self.class.exists?(urlkey: urlkey)
    end
  end
end
