FactoryBot.define do
  factory :micropost do
    content {"uouo"}
    created_at { 10.minutes.ago}
    association :user
    
    trait :most_recent do
      content {"Most recent content"}
      created_at { Time.zone.now }
    end
    trait :invalid do
      # 無効になっている trait :invalid do
      content { nil }
    end
  end
end
