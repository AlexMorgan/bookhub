class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :books_owned, dependent: :destroy, class_name: 'Book'
  has_many :books_bought, dependent: :destroy, class_name: 'Book', foreign_key: :buyer_id
  has_many :books, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :needs, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>",small: "50x50>", :tiny => "25x25>" }, :default_url => ActionController::Base.helpers.asset_path('missing.png')
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  ## If we wanted to validate that all users had an avatar
  # validates :avatar, :attachment_presence => true

  validates :username, presence: true, uniqueness: true
  validates_formatting_of :firstname, :using => :alpha
  validates_formatting_of :lastname, :using => :alpha
  validates_formatting_of :phone, :using => :us_phone, allow_nil: true
  validates :email, presence: true, format: { with: /(@dukes.jmu.edu)/,
    message: "%{value} is not a valid JMU email" }

  def self.years
    %w(Freshman Sophomore Junior Senior)
  end

  def fullname
    "#{firstname.capitalize} #{lastname.first.capitalize}."
  end

end
