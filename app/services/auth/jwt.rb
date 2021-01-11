# frozen_string_literal: true

require 'jwt'

module Auth
  class Jwt
    def self.issue_token(user_info:, expire_time: 1.day.after)
      user_info['exp'] = expire_time.to_i

      JWT.encode(
        user_info,
        Rails.application.credentials.secret_key_base
      )
    end

    def self.valify(jwt:)
      decoded_jwt = JWT.decode(jwt, Rails.application.credentials.secret_key_base).first

      raise InvalidSignature unless user_exists?(decoded_jwt)
    end

    def self.user_exists?(decoded_jwt)
      user_info = decoded_jwt

      User.exists?(
        id: user_info['user_id'],
        password_digest: user_info['password_digest'],
        email: user_info['email']
      )
    end

    private_class_method :new, :user_exists?
  end
end
