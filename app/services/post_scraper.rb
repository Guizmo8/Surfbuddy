class PostScraper
  require 'nokogiri'
  require 'open-uri'

  def scrape_beachcam_details(surf_spot, beachcam_url)
    html = URI.open(beachcam_url)
    doc = Nokogiri::HTML(html)

    doc.css('.liveCamsDetailAside__weather-bottom').each do |post_element|
      info_hash = {}
      post_element.css('.liveCamsDetailAside__weather-col-inside').each do |element|
        info_hash[element.css('label').text.strip] = element.css('p').text.strip
      end

      # Create a post associated with the current spot
      @post = surf_spot.posts.new(
        wave_period: info_hash['Período das ondas'],
        wave_direction: info_hash['Direção das ondas'],
        wind: info_hash['Vento'],
        wind_direction: info_hash['Direção do vento'],
        ripple: info_hash['Ondulação'],
        sea_temperature: info_hash['Temp. do mar'].gsub(" ", ""),
        tide: info_hash['Maré']
      )

      call_data_science_api if surf_spot.name == "Praia Grande"

      puts "Created 1 post for #{surf_spot.name}" if @post.save
    end
  end

  private

  def call_data_science_api
    # Call the API of the Data Science group.
    endpoint = "https://sqm-api4-424861682907.europe-west1.run.app/get_beach_data?beach_code=praiagrande"
    response = JSON.parse(URI.open(endpoint).read)

    data = JSON.parse(response)

    # The difference of these dates is in miliseconds, so we need to divide it by 1000 to have a value in seconds
    time_analysed = (data['Finish_Date']['0'] - data['Start_Date']['0']) / 1000
    wave_period = (data['N_of_Waves']['0'] / time_analysed).round

    @post.assign_attributes(wave_period: "#{wave_period}s")

    puts "Called the Data Science group's API for Praia Grande"
  end
end
