class Trip
  include ActiveModel::Model

  attr_accessor :from, :to, :departure_at, :arrival_at
end
