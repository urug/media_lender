require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :movies
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
    
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_accessor :invite_token
    
  validates_presence_of     :first_name, :last_name, :login, :email
  validates_presence_of     :password,                                          :if => :password_required?
  validates_presence_of     :password_confirmation,                             :if => :password_required?
  validates_confirmation_of :password,                                          :if => :password_required?
  validates_length_of       :password,  :allow_blank => true, :within => 4..40, :if => :password_required?
  validates_length_of       :login,     :allow_blank => true, :within => 3..40
  validates_uniqueness_of   :login,     :allow_blank => true, :case_sensitive => false
  validates_presence_of     :token
  validates_uniqueness_of   :token
  
  before_save :encrypt_password
  before_validation :generate_token
  after_create :add_as_friend_to_invitor
  
  def add_friend(friend)
    friendship = friendships.build(:friend_id => friend.id)
    if !friendship.save
      logger.debug "User '#{friend.email}' already exists in the user's friendship list."
    end
  end
  
  def full_name
    [first_name, last_name].join(" ")
  end
    
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
  
  def find_friends_movie_by_id(movie_id)
    movie = Movie.find(movie_id)
    if movie
      if friends.include? movie.user
        movie
      else
        nil
      end
    else
      nil
    end
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
    
    def generate_token
      self.token ||= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")
    end
    
    def add_as_friend_to_invitor
      if !self.invite_token.blank?
        invitor = User.find_by_token(self.invite_token)
        if invitor
          invitor.add_friend(self)
        end
      end
    end
    
end
