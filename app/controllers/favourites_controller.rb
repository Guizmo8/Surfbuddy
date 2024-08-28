class FavouritesController < ApplicationController
  def create
    @surfspot = Surfspot.find(params[:surfspot_id])
    @user = current_user
    @favourite = Favourite.new(user: @user, surfspot: @surfspot, alert: true)

    if @favourite.save
      redirect_to surfspot_path(@surfspot)
    end
  end

  def destroy
    @surfspot = Surfspot.find(params[:surfspot_id])
    @favourite = Favourite.where(user: current_user).where(surfspot: @surfspot).first
    @favourite.destroy
    redirect_to surfspot_path(@surfspot)
  end
end
