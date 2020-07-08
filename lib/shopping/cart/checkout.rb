module Shopping
    module Cart
      class Checkout
        attr_reader :store

        def initialize(items)
            @items = items
            @store = {}
        end

        # adds items to the shopping cart - checkout an item
        def scan(sku)
            if @store[sku.to_sym] 
              @store[sku.to_sym][:count] = @store[sku.to_sym][:count] + 1
            else
              @store.merge!({
                "#{sku}": {
                  count: 1,
                  discountType: @items.find{|item| item.sku == sku }.special&.type
                }
              })
            end
        end

        def remove(sku)
          if(sku)
            @store.delete(sku)
          end
        end

        def clear
          @store.keys.each do |key|
            @store.delete(key)
          end
        end
        
        def total
          total_price = 0.0
          total_price
        end
      end
    end
  end
  