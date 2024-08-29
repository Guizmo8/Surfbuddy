class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @surfspot1 = Surfspot.where(name: "Praia das Bicas")[0]
    @surfspots = Surfspot.all.sample(5)

    @surfspots_favourites = Favourite.where(user_id: current_user.id)

    @posts = Post.all.sample(3)
  end



end
