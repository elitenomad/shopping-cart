RSpec.describe Shopping::Cart::Checkout do
  let(:special_free) { Shopping::Cart::Special.new(label: 'Free VGA', type: 'freeProduct', targetSku: 'vga') }
  let(:special_qtyDiscount) { Shopping::Cart::Special.new(label: '3 for 2 Special', type: 'qtyDiscount', discountQty: 3, discountQtyVolume: 1) }
  let(:special_priceDiscount) { Shopping::Cart::Special.new(label: 'Bulk Discount', type: 'priceDiscount', discountQty: 3, discountPrice: 499.99) }

  let(:item_1) { Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99).tap{|t| t.addToSpecial(special_priceDiscount) }}
  let(:item_2) { Shopping::Cart::Item.new(sku: 'mbp', name: 'Macbook pro', price: 1399.99).tap{|t| t.addToSpecial(special_free) } }
  let(:item_3) { Shopping::Cart::Item.new(sku: 'atv', name: 'Apple TV', price: 109.50).tap{|t| t.addToSpecial(special_qtyDiscount) } }
  let(:item_4) { Shopping::Cart::Item.new(sku: 'vga', name: 'VGA Adapter', price: 30.00) }

  let(:inventory) { [item_1, item_2, item_3, item_4] }

  subject { Shopping::Cart::Checkout.new(inventory) }

  describe 'When initialised' do
    it 'is expected to start with empty cart' do
      expect(subject.store).to eq({})
    end
  end

  context '#scan' do
    after(:each) do 
      subject.clear
    end

    describe "when item is scanned" do
      it 'is expected to add to the cart' do 
        subject.scan("ipd")
        expect(subject.store).to have_key(:ipd)
      end

      it 'is expected to accomodate multiple items in cart' do 
        subject.scan("ipd")
        subject.scan("vga")
        expect(subject.store.keys).to include(:ipd, :vga)
      end
    end
  end    

  context '#clear' do
    describe "when the cart is not empty" do
      it 'is expected to empty the cart' do
        subject.scan("ipd")
        subject.scan("vga")
        expect(subject.store.keys).to include(:ipd, :vga)
        subject.clear
        expect(subject.store).to eq({})
      end
    end
  end    

  context '#total' do
    after(:each) do 
      subject.clear
    end

    describe 'when SKUs Scanned: atv, atv, atv, vga' do
      it 'is expected to return $249.00' do 
        subject.scan("atv")
        subject.scan("atv")
        subject.scan("atv")
        subject.scan("vga")

        expect(subject.total).to eq(249.00)
      end
    end

    describe 'SKUs Scanned: atv, ipd, ipd, atv, ipd, ipd, ipd ' do
      it 'is expected to return $2718.95' do 
        subject.scan("atv")
        subject.scan("ipd")
        subject.scan("ipd")
        subject.scan("atv")
        subject.scan("ipd")
        subject.scan("ipd")
        subject.scan("ipd")

        expect(subject.total).to eq(2718.95)
      end
    end

    describe 'SKUs Scanned: mbp, vga, ipd' do
      it 'is expected to return $1949.98' do 
        subject.scan("mbp")
        subject.scan("vga")
        subject.scan("ipd")
        
        expect(subject.total).to eq(1949.98)
      end
    end

  end
end
  