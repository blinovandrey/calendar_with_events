class RepeatsController < ApplicationController
  before_action :authorize
  def index
    @repeats = Event.repeats_human
    render json: @repeats
  end
end
