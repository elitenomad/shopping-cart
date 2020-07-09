module Shopping
    module Cart
        class Calculate
            attr_reader :inventory, :cart

            def initialize(inventory, cart)
                @inventory = inventory
                @cart = cart
            end

            def checkout_price
                total_price = 0.0

                cart.keys.each do |key|
                    case cart[key][:discountType]
                    when 'priceDiscount'
                        total_price += priceDiscountForCart(key)
                    when 'qtyDiscount'
                        total_price += qtyDiscountForCart(key)
                    when 'freeProduct'
                        total_price += freeProductPriceForCart(key)
                    else
                      fts = inventory.select{|item| item.sku == key.to_s }
                      total_price += cart[key][:count] * fts.first.price
                    end
                end

                total_price
            end

            private

            def priceDiscountForCart(key)
                # Find an item by key (sku). (Used to fetch discount attached to an item)
                listing = inventory.find{|i| i.sku == key.to_s}

                # Fetch the discount attributes
                discount = listing.discount

                # If the number of items ordered are more than discount discount quantity
                # use the discount price to calculate the total price
                # else use item price.
                if cart[key][:count] > discount.discountQty
                  cart[key][:count] * discount.discountPrice
                else
                  cart[key][:count] * listing.price
                end
            end

            def qtyDiscountForCart(key)
                 # Find an item by key (sku). (Used to fetch discount attached to an item)
                 listing = inventory.find{|i| i.sku == key.to_s } 

                 # Fetch the discount attributes
                 discount = listing.discount
 
                 # if ordered count < discount quantity
                 # use item price times units ordered
                 # else use apply price for only non-discounted items
                 c = cart[key][:count]
                 if c < discount.discountQty
                    c * listing.price
                 else
                   rem = c / discount.discountQty
                   (c - rem) * listing.price
                 end
            end


            def freeProductPriceForCart(key)
                 # Find an item by key (sku). (Used to fetch discount attached to an item)
                 listing = inventory.find{|item| item.sku == key.to_s }

                 # Fetch the discount attributes
                 discount = listing.discount
 
                 # find the targetSku in the items
                 tSkus =  inventory.select{|item| item.sku == discount.targetSku }
 
                 # Fetch count of tSkus if already in the cart
                 tSkusLen = cart[discount.targetSku.to_sym] ? cart[discount.targetSku.to_sym][:count] : 0
 
                 # Main product count for which this special is attached
                 freeProductLen = cart[key][:count]
 
                 if freeProductLen >= tSkusLen 
                   cart[discount.targetSku.to_sym] = {
                     count: 0,
                     discountType: nil
                   }
                 else
                   cart[discount.targetSku.to_sym] = {
                     count: tSkusLen - freeProductLen,
                     discountType: nil
                   } 
                 end

                 freeProductLen * listing.price
            end     
        end
    end
end
  