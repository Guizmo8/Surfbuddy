class SurfspotsController < ApplicationController
  def index
    @surfspots = Surfspot.all
    if params[:query].present?
      @surfspots = Surfspot.super_search(params[:query])
    end
  end

  def show
    @user = current_user
    @surfspot = Surfspot.find(params[:id])
    @posts = @surfspot.posts
  end
end
