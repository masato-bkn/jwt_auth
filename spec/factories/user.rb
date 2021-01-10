# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name         { 'hoge' }
    email        { 'hoge@example.com' }
    password     { 'hogehoge' }
  end
end
