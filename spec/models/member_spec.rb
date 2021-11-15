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

    end
  end
end
