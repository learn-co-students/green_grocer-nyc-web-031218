require "pry"

def consolidate_cart(cart)
  new_cart = {}
  cart = cart.group_by(&:itself)


  cart.map do |key_hash, value_hash|
    key_hash.map do |key, value|
      new_cart[key] = value.merge(count: value_hash.length)
    end
  end

new_cart
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon_hash|
    name = coupon_hash[:item]
    if cart[name] && cart[name][:count] >= coupon_hash[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:price => coupon_hash[:cost], :clearance => cart[name][:clearance], :count => 1}
      end
      cart[name][:count] -= coupon_hash[:num]
    end
  end

  cart
end

def apply_clearance(cart)
  #{"TEMPEH"=>{:price=>3.0, :clearance=>true, :count=>1}}
  new_cart = cart.clone

  cart.each do |item, value_hash|
    if value_hash[:clearance] == true
      new_price = value_hash[:price] * 0.80
      new_cart[item] = {:price => new_price.round(2), :clearance => value_hash[:clearance], :count => value_hash[:count]}
    end
  end

  new_cart
end

def checkout(cart, coupons)
  total_cost = 0

  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_with_coupons_and_clearance = apply_clearance(cart_with_coupons)

  cart_with_coupons_and_clearance.each do |item, value_hash|
    total_cost += value_hash[:price] * value_hash[:count]
  end

  if total_cost > 100
    total_cost = total_cost * 0.9
  end

  total_cost
end
