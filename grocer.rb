require "pry"
def consolidate_cart(cart)
  # code here
  cart_hash={}
  cart.each do |item|
    item.each do |name, variables|
      # binding.pry
      if !cart_hash.include?(name)
        # binding.pry
        cart_hash[name]=variables
        cart_hash[name][:count]=1
      # elsif cart_hash[name].include?(name)
      #   cart_hash[name][:count]=1
      else
        cart_hash[name][:count]+=1

        # binding.pry
      end
    end
  end
  cart_hash
# binding.pry
end

def apply_coupons(cart, coupons)
  # binding.pry
  final_cart={}
  coupon_count=0
  cart.each do |food, details|
    # binding.pry
    if coupons.size==0
      final_cart=cart
      return final_cart
    end
    coupons.each do |items|
      if details[:count]<items[:num]
        final_cart[food]=details
      elsif food == items[:item] #Checks that food name is equal to coupon food name
        discounted_item="#{food} W/COUPON"
        # current_count
        final_cart[food]=details
        details[:count]=(details[:count]-items[:num])

        # binding.pry

        if final_cart.include?(discounted_item)
          final_cart[discounted_item][:count]+=1
        else
        final_cart[discounted_item]={
          :price => items[:cost],
          :clearance => details[:clearance],
          :count=>1 } #items[:num] old info
        # binding.pry
        end
      else
        final_cart[food]=details
      end
      # binding.pry
    end
  end
  cart.each do |food, details|
    if !final_cart.include?(food)
      final_cart[food]=details
    end
  end
  final_cart
  # binding.pry
end

def apply_clearance(cart)
  cart.each do |name, data|
    if cart[name][:clearance]==true
      discounted_price=(cart[name][:price]*0.8).round(2)
      cart[name][:price]=discounted_price
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  total_cart=0
  over_100_discount=0.9
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance (cart)
  # binding.pry
  cart.each do |name, values|
    # binding.pry
    price=values[:price]
    amount=values[:count]
    total_cart=total_cart+(price*amount)

  end
  # binding.pry if total_cart == 27.0
  if total_cart>100
    return total_cart=total_cart*over_100_discount
  end
total_cart
end
