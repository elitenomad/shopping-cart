module Shopping
    module Cart
      class Checkout
        attr_reader :cart

        def initialize(inventory)
            @inventory = inventory
            @cart = {}
        end

        def scan(sku)
            item = @inventory.find{|item| item.sku == sku }
            
            raise Shopping::Cart::ItemNotExistsError.new('Item not present in the Inventory') if item.nil?

            if @cart[sku.to_sym] 
              @cart[sku.to_sym][:count] += 1
            else
              @cart.merge!({
                "#{sku}": {
                  count: 1,
                  discountType: item.discount&.type
                }
              })
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
          
          Shopping::Cart::Calculate.new(@inventory, @cart).checkout_price
        end
      end
    end
  end
  