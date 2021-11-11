class Member < ApplicationRecord
  has_many :first_friendships, foreign_key: :friend1_id, class_name: :MemberFriendship
  has_many :second_friendships, foreign_key: :friend2_id, class_name: :MemberFriendship

  # Scope to get friendships
  scope :all_friends, -> { joins('LEFT JOIN member_friendships ON (members.id = member_friendships.friend1_id OR members.id = member_friendships.friend2_id)') }

  # Basic validation to ensure name and personal website are not nil
  validates :first_name, :last_name, :url, presence: true, allow_blank: false

  # Run the website shortening and h* tag scraping
  after_create do
     ScrapeWebsite.perform_later(self.id, self.url)
     ShortenUrl.perform_later(self.id, self.url)
  end

  def friend_links(base_url)
    friend_ids = MemberFriendship.where('friend1_id = ? OR friend2_id = ?', self.id, self.id).pluck('friend1_id, friend2_id')
    friend_ids.flatten!
    friend_ids = friend_ids.select { |friend_id| friend_id != self.id }
    friend_ids.map { |friend_id| "#{base_url}/member/#{friend_id}"}
  end
end
