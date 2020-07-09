RSpec.describe Shopping::Cart::Calculate do
    let(:discount_free) { Shopping::Cart::FreeTypeDiscount.new(label: 'Free VGA', type: 'freeProduct', targetSku: 'vga') }
    let(:discount_qtyDiscount) { Shopping::Cart::QtyTypeDiscount.new(label: '3 for 2 discount', type: 'qtyDiscount', discountQty: 3, discountQtyVolume: 1) }
    let(:discount_priceDiscount) { Shopping::Cart::PriceTypeDiscount.new(label: 'Bulk Discount', type: 'priceDiscount', discountQty: 3, discountPrice: 499.99) }
  
    let(:item_1) { Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99).tap{|t| t.addToDiscount(discount_priceDiscount) }}
    let(:item_2) { Shopping::Cart::Item.new(sku: 'mbp', name: 'Macbook pro', price: 1399.99).tap{|t| t.addToDiscount(discount_free) } }
    let(:item_3) { Shopping::Cart::Item.new(sku: 'atv', name: 'Apple TV', price: 109.50).tap{|t| t.addToDiscount(discount_qtyDiscount) } }
    let(:item_4) { Shopping::Cart::Item.new(sku: 'vga', name: 'VGA Adapter', price: 30.00) }
  
    let(:inventory) { [item_1, item_2, item_3, item_4] }

    # checkout_price is already tested as part of checkout - total_price method. 

    subject {  Shopping::Cart::Calculate }
  
    context '#priceDiscountForCart' do
      describe "when cart has multiple items" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price for PriceTypeDiscount item' do 
          co.scan("ipd")
          co.scan("vga")
          cal = subject.new(inventory, co.cart)

          expect(cal.priceDiscountForCart(:ipd)).to eq(549.99)
        end
      end
    end    

    context '#qtyDiscountForCart' do
      describe "when cart has multiple items" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price for qtyDiscount item' do 
          co.scan("atv")
          co.scan("ipd")
          cal = subject.new(inventory, co.cart)

          expect(cal.priceDiscountForCart(:atv)).to eq(109.50)
        end
      end
    end    

    context '#freeProductPriceForCart' do
      describe "when cart has multiple items" do
        let!(:co) { Shopping::Cart::Checkout.new(inventory) }
        it 'is expected to return the price for PriceTypeDiscount item' do 
          co.scan("mbp")
          co.scan("ipd")
          cal = subject.new(inventory, co.cart)

          expect(cal.freeProductPriceForCart(:mbp)).to eq(1399.99)
        end
      end
    end    
  end
    