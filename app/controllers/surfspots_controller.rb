class SurfspotsController < ApplicationController
  def index
    @surfspots = Surfspot.all
  end

end
