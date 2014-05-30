class Show < ActiveRecord::Base
  belongs_to :network, inverse_of: :shows

  # Change these constants if services are added to the show table
  INDIVIDUAL_PURCHASE_COLUMNS = [:itunes, :amazon]
  SUBSCRIPTION_COLUMNS        = [:hulu, :netflix]

  # Change these if prices change
  SUBSCRIPTION_PRICES = {
    hulu: 7.99,
    netflix: 7.99
  }

  SERVICE_DISPLAY_NAMES = {
    hulu: 'Hulu',
    netflix: 'Netflix',
    itunes: 'iTunes',
    amazon: 'Amazon'
  }

  def purchase_prices
    INDIVIDUAL_PURCHASE_COLUMNS.each_with_object({}) do |name, prices|
      price = send(name)
      prices[name] = price if price && price > 0
    end
  end

  def available_subscriptions
    SUBSCRIPTION_COLUMNS.select { |name| send(name) }
  end
end
