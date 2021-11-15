require 'rails_helper'

describe 'Friendships', type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:headers) { { "Accept" => "application/json", 'Content-Type' => 'application/json' } }

  describe 'creating a friendship' do
    subject { post '/friendships', params: params.to_json, headers: headers }

    context 'with valid params' do
      let(:params) do
        {
          friendship: {
            member_id: 1,
            friend_id: 2,
          }
        }
      end

      it 'returns the correct status code when the members do not exist' do
        subject
        expect(response).to have_http_status(422)
      end

      it 'returns the correct status code' do
        # There is validation to make sure the members exist
        friend = create :alan_smith
        member = create :becky_smith

        params[:friendship][:friend_id] = friend.id
        params[:friendship][:member_id] = member.id

        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'with empty params' do
      let(:params) { {} }

      it 'returns the correct status code' do
        subject
        expect(response).not_to have_http_status(:success)
      end
    end
  end
end
