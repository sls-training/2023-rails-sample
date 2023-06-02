# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Michael Example' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }
    admin { [true, false].sample }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end

    trait :noadmin do
      admin { false }
    end

    trait :noactivated do
      admin { false }
      activated { false }
      activated_at { nil }
    end

    trait :users do
      sequence(:name) { |n| "User#{n}" }
      sequence(:email) { |n| "testusers#{n}@example.com" }
      admin { false }
    end
  end
end
