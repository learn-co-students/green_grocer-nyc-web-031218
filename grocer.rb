require 'pry'

def consolidate_cart(cart)
  small_cart = {}
  cart.each do |item_hash|
    item_hash.each do |key, value|
      if small_cart.include?(key)
        small_cart[key][:count] += 1
      else
        small_cart[key] = value
        small_cart[key][:count] = 1
      end
    end
  end
  small_cart
end

def apply_coupons(cart, coupons)

#can merge creation into cart if statement

  coupons.each do |coupon|
    name = coupon[:item]
    if cart.include?(name)
      item_count = cart[name][:count]
      if item_count >= coupon[:num]
        item_count -= coupon[:num]
        coupon_name = "#{name} W/COUPON"
        coupon_item = {coupon_name => {
          count: 1,
          price: coupon[:cost],
          clearance: cart[name][:clearance]
          }}
        coupon_item.each do |key, value|
          if cart.include?(key)
            cart[key][:count]+= 1
          else
            cart[key] = value
          end
        end
        cart[name][:count] = item_count
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |key, value|
    if cart[key][:clearance] == true
      cart[key][:price] *= 0.8
      cart[key][:price] = cart[key][:price].round(2)
    end
  end
  cart

end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |key, value|
    total += cart[key][:price] * cart[key][:count]
  end
  total > 100 ? (total * 0.9) : total
end
