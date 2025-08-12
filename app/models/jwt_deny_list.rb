class JwtDenyList < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
end
