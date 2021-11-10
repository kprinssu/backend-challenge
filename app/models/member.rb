class Member < ApplicationRecord
  scope :friends, -> (member) { joins(:member_friendships).where('member_friendships.friend1_id = ? OR member_friendships.friend2_id = ?', member.id, member.id) }
end
