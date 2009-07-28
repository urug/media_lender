class UsersController < ApplicationController
  
  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user.invite_token = session[:invite_token]
    respond_to do |format|
      if @user.save
        session[:invite_token] = nil
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to new_session_path }
      else
        format.html { render :action => :new }
      end
    end
  end
  
  def pickup_invitation
    invite_token = params[:invite_token]
    invitor = User.find_by_token(invite_token)
    if invitor
      session[:invite_token] = invite_token
      flash[:notice] = "Please sign up below to accept the invitation sent by #{invitor.full_name}."
    else
      flash[:notice] = "We're sorry but that invitation code is not valid. Please sign up below."
    end
    redirect_to new_user_path
  end
  
  
end
