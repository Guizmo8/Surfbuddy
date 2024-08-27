require_relative '../app/services/spot_scraper'

Surfspot.destroy_all
scraper = SpotScraper.new
scraper.scrape_and_seed
puts "created #{Surfspot.all.count} surf spots"
