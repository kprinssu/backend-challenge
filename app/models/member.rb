class Member < ApplicationRecord
  has_many :first_friendships, foreign_key: :friend1_id, class_name: :MemberFriendship
  has_many :second_friendships, foreign_key: :friend2_id, class_name: :MemberFriendship
end
