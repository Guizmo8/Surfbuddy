namespace :scraper do
  desc "Scrape and seed data from the BeachCam website"
  task scrape_beachcam: :environment do
    scraper = SpotScraper.new
    scraper.scrape_and_seed
    puts "Scraped finished!"

  rescue => error
    puts "An error occurred: #{error.message}"

  end
end
