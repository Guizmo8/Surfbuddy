
require "open-uri"
require_relative '../app/services/spot_scraper'

Surfspot.destroy_all
scraper = SpotScraper.new
scraper.scrape_and_seed
puts "created #{Surfspot.all.count} surf spots"


# User creation
User.destroy_all
user_1 = User.create!(email: "surfer1@example.com", password: "password123", first_name: "Gui", last_name: "Olivier", surf_level: "intermediate", phone_number: "+33665151713")
user_2 = User.create!(email: "surfer2@example.com", password: "password123", first_name: "Afonso", last_name: "Mela", surf_level: "expert", phone_number: "+351914021271")
user_3 = User.create!(email: "surfer3@example.com", password: "password123", first_name: "Gonçalo", last_name: "Ferreira", surf_level: "beginner", phone_number: "+35191081631")
user_4 = User.create!(email: "surfer4@example.com", password: "password123", first_name: "Sophia", last_name: "Bennet", surf_level: "beginner", phone_number: "+351111111")
user_5 = User.create!(email: "surfer5@example.com", password: "password123", first_name: "Liam", last_name: "Harrison", surf_level: "beginner", phone_number: "+351111111")
user_6 = User.create!(email: "surfer6@example.com", password: "password123", first_name: "Isabella", last_name: "Anderson",surf_level: "beginner", phone_number: "+351111111")
user_7 = User.create!(email: "surfer7@example.com", password: "password123", first_name: "Mason", last_name: "Carter", surf_level: "beginner", phone_number: "+351111111")
user_8 = User.create!(email: "surfer8@example.com", password: "password123", first_name: "Ava", last_name: "Collins", surf_level: "beginner", phone_number: "+351111111")
user_9 = User.create!(email: "surfer9@example.com", password: "password123", first_name: "James", last_name: "Turner", surf_level: "beginner", phone_number: "+351111111")
user_10 = User.create!(email: "surfer10@example.com", password: "password123", first_name: "Mia", last_name: "Hughes", surf_level: "beginner", phone_number: "+351111111")

puts "created #{User.all.count} users"


# Uploading pictures to user_1 to user_3

file_1 = URI.open("https://photos.smugmug.com/C/EMPRESAS/LeWagon/n-Pmb29k/20240731-Le-Wagon-mug-shots/i-4BGdwk8/0/MfHX6G6X5XHw4MtPhmGNbXW9DS2r3H7mGDkQWtQpt/X3/240731%20Le%20Wagon_41-X3.jpg")
user_1.photo.attach(io: file_1, filename: "profilepic.png", content_type: "image/png")
user_1.save


file_2 = URI.open("https://photos.smugmug.com/C/EMPRESAS/LeWagon/n-Pmb29k/20240731-Le-Wagon-mug-shots/i-MxKvCNk/0/NTprJ3V79XDXB2QR5FR83PsVqTqj3VJXzp2VQMKS8/X3/240731%20Le%20Wagon_57-X3.jpg")
user_2.photo.attach(io: file_2, filename: "profilepic.png", content_type: "image/png")
user_2.save


file_3 = URI.open("https://photos.smugmug.com/C/EMPRESAS/LeWagon/n-Pmb29k/20240731-Le-Wagon-mug-shots/i-MDZtNDc/0/NXr9FKmWzc64ngNM99LhQb5gxHfwNM2Xf93HKJK2Q/X3/240731%20Le%20Wagon_51-X3.jpg")
user_3.photo.attach(io: file_3, filename: "profilepic.png", content_type: "image/png")
user_3.save


puts "photos attached"
