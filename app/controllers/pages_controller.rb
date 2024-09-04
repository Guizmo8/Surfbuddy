class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @surfspot1 = Surfspot.where(name: "Praia das Bicas")[0]
    @surfspots = Surfspot.all.sample(5)

    @surfspots_favourites = Favourite.all.where(user: current_user)

    @posts = Post.where(created_at: Time.zone.now.all_day).sample(3)
  end
end
