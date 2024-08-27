class SpotScraper
  require 'nokogiri'
  require 'open-uri'

  LIVECAMS_URL = 'https://beachcam.meo.pt/livecams/'
  BEACHES_URL = 'https://beachcam.meo.pt/praias/'

  def scrape_and_seed
    livecams_html = URI.open(LIVECAMS_URL)
    livecams_doc = Nokogiri::HTML(livecams_html)

    beaches_html = URI.open(BEACHES_URL)
    beaches_doc = Nokogiri::HTML(beaches_html)

    beaches_doc.css('.beachesGrid__list-item-link').each do |element|
      livecams_doc.css('.liveCamsGrid__list-item-link').each do |spot_element|
        next unless strip_url(element['href']) == strip_url(spot_element['href'])

        name = element.css('.beachesGrid__list-item-name').text.strip
        location = element.css('.beachesGrid__list-item-location').text.strip

        image_element = element.css('.beachesGrid__list-item-image img').first
        image_url = image_element['src'] if image_element

        beachcam_url = spot_element['href']

        surf_spot = Surfspot.find_or_create_by(name:) do |spot|
          spot.location = location
          spot.image_url = image_url
        end

        # Visit each beach page and scrape additional information
        scraper = PostScraper.new
        scraper.scrape_beachcam_details(surf_spot, beachcam_url) if beachcam_url
      end
    end
  end

  private

  def strip_url(url)
    uri = URI.parse(url)
    path = uri.path

    segment = path.split('/').reject(&:empty?).last

    return segment
  end
end
