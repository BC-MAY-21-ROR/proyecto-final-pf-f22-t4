json.extract! home, :id, :title, :address, :description, :price, :score, :user_id, :created_at, :updated_at, :latitude, :longitude
json.url home_url(home, format: :json)
