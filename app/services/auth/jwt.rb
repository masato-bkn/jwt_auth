# frozen_string_literal: true

require 'jwt'

module Auth
  class Jwt
    # TODO: 秘密鍵, アルゴリズムは後で
    def self.issue_token(user_info:)
      JWT.encode(
          user_info,
          Rails.application.credentials.secret_key_base
        )
    end

    def self.valid_user?(jwt:)
      return false if jwt.nil?

      decoded_jwt = JWT.decode(jwt, Rails.application.credentials.secret_key_base)
      user_exists?(decoded_jwt)
    end

    def self.user_exists?(decoded_jwt)
      user_info = decoded_jwt.first

      User.exists?(
        id: user_info['user_id'],
        password_digest: user_info['password_digest'],
        email: user_info['email']
      )
    end

    private_class_method :new, :user_exists?
  end
end
