require 'rest-client'
class PointsController < ApplicationController
  include Retriever

  def show
    render json: weather_for_random_locations(params[:points])
  end
end
