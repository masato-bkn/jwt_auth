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
end
