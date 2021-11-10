class MemberFriendship < ApplicationRecord
  scope :friends, -> (member) { where('friend1_id = ? OR friend2_id = ?', member.id, member.id) }
end
