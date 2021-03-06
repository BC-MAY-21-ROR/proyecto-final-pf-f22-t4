class Home < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many_attached :photos

  validates :title, :address, :description, :price, presence: true
  validate :verified_user?

  scope :filter_by_price_lower, -> { order :price }
  scope :filter_by_price_higher, -> { order price: :desc }
  scope :filter_by_score, -> { order score: :desc }
  scope :filter_by_date, -> { order created_at: :desc }

  def verified_user?
    errors.add('Debes estar verificado para registrar casas') unless user.verified?
  end

  def self.search_filter(filtering_param)
    results = self.where(nil)
    results = results.public_send("filter_by_#{filtering_param}")
    results
  end

  def self.update_score(home)
    reviews = Review.where(home_id: home.id)
    score = 0
    reviews.each { |review| score += review.score }
    home.update(score: (score/reviews.size))
  end
end
