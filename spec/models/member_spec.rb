require 'rails_helper'

RSpec.describe Member, type: :model do
  it 'must return the full name of the member' do
    member = build :alan_smith
    full_name = member.full_name
    expect(full_name).to eq("'Alan Smith'")
  end

  context 'member friendships' do
    before(:each) do
      @alan_smith = create :alan_smith
      @becky_smith = create :becky_smith
      @bob_test = create :bob_test
      @carol_test = create :carol_test
    end

    context 'friend profile ids' do
      it 'should return URLs to all friends in the relationship' do
        # Becky is on the right handside of the friendship
        create :member_friendship, :with_friends, friend1_id: @alan_smith.id, friend2_id: @becky_smith.id
        # Bob is on the left handside of the friendship
        create :member_friendship, :with_friends, friend1_id: @bob_test.id, friend2_id: @alan_smith.id

        base_url = "http://127.0.0.1"
        profile_links = @alan_smith.friend_links(base_url)
        expected_profile_links = ["#{base_url}/member/#{@becky_smith.id}", "#{base_url}/member/#{@bob_test.id}"]

        profile_links.should match_array(expected_profile_links)
      end
    end

    context 'experts' do
      it 'must return empty set for close friends' do
        create :member_friendship, :with_friends, friend1_id: @alan_smith.id, friend2_id: @becky_smith.id
        experts = @alan_smith.find_experts("Tea", @alan_smith.id, [])
        expect(experts.empty?).to eq(true)
      end

      it 'must return a path when the headings match' do
        create :member_friendship, :with_friends, friend1_id: @alan_smith.id, friend2_id: @bob_test.id
        create :member_friendship, :with_friends, friend1_id: @becky_smith.id, friend2_id: @bob_test.id
        experts = @alan_smith.find_experts("Tea", @alan_smith.id, [])

        expected_experts = [["'Alan Smith'", "'Bob Test'", "'Becky Smith'"]]
        experts.should match_array(expected_experts)
      end

      it 'must return multiple paths when headings match' do
        create :member_friendship, :with_friends, friend1_id: @alan_smith.id, friend2_id: @bob_test.id
        create :member_friendship, :with_friends, friend1_id: @becky_smith.id, friend2_id: @bob_test.id
        create :member_friendship, :with_friends, friend1_id: @bob_test.id, friend2_id: @carol_test.id
        experts = @alan_smith.find_experts("tea", @alan_smith.id, [])

        expected_experts = [["'Alan Smith'", "'Bob Test'", "'Becky Smith'"], ["'Alan Smith'", "'Bob Test'", "'Carol Test'"]]
        experts.should match_array(expected_experts)
      end

      it 'must return set when headings do not match' do
        create :member_friendship, :with_friends, friend1_id: @alan_smith.id, friend2_id: @bob_test.id
        create :member_friendship, :with_friends, friend1_id: @becky_smith.id, friend2_id: @bob_test.id
        experts = @alan_smith.find_experts("T3a", @alan_smith.id, [])

        expect(experts.empty?).to eq(true)
      end
    end
  end
end
