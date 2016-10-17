class EventsController < ApplicationController
  before_action :authorize
  

  def index
    user_id = set_user_id(params[:by_user])
    @events = Event.set_by_day(params[:day], user_id, params[:offset])
  end

  def edit
    @event = Event.find(params[:id])
    redirect_to event_path unless @event.user_id == session[:user_id]
  end

  def new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = session[:user_id]
    if @event.save
      head :ok
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    @repeats = Event.repeats_human
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      head :ok
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    head :no_content
  end


  private

  def set_user_id(param)
    param == 'true' ? session[:user_id] : 0
  end

  def event_params
    params.require(:event).permit(:title, :date_start, :last_day_of_month, :date_end, :repeat, :user_id)
  end
end
