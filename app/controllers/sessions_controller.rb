class SessionsController < ApplicationController
  before_action :authorize, only: [:destroy]
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/calendar'
    else
      @error = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
     respond_to do |format|
      format.html {}
      format.json { render json: @current_user }
    end
  end
end
