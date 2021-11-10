class V1::MemberController < ApplicationController
  # POST /v1/member
  def new
    member = Member.new(new_member_params)
    begin
      member.save!
    rescue StandardError => ex
      render json: {
        error: ex
      }
      return
    end

    render json: member
  end

  # GET /v1/member
  def index
    members = Member.all

    return render json: members
  end

  # GET /v1/member/:id
  def show
    member = Member.find_by(id: params[:id])
    if member.blank?
      render json: {
        error: "Member not found not"
      }
      return
    end
    return render json: member
  end

  private

  def new_member_params
    params.permit(:name, :personal_website)
  end
end
