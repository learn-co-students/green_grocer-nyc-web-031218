require 'pry'
def cart
  cart = [
    {"AVOCADO" => {:price => 3.0, :clearance => true }},
    {"AVOCADO" => {:price => 3.0, :clearance => true }},
    {"KALE"    => {:price => 3.0, :clearance => false}}
  ]
end

def consolidated_cart
  consolidated_cart = {
    "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
    "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
  }

end

def coupon
  coupon = {:item => "AVOCADO", :num => 2, :cost => 5.0}

end

def consolidate_cart(cart)
  # code here

  cart.each_with_object({}){ |item, result|
    item.each{ |fruit, info|
      result[fruit] ||= {}
      result[fruit][:price] = info[:price]
      result[fruit][:clearance] = info[:clearance]
      result[fruit][:count] = cart.count(item)
      puts result
    }
  }
end

#consolidate_cart(cart)





def apply_coupons(cart, coupons)
  #new hash that will be returned
  return_cart = cart

  coupons.each{ |coupons|
    #fruit == "AVOCADO"
    fruit = coupons[:item]
    fruit_coupon_count = coupons[:num]

    if cart.keys.include?(fruit)
      fruit_cart_count = return_cart[fruit][:count]
      #binding.pry

      #if fruit count in cart is higher than the coupon fruit count
      if fruit_cart_count >= fruit_coupon_count
        #decrease fruit count in cart by coupon's fruit count
        fruit_cart_count -= fruit_coupon_count
        return_cart[fruit][:count] = fruit_cart_count

        #insert new fruit with coupon
        if return_cart["#{fruit} W/COUPON"] == nil
          return_cart["#{fruit} W/COUPON"] = {}
          x = return_cart["#{fruit} W/COUPON"]
          x[:price] = coupons[:cost]
          x[:clearance] = cart[fruit][:clearance]
          x[:count] = 1

        else
          return_cart["#{fruit} W/COUPON"][:count] += 1

        end #/if
      end#/if
    end#/if
  }


  puts return_cart
  #binding.pry
  return return_cart

end

x = apply_coupons(consolidated_cart, [coupon, coupon])







def apply_clearance(cart)
  # code here

  cart.map{ |fruit|
    if fruit[1][:clearance] == true
      fruit[1][:price] = (fruit[1][:price]*0.8).round(2)
    end
  }

  return cart
end

#apply_clearance(consolidated_cart)











def checkout(cart, coupons)
  # code here

  consolidated_cart = consolidate_cart(cart)
  #binding.pry
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  #binding.pry
  cart_with_coupons_clearance = apply_clearance(cart_with_coupons)
  #binding.pry

  total = 0
  cart_with_coupons_clearance.each{ |fruit|
    total += fruit[1][:price]*fruit[1][:count]
  }
  #binding.pry
  if total > 100
    total = (total * 0.9).round(2)
  end

  return total

end

checkout(cart, [coupon])
