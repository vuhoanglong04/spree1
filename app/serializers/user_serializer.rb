class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :gender, :date_of_birth, :phone_number, :bio, :image_url, :uid, :provider
end
