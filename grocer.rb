require "pry"

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |key, value|
      new_cart[key] = {:price=>value[:price], :clearance=>value[:clearance], :count=>cart.count(item)}
    end
  end
  new_cart
end

# def apply_coupons(cart, coupons)
#   new_cart = {}
#    cart.each do |item|
#      item.each do |key, value|
#        if key == coupon[:item]
#          new_cart[key] = {:price=>value[:price], :clearance=>value[:clearance], :count=>(value[:count] - coupon[:num])}
#          new_cart[key + " W/COUPON"] = {:price=>coupon[:cost], :clearance=>value[:clearance], :count=>(value[:count]-coupon[:num])}
#        else
#          new_cart[key] = value
#        end
#      end
#    end
#    new_cart
# end

def apply_coupons(cart, coupons)
  applied_coupons = {}

    coupons.each do |coupon|
    coupon.each do |key, value|
      if cart.has_key?(coupon[:item])
        if cart[coupon[:item]][:count] >= coupon[:num]
          counted = cart[coupon[:item]][:count]/coupon[:num]

          cart[coupon[:item]][:count] = cart[coupon[:item]][:count]% coupon[:num]
          applied_coupons["#{coupon[:item]} W/COUPON"] = {:price=>coupon[:cost],:clearance=>cart[coupon[:item]][:clearance], :count=>counted}
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
      attributes[:price] = (attributes[:price] - (attributes[:price]*0.20))
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
    if total > 100
      total = (total - (total * 0.10))
    end
  total
end
