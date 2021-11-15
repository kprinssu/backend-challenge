FactoryBot.define do
  factory :member_friendship do
    trait :with_friends do
      transient do
        friend1_id { 1 }
        friend2_id { 2 }
      end

      before (:create) do |friendship, evaluator|
        friendship.friend1_id = evaluator.friend1_id
        friendship.friend2_id = evaluator.friend2_id
      end
    end
  end
end
