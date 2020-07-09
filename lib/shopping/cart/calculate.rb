module Shopping
    module Cart
        class Calculate
            def self.checkout_price(inventory, cart)
                total_price = 0.0

                cart.keys.each do |key|
                    case cart[key][:discountType]
                    when 'priceDiscount'
                      # Filter items by key (sku).
                      fts = inventory.select{|item| item.sku == key.to_s} # all the items with same sku
                      # Fetch the discount attributes from the first (as they are same)
                      discount = fts.first.discount
      
                      # If the number of items ordered are more than discount discount quantity
                      if cart[key][:count] > discount.discountQty
                        total_price += cart[key][:count] * discount.discountPrice
                      else
                        total_price += cart[key][:count] * fts.first.price
                      end
                    when 'qtyDiscount'
                      # Filter items by key (sku).
                      fts = inventory.select{|item| item.sku == key.to_s } # all the items with same sku
                      # Fetch the discount attributes from the first (as they are same)
                      discount = fts.first.discount
      
                      # discount.discountQty
                      c = cart[key][:count]
                      if c < discount.discountQty
                        total_price += c * fts.first.price
                      elsif c % 3 == 0
                        rem = c / 3
      
                        total_price += (c - rem) * fts.first.price
                      end
                    when 'freeProduct'
                      # Filter items by key (sku).
                      fts = inventory.select{|item| item.sku == key.to_s } # all the items with same sku
                      # Fetch the discount attributes from the first (as they are same)
                      discount = fts.first.discount
      
                      # find the targetSku in the items
                      tSkus =  inventory.select{|item| item.sku == discount.targetSku }
      
                      # discountTargetSku length
                      tSkusLen = cart[discount.targetSku.to_sym][:count]
      
                      # freeProduct Length
                      freeProductLen = cart[key][:count]
      
                      if freeProductLen > tSkusLen
                        total_price += freeProductLen * fts.first.price
                        cart[discount.targetSku.to_sym] = {
                          count: 0,
                          discountType: nil
                        } # look into this
                      elsif tSkusLen == freeProductLen
                        total_price += freeProductLen * fts.first.price
                        cart[discount.targetSku.to_sym] = {
                          count: 0,
                          discountType: nil
                        } 
                      else
                        total_price += freeProductLen * fts.first.price
                        cart[discount.targetSku.to_sym] = {
                          count: tSkusLen - freeProductLen,
                          discountType: nil
                        } 
                      end
                    else
                      fts = inventory.select{|item| item.sku == key.to_s }
                      total_price += cart[key][:count] * fts.first.price
                    end
                end

                total_price
            end
        end
    end
end
  