class SpotScraper
  require 'nokogiri'
  require 'open-uri'

  BASE_URL = 'https://beachcam.meo.pt/praias/'

  def scrape_and_seed
    html = URI.open(BASE_URL)
    doc = Nokogiri::HTML(html)

    doc.css('.beachesGrid__list-item-link').each do |spot|
      name = spot.css('.beachesGrid__list-item-name').text.strip
      address = spot.css('.beachesGrid__list-item-location').text.strip
      image_element = spot.css('.beachesGrid__list-item-image img').first
      photo = image_element['src'] if image_element

      Surfspot.find_or_create_by(name: name) do |surf_spot|
        surf_spot.address = address
        surf_spot.photo = photo
      end
    end
  end
end
