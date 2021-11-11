class Member < ApplicationRecord
  has_many :first_friendships, foreign_key: :friend1_id, class_name: :MemberFriendship
  has_many :second_friendships, foreign_key: :friend2_id, class_name: :MemberFriendship

  # Basic validation to ensure name and personal website are not nil
  validates :name, :personal_website, presence: true, allow_blank: false

  # Run the website shortening and h* tag scraping
  after_create do
     ScrapeWebsite.perform_later(self.id, self.personal_website)
     ShortenUrl.perform_later(self.id, self.personal_website)
  end
end
