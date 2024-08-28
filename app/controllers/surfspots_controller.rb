class SurfspotsController < ApplicationController
  def index
    @surfspots = Surfspot.all
  end

  def show
    @surfspot = Surfspot.find(params[:id])
    @posts = @surfspot.posts
  end

end
