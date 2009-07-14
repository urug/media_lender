class AccountsController < ApplicationController
  before_filter :authenticate
  
  # GET /account/edit
  def edit
    @account = current_user
  end
  
  # PUT /account
  def update
    @account = current_user
    
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to :action => :edit }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
end
