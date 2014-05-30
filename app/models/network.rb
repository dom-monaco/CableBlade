class Network < ActiveRecord::Base
  has_many :shows, inverse_of: :network
end
