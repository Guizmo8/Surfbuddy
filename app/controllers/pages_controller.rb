class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @surfspot = Surfspot.where(name: "Praia das Bicas")[0]
  end

end
