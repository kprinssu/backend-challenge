class MemberFriendshipController < ApplicationController
  # POST /friendships
  def new
    friendship = MemberFriendship.new(friend1_id: params[:member_id], friend2_id: params[:friend_id])

    begin
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
