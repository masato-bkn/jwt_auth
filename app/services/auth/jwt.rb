# frozen_string_literal: true

require 'jwt'

module Auth
  class Jwt
    # TODO: 秘密鍵, アルゴリズムは後で
    def self.issue_token(user_info:)
      JWT.encode(user_info, nil, 'none')
    end

    def self.valid_user?(jwt:)
      decoded_jwt = JWT.decode(jwt, nil, false)
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
