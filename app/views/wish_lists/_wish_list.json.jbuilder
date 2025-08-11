json.extract! wish_list, :id, :user_id, :product_id, :created_at, :updated_at
json.url wish_list_url(wish_list, format: :json)
