class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @surfspot1 = Surfspot.find_by(name: "Praia de Supertubos")
    @surfspots = Surfspot.all.sample(5)

    @surfspots_favourites = Favourite.all.where(user: current_user)

    @posts = Post.all.sample(3)
  end
end
