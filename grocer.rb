require 'pry'

def consolidate_cart(cart)
  # code here
  keysHash = Hash.new(0)
  ans = {}

  cart.each do |hash|
    hash.keys.each do |key|
      keysHash[key] += 1
    end

    hash.each do |item, description|
      description[:count] = keysHash[item]
      ans.merge!(item => description)
    end
  end
  return ans
end

def apply_coupons(cart, coupons)
  # code here
  cart.keys.each do |key|
    coupons.each do |coupon|
      if coupon.values.include?(key) && cart["#{key} W/COUPON"] == nil 
        cart["#{key} W/COUPON"] = {:price => coupon[:cost],
        :clearance => cart[key][:clearance],
        :count => 1}
        cart[key][:count] -= coupon[:num]
      elsif coupon.values.include?(key) && cart[key][:count] > coupon[:num]
        cart["#{key} W/COUPON"][:count] += 1
        cart[key][:count] -= coupon[:num]
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, hash|
    if hash[:clearance]
      hash[:price] = (hash[:price]*0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here

  hashCart = consolidate_cart(cart)
  apply_coupons(hashCart, coupons)
  apply_clearance(hashCart)
  price = 0
  hashCart.values.each do |item|
    price += (item[:price] * item[:count])
  end
  if price > 100
    price = (price * 0.9)
  end
  return price

end
