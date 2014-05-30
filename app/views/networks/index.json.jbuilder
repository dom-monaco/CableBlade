json.array!(@networks) do |network|
  json.extract! network, :id, :name, :image
end
