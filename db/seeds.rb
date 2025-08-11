# db/seeds.rb

require 'faker'

# === Role ===
%w[Administrator User Staff].each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

# === Permission ===
actions = %w[index create update delete restore force_delete authorize]
subjects = %w[users products categories]
permissions = subjects.product(actions).map { |subject, action| { subject: subject, action: action } }
Permission.create!(permissions)

# === Role-Permission Assignment ===
admin = Role.find_by(name: "Administrator")
staff = Role.find_by(name: "Staff")
user = Role.find_by(name: "User")

Permission.find_each { |perm| RolePermission.find_or_create_by!(role: admin, permission: perm) }
Permission.where(action: %w[index update create]).find_each { |perm| RolePermission.find_or_create_by!(role: staff, permission: perm) }
Permission.where(action: "index").find_each { |perm| RolePermission.find_or_create_by!(role: user, permission: perm) }

# === Users ===
20.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: "123456",
    phone_number: Faker::PhoneNumber.phone_number,
    gender: %w[male female].sample,
    bio: Faker::Lorem.sentence,
    confirmed_at: Time.now,
    role_id: Role.pluck(:id).sample,
    image_url: Faker::Avatar.image,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65)
  )
end

# === Categories ===
10.times do
  Category.create!(
    name: Faker::Commerce.department(max: 1, fixed_amount: true),
    parent_id: Category.pluck(:id).sample
  )
end

# === Products ===
10.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    brand: Faker::Company.name,
    category_id: Category.pluck(:id).sample,
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['product']) # <== thêm image_url
  )
end

# === Colors ===
10.times do
  Color.create!(
    name: Faker::Color.color_name + rand(999).to_s,
    hex_code: Faker::Color.hex_color
  )
end

# === Sizes ===
%w[XS S M L XL].each do |size_name|
  Size.find_or_create_by!(name: size_name)
end

# === Product Variants ===
10.times do
  ProductVariant.create!(
    product_id: Product.pluck(:id).sample,
    size_id: Size.pluck(:id).sample,
    color_id: Color.pluck(:id).sample,
    price: Faker::Commerce.price(range: 10.0..100.0),
    stock: rand(10..100),
    sku: Faker::Alphanumeric.alphanumeric(number: 10).upcase,
    image_url: Faker::Avatar.image,
  )
end

# === Orders ===
10.times do
  Order.create!(
    user_id: User.pluck(:id).sample,
    status: %w[pending processing shipped delivered cancelled].sample,
    total_amount: Faker::Commerce.price(range: 50.0..1000.0),
    stripe_payment_id: Faker::Alphanumeric.alphanumeric(number: 20),
    created_at: Faker::Time.backward(days: 30),
    updated_at: Time.current,
    street: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    country: Faker::Address.country,
    phone_number: Faker::PhoneNumber.phone_number
  )
end

# === Order Items ===
10.times do
  order_id = Order.pluck(:id).sample
  variant = ProductVariant.find_by(id: ProductVariant.pluck(:id).sample)
  next if order_id.nil? || variant.nil?

  quantity = rand(1..5)
  OrderItem.create!(
    order_id: order_id,
    product_variant_id: variant.id,
    quantity: quantity,
    price: variant.price * quantity # <== dùng 'price', không 'unit_price'
  )
end
User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: "long@cc.cc",
  password: "123456",
  phone_number: Faker::PhoneNumber.phone_number,
  gender: %w[male female].sample,
  bio: Faker::Lorem.sentence,
  confirmed_at: Time.now,
  role_id: Role.pluck(:id).sample,
  image_url: Faker::Avatar.image,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
)
10.times do
  WishList.create!([
                     {
                       user_id: User.pluck(:id).sample,
                       product_id: Product.pluck(:id).sample
                     }
                   ])
end