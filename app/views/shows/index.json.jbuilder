json.array!(@shows) do |show|
  json.extract! show, :id, :name, :network_id, :hulu, :netflix, :itunes, :amazon
end
