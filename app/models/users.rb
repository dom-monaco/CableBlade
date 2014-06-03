class Users < ActiveRecord::Base
  has_secure_password validations: false

end
