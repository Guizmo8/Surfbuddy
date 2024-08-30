class FavouritesController < ApplicationController
  def index
    @favourites = Favourite.all.where(user: current_user)
  end

  def create
    @surfspot = Surfspot.find(params[:surfspot_id])
    @user = current_user
    @favourite = Favourite.new(user: @user, surfspot: @surfspot, alert: true)

    if @favourite.save
      redirect_to surfspot_path(@surfspot)
    end
  end

  def change_fav_alert_pref
    @surfspot = Surfspot.find(params[:surfspot_id])
    @user = current_user
    @favourite = Favourite.find_by(user: @user, surfspot: @surfspot)
    @favourite.set_alert # this method is defined in the fav model
    redirect_to surfspot_path(@surfspot)
  end

  def destroy
    @surfspot = Surfspot.find(params[:surfspot_id])
    @favourite = Favourite.where(user: current_user).where(surfspot: @surfspot).first
    @favourite.destroy
    redirect_to surfspot_path(@surfspot)
  end

  def my_feed
    @favourites = Favourite.where(user: current_user)
  end
end
