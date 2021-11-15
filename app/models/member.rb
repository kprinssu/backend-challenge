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

  # Helper to get all friends ids
  def all_friends_ids
    all_friend_ids = first_friendships.pluck(:friend1_id, :friend2_id) + second_friendships.pluck(:friend1_id, :friend2_id)
    all_friend_ids.flatten!
    all_friend_ids.reject! { |f_id| f_id == self.id}

    return all_friend_ids
  end

  def friend_links(base_url)
    friend_ids = self.all_friends_ids
    friend_ids.map { |friend_id| "#{base_url}/member/#{friend_id}"}
  end

  def full_name
    "\'#{self.first_name} #{self.last_name}\'"
  end

  # This will use a slightly modified Depth-first search to find experts
  # this will be slow due to N+1 queries
  def find_experts(topic, intial_member, visited_members)
    # Prevent cycles
    if visited_members.include?(self.id)
      return []
    end

    all_friend_ids = self.all_friends_ids()
    experts = []

    # This member is a friend of the initial member
    if intial_member != self.id && !all_friend_ids.include?(intial_member)
      # Check if any of our headings matches the topic
      headings = (self.h1 || []) + (self.h2 || []) + (self.h3 || [])
      am_expert = headings.any? { |h| h.include?(topic) }
      experts.append([self.full_name]) if am_expert
    end

    visited_members.append(self.id)

    all_friend_ids.each do |f_id|
      friends_experts = Member.find_by(id: f_id).find_experts(topic, intial_member, visited_members)

      # Append the current member id to front to generate the path
      friends_experts.each { |expert| expert.unshift(self.full_name) }

      experts.concat(friends_experts)
    end

    return experts
  end
end
