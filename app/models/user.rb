class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :pets, dependent: :destroy
  has_many :homes, dependent: :destroy
  has_many :guest_reservations, class_name: 'Reservation', foreign_key: 'guest_id'
  has_many :host_reservations, class_name: 'Reservation', foreign_key: 'host_id'
  has_many :guest_reviews, class_name: 'Review', foreign_key: 'guest_id'
  has_many :notifications, foreign_key: :recipient_id
  has_one_attached :dni_photo
  has_one_attached :profile_photo
  after_commit :add_default_profile_photo, on: %i[create update]

  validates :name, :birthdate, :address, presence: true
  validates :phone, length: { is: 10 }
  validate :validate_profile_photo 
  validate :validate_dni_photo 
  
  validate :create_notifications

  enum role: { guest: 0, host: 1, admin: 2 }
  
  private 
  def validate_profile_photo 
    unless profile_photo and profile_photo.content_type =~ /^image\/(jpeg|pjpeg|gif|png|bmp)$/ 
      errors.add(:profile_photo, "Not a valid image") 
    end 
  end

  private
  def validate_dni_photo
    if role=="host"
      unless dni_photo and dni_photo.content_type =~ /^image\/(jpeg|pjpeg|gif|png|bmp)$/ 
        errors.add(:dni_photo, "Not a valid image") 
      end
    end 
  end

  def profile_photo_thumbnail 
    if profile_photo.attached?
      profile_photo.variant(resize: '150x150!').processed
    else 
      '/default-profile.jpg'
    end  
  end

  def create_notifications
    if self.host? and !self.verified?
      User.where(role: 2).each do |admin|
        msg = "Un nuevo anfitrión necesita ser verificado"
        Notification.create(recipient: admin, notifiable: self, text: msg)
      end
    end
  end

  private

  def add_default_profile_photo 
    unless profile_photo.attached?
      profile_photo.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'default-profile.jpg'
           )
          ), 
           filename: 'default-profile.jpg',
          content_type: 'image/jpg'
        )
    end
  end  
end
