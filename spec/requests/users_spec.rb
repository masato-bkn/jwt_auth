# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST' do
    subject do
      post users_path(params)
    end

    let :params do
      {
        name: 'hoge',
        password_digest: '123456',
        enail: 'test@example.com'
      }
    end

    it 'ユーザーが作成できること' do
      expect { subject }.to change(User, :count).by(1)
    end
  end

  describe 'GET' do
    subject do
      get user_path(user.id)
      response
    end

    let :user do
      create(:user)
    end

    it '想定するレスポンスが返ってくること' do
      result = JSON.parse(subject.body)

      expect(result['id']).to eq(user.id)
      expect(result['name']).to eq(user.name)
      expect(result['email']).to eq(user.email)
      expect(result['password_digest']).to eq(user.password_digest)
    end
  end
end
