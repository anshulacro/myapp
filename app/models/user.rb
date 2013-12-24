class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :username, :email, :password, :password_confirmation


  before_save :encrypt_password
  after_save :clear_password


  attr_accessor :password
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true #password_confirmation attr
  validates_length_of :password, :in => 6..20, :on => :create
  
  has_many :authentications


  def encrypt_password
  	if password.present?
    self.salt = BCrypt::Engine.generate_salt
    self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
  	end
  end


	def clear_password
  		self.password = nil
	end


	def self.authenticate(username_or_email="", login_password="")
	  if  EMAIL_REGEX.match(username_or_email)    
	    user = User.find_by_email(username_or_email)
	  else
	    user = User.find_by_username(username_or_email)
	  end
	  if user && user.match_password(login_password)
	    return user
	  else
	    return false
	  end
	end   


	def match_password(login_password="")
  		encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
	end

	def apply_omniauth(auth)
  		# In previous omniauth, 'user_info' was used in place of 'raw_info'
  		self.email = auth['extra']['raw_info']['email']
  		# Again, saving token is optional. If you haven't created the column in authentications table, this will fail
  		authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
	end

end
