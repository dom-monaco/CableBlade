class CalculationController < ApplicationController
  def results
    shows = Show.find(params[:shows])
    @purchases, @unavailable = optimal_purchases(shows)
    @total_cost = total_cost(@purchases)
  end

  private

  # Returns the optimal strategy for purchasing a given set of shows.
  def optimal_purchases(shows)
    # Iterate through shows, grouping them
    grouped, ungrouped, unavailable = first_pass(shows)
    # Solve recursively, if necessary
    grouped = solve_recursively(grouped, ungrouped) unless ungrouped.empty?

    [grouped, unavailable]
  end

  def first_pass(shows)
    grouped = Hash.new { |h,k| h[k] = [] }
    ungrouped, unavailable = [], []

    shows.each do |show|
      best_service, best_price = show.purchase_prices.min_by { |_,v| v }
      subscription_options = show.available_subscriptions

      # No more work if subscription options aren't available
      if subscription_options.empty?
        if best_service.nil?
          unavailable << show
        else
          grouped[best_service] << show
        end
      elsif best_service.nil? && subscription_options.length == 1
        # Shortcut to add required subscriptions in first pass
        grouped[subscription_options.first] << show
      else # Otherwise, add to `ungrouped` for next pass(es)
        ungrouped << [show, best_service, best_price, subscription_options]
      end
    end
    [grouped, ungrouped, unavailable]
  end

  # Returns the shows grouped by ideal service.
  # Builds arrays of bought/remaining subscriptions and shows, then uses
  # `best_purchases` to recursively determine the best subscriptions to buy.
  # The remaining shows are added to the `grouped` hash, which is returned.
  def solve_recursively(grouped, ungrouped)
    subs_bought = grouped.keys & Show::SUBSCRIPTION_COLUMNS
    subs_remaining = Show::SUBSCRIPTION_COLUMNS - subs_bought

    # Create an array of the remaining shows
    unsolved = ungrouped.select { |s| (s.last & subs_bought).empty? }

    # Find the optimal set of subscriptions to purchase
    subs_bought += best_purchases(unsolved, subs_remaining)[1]

    # Group shows by service, purchasing them individually when needed
    ungrouped.each do |show, service, price, subs|
      group = subs.find { |s| subs_bought.include?(s) } || service
      grouped[group] << show
    end

    grouped
  end

  # A recursive method which finds the best combination of subscriptions to
  # purchase.
  def best_purchases(unsolved, subs_remaining)
    return [0, []] if unsolved.empty?

    if subs_remaining.empty?
      price = unsolved.reduce(0) { |m,o| m + o[2] }
      return [price, []]
    end

    subs_after = subs_remaining.dup
    sub = subs_after.shift
    unsolved_with = unsolved.reject { |s| s.last.include?(sub) }

    price_with, best_with = best_purchases(unsolved_with, subs_after)
    price_with += Show::SUBSCRIPTION_PRICES[sub]
    best_with << sub

    price_without, best_without = best_purchases(unsolved, subs_after)

    if price_with <= price_without
      [price_with, best_with]
    else
      [price_without, best_without]
    end
  end

  def total_cost(purchases)
    total = 0
    purchases.each do |service, shows|
      if service.in? Show::SUBSCRIPTION_COLUMNS
        total += Show::SUBSCRIPTION_PRICES[service]
      else
        shows.each { |s| total += s.send(service) }
      end
    end

    total
  end
end
