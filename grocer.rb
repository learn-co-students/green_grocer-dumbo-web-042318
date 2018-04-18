require "pry"

def consolidate_cart(cart)
  keys = []
  consolidate_cart = {}
  cart.each do |x|
    x.each do |k, v|
      keys << k
      consolidate_cart[k] = v
      #binding.pry
    end
  end
  
  cart.map do |x|
    x.map do |k, v|
      consolidate_cart[k][:count] = keys.count(k)
    end
  end
  consolidate_cart
  #binding.pry
end

def apply_coupons(cart, coupons)
  new_cart = {}
  
  cart.each do |key, value|
    coupons.each do |x|
      if key == x[:item] && x[:num] <= value[:count]
        cart[key][:count] -= x[:num] 
        if new_cart["#{key} W/COUPON"]
          new_cart["#{key} W/COUPON"][:count] += 1
        else
          new_cart["#{key} W/COUPON"] = {
            :price => x[:cost],
            :clearance => value[:clearance],
            :count => 1,
          }
        #binding.pry
        end
      end
    end
    new_cart[key] = value
  end
  new_cart
  #binding.pry
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance] == true
      discount = value[:price] * 0.2
      cart[key][:price] -= discount.round(3) 
      #binding.pry 
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
    #binding.pry
  end
  
  i = 0 
  price = 0
  while i < prices.size
    price += prices[i]
    i += 1
  end
  
  if price > 100
    discount = price * 0.1
    price -= discount.round(2)
  end
  
  price
  #binding.pry
end
