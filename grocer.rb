require 'pry'

def consolidate_cart(cart)
  consolidated = {}
  
  cart.each do |items|
    items.each do |name, attributes|
      consolidated[name] = {price: attributes[:price], clearance: attributes[:clearance], count: cart.count(items)}
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  applied_coupons = {}
  coupons.each do |coupon|
    coupon.each do |key, value|
      if cart.has_key?(coupon[:item])
        if cart[coupon[:item]][:count] >= coupon[:num]
          
          counted = cart[coupon[:item]][:count] / coupon[:num]
          
          cart[coupon[:item]][:count] =  cart[coupon[:item]][:count] % coupon[:num]
          applied_coupons["#{coupon[:item]} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: counted}
          #binding.pry
        end
      end
    end
  end
  
  if applied_coupons.size >= 1
    cart.merge!(applied_coupons)
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, attributes|
      if attributes[:clearance] == true
        new_price = minus_20_percent(attributes[:price])
        attributes[:price] = new_price
      end
    end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |name, attributes|
    total += (attributes[:price] * attributes[:count])
  end
 # binding.
 if total > 100
   total = (total - (total * 0.10))
 end
  total
end


cart = [
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}},
  {"BEETS"  => {:price => 2.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
  {"CHEESE" => {:price => 6.50, :clearance => false}},
]

coupons = [
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "BEER", :num => 2, :cost => 20.00},
      {:item => "CHEESE", :num => 3, :cost => 15.00}
    ]


def minus_20_percent(price)
  twenty_percent = price * 0.20
  #binding.pry
  return (price - twenty_percent)
end

