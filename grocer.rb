require 'pry'


def consolidate_cart(cart)
  new_cart = {}
  veggies = []
  uniq_veggies = []
  cart.each do |data_hash|
      veggies << data_hash.keys
  end
  veggies = veggies.flatten
  uniq_veggies = veggies.uniq 
  uniq_veggies.each do |name|
    
    insides = cart.find{ |i| i.keys[0] == name}
    
    new_cart[name] = insides.values[0] 
    
    new_cart[name][:count] = 0
    
    end  
    
    veggies.each do |veggie|
      new_cart[veggie][:count] += 1 
    end
  
  return new_cart  
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
  return cart
end 
  


def apply_clearance(cart)
  cart.each do |item|
    attributes = item[1]
    if attributes[:clearance] == true 
      discount = attributes[:price] * 0.80
      attributes[:price] = discount.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  ans = 0 
  
  cart = consolidate_cart(cart) 
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  
  cart.each do |name, data|
    ans += data[:price] * data[:count]
  end 
  if ans > 100 
    ans = ans * 0.9
  end
ans
end




