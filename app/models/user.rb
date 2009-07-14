require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :movies
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :first_name, :last_name, :login, :email
  validates_presence_of     :password,                                          :if => :password_required?
  validates_presence_of     :password_confirmation,                             :if => :password_required?
  validates_confirmation_of :password,                                          :if => :password_required?
  validates_length_of       :password,  :allow_blank => true, :within => 4..40, :if => :password_required?
  validates_length_of       :login,     :allow_blank => true, :within => 3..40
  validates_uniqueness_of   :login,     :allow_blank => true, :case_sensitive => false
  
  before_save :encrypt_password
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    user = User.find_by_login(login)
    user && user.authenticated?(password) ? user : nil
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
