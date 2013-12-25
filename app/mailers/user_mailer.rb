class UserMailer < ActionMailer::Base
  #default from: "from@example.com"

  def registration_confirmation(user)
  	@user=user
  	#attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => user.email, :subject => "Registered", :from => "eifion123@asciicasts.com")
  end

end
