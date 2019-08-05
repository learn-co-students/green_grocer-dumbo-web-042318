def consolidate_cart(cart)
  keys = []
  consolidated_cart = {}
  cart.each do |items|
    items.each do |key, value|
      keys << key
      consolidated_cart[key] = value
    end
  end

  cart.map do |items|
    items.map do |key, value|
      consolidated_cart[key][:count] = keys.count(key)
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  new_cart = {}

  cart.each do |key, value|
    coupons.each do |coupon|
      if key == coupon[:item] && coupon[:num] <= value[:count]
        cart[key][:count] -= coupon[:num] 
        if new_cart["#{key} W/COUPON"]
          new_cart["#{key} W/COUPON"][:count] += 1
        else
          new_cart["#{key} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => value[:clearance],
            :count => 1,
          }
        end
      end
    end
    new_cart[key] = value
  end
  new_cart
end

def apply_clearance(cart)
   cart.each do |key, value|
    if value[:clearance] == true
      discount = value[:price] * 0.2
      cart[key][:price] -= discount
    end
  end
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)

  with_coupons = apply_coupons(consolidated, coupons)

  clearance = apply_clearance(with_coupons)

  prices = []

  clearance.map do |key, value|
      prices << value[:price] * value[:count]
  end

  i = 0 
  price = 0
  while i < prices.size
    price += prices[i]
    i += 1
  end

  if price > 100
    discount = price * 0.1
    price -= discount
  end

  price
end
