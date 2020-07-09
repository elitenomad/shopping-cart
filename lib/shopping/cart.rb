require "shopping/cart/version"
require "shopping/cart/item"
require "shopping/cart/discount"
require "shopping/cart/checkout"
require "shopping/cart/calculate"

module Shopping
  module Cart
    class Error < StandardError; end
    class NoInventoryError < StandardError; end
    class CartIsEmptyError < StandardError; end
  end
end
