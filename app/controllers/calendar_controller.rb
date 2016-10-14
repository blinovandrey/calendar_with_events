class CalendarController < ApplicationController
  before_action :authorize
  def index
    respond_to do |format|
      format.html {}
      format.json do
        @calendar = Calendar.new(params[:year] || Time.now.year,
        params[:month] || Time.now.month,
        params[:by_user] == 'true' ? session[:user_id] : 0)
        render json: @calendar 
      end
    end
  end
end
