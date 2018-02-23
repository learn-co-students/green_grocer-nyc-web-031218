require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |item_hash, new_hash|
    item_hash.each do |item, data_hash|
      new_hash[item] ||= {}
      data_hash.each do |key, value|
        new_hash[item][key] = value
      end
      new_hash[item][:count] ||= 0
      new_hash[item][:count] += 1
    end
  end
end


def apply_coupons(cart, coupons)
  cart.each_with_object({}) do |(name, data_hash), new_hash|
    new_hash[name] = data_hash
      coupons.each do |coupon|
        if coupon[:item] == name
          coupon_entry = "#{coupon[:item]} W/COUPON"
          new_hash[coupon_entry] ||= {}

          new_hash[coupon_entry][:price] = coupon[:cost]
          new_hash[coupon_entry][:clearance] = new_hash[name][:clearance]

          if new_hash[name][:count] >= coupon[:num]
            new_hash[name][:count] -= coupon[:num]
            new_hash[coupon_entry][:count] ||= 0
            new_hash[coupon_entry][:count] += 1
          end
        end
    end
  end
end

def apply_clearance(cart)
  cart.each_with_object({}) do |(name, data_hash), new_hash|
    new_hash[name] = data_hash
    if data_hash[:clearance]
      new_hash[name][:price] = (new_hash[name][:price] * 0.80).round(2)
    end
  end
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |name, data_hash|
    total += data_hash[:price] * data_hash[:count]
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
