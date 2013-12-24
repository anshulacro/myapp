class AuthenticationsController < ApplicationController

	def create
	  auth = request.env["omniauth.auth"]
	 
	  # Try to find authentication first
	  authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
	 
	  if authentication
	  	session[:user_id]=authentication.user_id
	    # Authentication found, sign the user in.
	    flash[:notice] = "Signed in successfully."
	    redirect_to "/home"
	  else
	    # Authentication not found, thus a new user.
	    user = User.new
	    user.apply_omniauth(auth)
	    if user.save(:validate => false)
	       session[:user_id]=user.id
	      flash[:notice] = "Account created and signed in successfully."
	      redirect_to "/home"
	    else
	      flash[:error] = "Error while creating a user account. Please try again."
	      redirect_to root_url
	    end
	  end
	end


	def omniauth_failure
		redirect_to root_url
	end

end
