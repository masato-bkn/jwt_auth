require 'jwt'

class Authorize::JwtGenerator
    def initialize(user_id:, password:, email:)
        @payload = payload(user_id, password, email)
    end

    def run
        # TODO 秘密鍵、アルゴリズムは後で
        JWT.encode(@payload, nil, 'none')
    end

    private

    def payload(user_id, password, email)
        {
            user_id: user_id,
            password: password,
            email: email
        }
    end
end
