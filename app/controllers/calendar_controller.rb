class CalendarController < ApplicationController
  before_action :authorize
  def index
    respond_to do |format|
      format.html {}
      format.json do
        @calendar = Calendar.new(params[:year] || Time.now.year,
        params[:month] || Time.now.month, by_user?(params[:by_user]))
        render json: @calendar 
      end
    end
  end

  private

  def by_user?(param)
    param == 'true' ? session[:user_id] : 0
  end
end
