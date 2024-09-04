class SpotScraper
  require 'nokogiri'
  require 'open-uri'
  require 'beaches'

  BEACHES_URL = "https://beachcam.meo.pt/praias/" # Image, Name, Location, details_url

  def scrape_and_seed
    # Creating surfspot
    beaches_html = URI.open(BEACHES_URL)
    beaches_doc = Nokogiri::HTML(beaches_html)

    Beaches::LIST.each do |beach|
      beaches_doc.css('.beachesGrid__list-item-link').each do |element|
        next unless strip_url(element['href']) == beach[:beach_slug]

        name = element.css('.beachesGrid__list-item-name').text.strip
        location = element.css('.beachesGrid__list-item-location').text.strip
        image_element = element.css('.beachesGrid__list-item-image img').first
        image_url = image_element['src'] if image_element
        beach_detail_url = element['href'] # Grabbing to URL to open for each beach to get the description

        beach_detail_html = URI.open(beach_detail_url) # Description
        beach_detail_doc = Nokogiri::HTML(beach_detail_html)

        description_element = beach_detail_doc.css('.beachDetailHeader__description')
        description = description_element.map(&:text).join(" ").strip if description_element
        cleaned_description = description.gsub(/\s+/, ' ') if description

        surf_spot = Surfspot.find_or_create_by(name:) do |spot|
          spot.location = location
          spot.image_url = image_url
          spot.description = cleaned_description
        end

        # Seeding post for each surfspot created
        livecam_url = "https://beachcam.meo.pt/livecams/#{beach[:cam_slug]}" # Access to create a post

        scraper = PostScraper.new
        scraper.scrape_beachcam_details(surf_spot, livecam_url)
      end
    end
  end

  private

  def strip_url(url)
    uri = URI.parse(url)
    path = uri.path
    path.split('/').reject(&:empty?).last
  end
end
