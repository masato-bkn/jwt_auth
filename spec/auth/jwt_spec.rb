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
      expect(subject).to eq(JWT.encode(user_info, nil, 'none'))
    end
  end

  describe 'issue_token' do
    subject do
      Auth::Jwt.valid_user?(jwt: jwt)
    end

    let :user do
      create(:user)
    end

    let :jwt do
      JWT.encode(user_info, nil, 'none')
    end

    let :user_info do
      {
        user_id: user.id,
        password_digest: user.password_digest,
        email: user.email
      }
    end

    it do
      expect(subject).to eq(true)
    end
  end
end
