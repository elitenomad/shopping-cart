module Shopping
    module Cart
      class Checkout
        attr_reader :cart

        def initialize(inventory)
            @inventory = inventory
            @cart = {}
        end

        def scan(sku)
            if @cart[sku.to_sym] 
              @cart[sku.to_sym][:count] = @cart[sku.to_sym][:count] + 1
            else
              @cart.merge!({
                "#{sku}": {
                  count: 1,
                  discountType: @inventory.find{|item| item.sku == sku }.discount&.type
                }
              })
            end
        end

        def remove(sku)
          if(sku)
            @cart.delete(sku)
          end
        end

        def clear
          @cart.keys.each do |key|
            @cart.delete(key)
          end
        end
        
        def total
          raise Shopping::Cart::NoInventoryError.new('Inventory is empty') if @inventory.length <= 0
          raise Shopping::Cart::CartIsEmptyError.new('Cart is empty') if @cart.keys.length <= 0
          
          Shopping::Cart::Calculate.checkout_price(@inventory, @cart)
        end
      end
    end
  end
  