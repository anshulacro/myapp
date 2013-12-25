class UsersController < ApplicationController
	before_filter :save_login_state, :only => [:new, :create]

   def new
    @user = User.new 
  end


  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id]=@user.id
      # UserMailer.registration_confirmation(@user).deliver
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
      redirect_to(:controller => 'sessions', :action => 'home')
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
      render "new"
    end
    
  end


end
