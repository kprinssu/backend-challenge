class ShortenUrl < ApplicationJob

  rescue_from(StandardError) do |exception|
    member_id = arguments[0]
    personal_website = arguments[1]
    Rails.logger.error "Website shortening failed for member_id=#{member_id}, website=#{personal_website} with exception #{exception}"
    Rails.logger.error exception.backtrace
  end

  def perform(member_id, personal_website)
    client = Bitly::API::Client.new(token: Rails.application.secrets.bitly[:token])
    bitlink = client.shorten(long_url: personal_website)
    shortened_url = bitlink.link

    ActiveRecord::Base.connection_pool.with_connection do
      member = Member.find_by(id: member_id)
      member.update(shortened_url: shortened_url)
    end
  end
end
