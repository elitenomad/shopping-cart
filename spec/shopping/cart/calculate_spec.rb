RSpec.describe Shopping::Cart::Calculate do
    let(:discount_free) { Shopping::Cart::FreeTypeDiscount.new(label: 'Free VGA', type: 'freeProduct', targetSku: 'vga') }
    let(:discount_qtyDiscount) { Shopping::Cart::QtyTypeDiscount.new(label: '3 for 2 discount', type: 'qtyDiscount', discountQty: 3, discountQtyVolume: 1) }
    let(:discount_priceDiscount) { Shopping::Cart::PriceTypeDiscount.new(label: 'Bulk Discount', type: 'priceDiscount', discountQty: 3, discountPrice: 499.99) }
  
    let(:item_1) { Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99).tap{|t| t.addToDiscount(discount_priceDiscount) }}
    let(:item_2) { Shopping::Cart::Item.new(sku: 'mbp', name: 'Macbook pro', price: 1399.99).tap{|t| t.addToDiscount(discount_free) } }
    let(:item_3) { Shopping::Cart::Item.new(sku: 'atv', name: 'Apple TV', price: 109.50).tap{|t| t.addToDiscount(discount_qtyDiscount) } }
    let(:item_4) { Shopping::Cart::Item.new(sku: 'vga', name: 'VGA Adapter', price: 30.00) }
  
    let(:inventory) { [item_1, item_2, item_3, item_4] }

    subject {  Shopping::Cart::Calculate }

    context '#checkout_price' do
      describe "when cart has priceDiscount item" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price from priceDiscountForCart' do 
          co.scan("ipd")
          cal = subject.new(inventory, co.cart)

          expect(cal.checkout_price).to eq(549.99)
        end
      end

      describe "when cart has qtyDiscount item" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price from qtyDiscountForCart' do 
          co.scan("atv")
          cal = subject.new(inventory, co.cart)

          expect(cal.checkout_price).to eq(109.50)
        end
      end

      describe "when cart has freeProduct item" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price from freeProductPriceForCart' do 
          co.scan("mbp")
          cal = subject.new(inventory, co.cart)

          expect(cal.checkout_price).to eq(1399.99)
        end
      end

      describe "when cart has item without discounts" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price from default part of checkout price' do 
          co.scan("vga")
          cal = subject.new(inventory, co.cart)

          expect(cal.checkout_price).to eq(30.00)
        end
      end
    end
  end
    