class User < ActiveRecord::Base
  has_many :events
  has_secure_password
  before_save :set_downcase

  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, on: :update, if: :set_password?
  validates :full_name, length: { maximum: 20 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }

  def set_downcase
  	self.email.downcase!
  	self.full_name.downcase!
  end

  def set_password?
  	self.password || !self.password_confirmation.empty?
  end
end

