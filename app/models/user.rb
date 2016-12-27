class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many  :category_users
  has_many :categories, through: :category_users
  has_many :rateds
  def admin?
    self.admin
  end

  after_create :add_event
  def add_event
    # Create a client object.
    client = PredictionIO::EventClient.new(ENV["PIO_ACCESS_KEY"], ENV["PIO_EVENT_SERVER_URL"])

    # Create a new user
    client.create_event(
      '$set',
      'user',
      self.id.to_s
    )
  end
end
