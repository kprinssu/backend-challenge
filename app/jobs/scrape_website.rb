class ScrapeWebsite < ApplicationJob

  rescue_from(StandardError) do |exception|
    member_id = arguments[0]
    personal_website = arguments[1]
    Rails.logger.error "Website scraping failed for member_id=#{member_id}, website=#{personal_website} with exception #{exception}"
    Rails.logger.error exception.backtrace
  end

  def perform(member_id, personal_website)
    page = HTTParty.get(personal_website)
    nokogiri_page = Nokogiri::HTML(page)
    scraped_params = {
      h1: [],
      h2: [],
      h3: []
    }

    # Grab all H1 tags
    nokogiri_page.css('h1').each do |h1|
      scraped_params[:h1].append(h1.content.gsub(/\s+/, ""))
    end

    # Grab all H2 tags
    nokogiri_page.css('h2').each do |h2|
      scraped_params[:h2].append(h2.content.gsub(/\s+/, ""))
    end

    # Grab all H1 tags
    nokogiri_page.css('h3').each do |h3|
      scraped_params[:h3].append(h3.conten.gsub(/\s+/, ""))
    end

    puts scraped_params
    ActiveRecord::Base.connection_pool.with_connection do
      member = Member.find_by(id: member_id)
      member.update(scraped_params)
    end
  end
end
