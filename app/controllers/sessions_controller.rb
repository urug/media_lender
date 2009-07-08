class SessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy
  
  def new
  end

  def create
    session.clear
    
    if user = User.authenticate(params[:login], params[:password])
      self.current_user = user
      redirect_back_or_default(movies_path)
    else
      @login = params[:login]
      flash[:notice] = "Login/password incorrect"
      render :action => :new
    end
  end

  def destroy
    reset_session
    
    redirect_to :action => :new
  end
  
end
