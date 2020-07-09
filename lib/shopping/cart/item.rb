module Shopping
    module Cart
      class Item
        attr_reader :sku, :name, :price, :discount

        def initialize(sku:, name:, price:)
            @sku = sku
            @name = name
            @price = price
        end

        def addToDiscount(discount)
            @discount = discount
        end
      end
    end
  end
  