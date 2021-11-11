class MemberController < ApplicationController
  # POST /member
  def new
    member = Member.new(new_member_params)
    begin
      member.save!
    rescue StandardError => ex
      render status: 422, json: {
        error: ex,
      }
      return
    end

    # Only show the stored values (id, name, website url)
    member_json = member.attributes.slice(:id, :first_name, :last_name, :url)
    render json: member_json
  end

  # GET /member
  def index
    members = Member.all.all_friends.select('members.id, first_name, last_name, shortened_url, COUNT(member_friendships) as friends').group('members.id')
    return render json: members
  end

  # GET /member/:id
  def show
    member = Member.find_by(id: params[:id])
    if member.blank?
      render status: 404, json: {
        error: "Member not found not"
      }
      return
    end

    attributes = member.attributes
    # This will produce an extra query
    base_url = request.base_url
    attributes[:friend_links] = member.friend_links(base_url)
    return render json: attributes
  end

  private

  def new_member_params
    params.require(:member).permit(:first_name, :last_name, :url)
  end
end
