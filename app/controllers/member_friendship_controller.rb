class MemberFriendshipController < ApplicationController
  # POST /friendships
  def new
    begin
      friendship = MemberFriendship.new(friend1_id: new_friendship_params[:member_id], friend2_id: new_friendship_params[:friend_id])
      friendship.save!
    rescue StandardError => ex
      return render status: 422, json: {
        error: ex,
      }
    end

    return render nothing: true
  end

  private

  def new_friendship_params
    params.require(:friendship).permit(:member_id, :friend_id)
  end
end
