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

    respond_to do |format|
      if @user.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to new_session_path }
      else
        format.html { render :action => :new }
      end
    end
  end
  
end
