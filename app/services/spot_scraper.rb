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
      name = element.css('.beachesGrid__list-item-name').text.strip
      location = element.css('.beachesGrid__list-item-location').text.strip
      image_element = element.css('.beachesGrid__list-item-image img').first
      image_url = image_element['src'] if image_element
      beach_detail_url = element['href']

      beach_detail_html = URI.open(beach_detail_url)
      beach_detail_doc = Nokogiri::HTML(beach_detail_html)

      description_element = beach_detail_doc.css('.beachDetailHeader__description')
      description = description_element.map(&:text).join(" ").strip if description_element
      cleaned_description = description.gsub(/\s+/, ' ') if description

      livecams_doc.css('.liveCamsGrid__list-item-link').each do |spot_element|
        next unless strip_url(element['href']) == strip_url(spot_element['href'])

        surf_spot = Surfspot.find_or_create_by(name:) do |spot|
          spot.location = location
          spot.image_url = image_url
          spot.description = cleaned_description
        end

        scraper = PostScraper.new
        scraper.scrape_beachcam_details(surf_spot, spot_element['href']) if spot_element['href']
      end
    end
  end

  private

  def strip_url(url)
    uri = URI.parse(url)
    path = uri.path
    segment = path.split('/').reject(&:empty?).last
    segment
  end
end
