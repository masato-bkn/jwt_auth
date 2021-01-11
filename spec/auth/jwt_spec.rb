# frozen_string_literal: true

require 'rails_helper'
require 'jwt'

RSpec.describe Auth::Jwt, type: :auth do
  describe 'new' do
    it 'newによるインスタン化ができないこと' do
      expect { Auth::Jwt.new }.to raise_error(NoMethodError)
    end
  end

  describe 'issue_token' do
    subject do
      Auth::Jwt.issue_token(user_info: user_info)
    end

    let :user_info do
      {
        user_id: '1',
        password_digest: '123456',
        email: 'test@example.com'
      }
    end

    it 'jwtトークンが返ってくること' do
      expect(subject).to eq(JWT.encode(user_info, Rails.application.credentials.secret_key_base))
    end
  end

  describe 'valify' do
    subject do
      Auth::Jwt.valify(jwt: jwt)
    end

    let :user do
      create(:user)
    end

    let :jwt do
      JWT.encode(user_info, Rails.application.credentials.secret_key_base)
    end

    let :user_info do
      {
        user_id: user.id,
        password_digest: user.password_digest,
        email: user.email
      }
    end

    it do
      expect { subject }.not_to raise_error
    end

    context 'jwtの有効期限が切れている場合' do
      let :jwt do
        Auth::Jwt.issue_token(user_info: user_info, expire_time: Time.zone.now)
      end

      it do
        expect { subject }.to raise_error(JWT::ExpiredSignature)
      end
    end
  end
end
