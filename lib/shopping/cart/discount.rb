module Shopping
    module Cart
      class Discount
        attr_reader :label, :type

        def initialize(label:, type:)
            @label = label
            @type = type
        end
      end

      class FreeTypeDiscount < Discount
        attr_reader :label, :type, :targetSku

        def initialize(label:, type:, targetSku: nil)
            @label = label
            @type = type
            @targetSku = targetSku
        end
      end

      class QtyTypeDiscount < Discount
        attr_reader :label, :type, :discountQty, :discountQtyVolume

        def initialize(label:, type:, discountQty: 0, discountQtyVolume: 0)
            @label = label
            @type = type
            @discountQty = discountQty
            @discountQtyVolume = discountQtyVolume
        end
      end

      class PriceTypeDiscount < Discount
        attr_reader :label, :type, :discountQty, :discountPrice

        def initialize(label:, type:, discountQty: 0, discountPrice: 0.0)
            @label = label
            @type = type
            @discountQty = discountQty
            @discountPrice = discountPrice
        end
      end
    end
  end
  