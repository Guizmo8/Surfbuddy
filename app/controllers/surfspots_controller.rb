class SurfspotsController < ApplicationController
  def index
    @surfspots = Surfspot.all
  end

  def show
    @user = current_user
    @surfspot = Surfspot.find(params[:id])
  end

end
