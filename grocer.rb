require 'pry'
def consolidate_cart(cart)
  # code here
  result = {}
  cart.each do |item|
    result[item.keys.first] = item.values.first
    if result[item.keys.first][:count].nil?
      result[item.keys.first][:count] = 0
    end
    result.each do |i|
      if i.first == result.keys.first
        result[item.keys.first][:count] += 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
    cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item|
    attributes = item[1]
    if attributes[:clearance]
      discount = attributes[:price] * 0.80
      attributes[:price] = discount.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each do |item|
    attributes = item[1]
    total += attributes[:price] * attributes[:count]
  end
  total > 100 ? (total * 0.90).round(2) : total
end
