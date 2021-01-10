# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST' do
    subject do
      post users_path(params)
      response
    end

    let :params do
      {
        name: 'hoge',
        password: '123456',
        enail: 'test@example.com'
      }
    end

    it 'ユーザーが作成できること' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'ヘッダーにjwtトークンが含まれていること' do
      result = subject.headers
      expect(result['Jwt-Token']).to be_present
    end
  end

  describe 'GET' do
    subject do
      get user_path(user.id), headers: headers
      response
    end

    let :headers do
      {
        'Jwt-Token': Auth::Jwt.issue_token(user_info: user_info)
      }
    end

    let :user_info do
      {
        user_id: user.id,
        password_digest: user.password_digest,
        email: user.email
      }
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

    context 'ヘッダーにjwtトークンが含まれていない場合' do
      subject do
        get user_path(user.id)
        response
      end

      it '想定するレスポンスが返ってくること' do
        result = JSON.parse(subject.body)

        expect(result['message']).to eq('unauthorized user')
      end
    end
  end
end
