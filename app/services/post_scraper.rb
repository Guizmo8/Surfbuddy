class PostScraper
  require 'nokogiri'
  require 'open-uri'
  
  def scrape_beachcam_details(surf_spot, beachcam_url)
    html = URI.open(beachcam_url)
    doc = Nokogiri::HTML(html)

    doc.css('.liveCamsDetailAside__weather-bottom').each do |post_element|
      info_hash = {}
      post_element.css('.liveCamsDetailAside__weather-col-inside').each do |element|
        info_hash["#{element.css('label').text.strip}"] = element.css('p').text.strip
      end

      # Create a post associated with the current spot
      surf_spot.posts.create(
        wave_period: info_hash['Período das ondas'],
        wave_direction: info_hash['Direção das ondas'],
        wind: info_hash['Vento'],
        wind_direction: info_hash['Direção do vento'],
        ripple: info_hash['Ondulação'],
        sea_temperature: info_hash['Temp. do mar'].gsub(" ", ""),
        tide: info_hash['Maré']
      )

      puts "Created 1 post for #{surf_spot.name}"
    end
  end
end
