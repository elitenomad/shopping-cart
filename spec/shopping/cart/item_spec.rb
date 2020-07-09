RSpec.describe Shopping::Cart::Item do

    describe 'When initialised' do
        let(:item) { Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99) }
        it 'is expected to discount nil' do
          expect(item.discount).to be_nil
        end
    end

    describe '#addToDiscount' do
        subject { Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99) }
        let(:discount) {  Shopping::Cart::FreeTypeDiscount.new(label: 'Free VGA', type: 'freeProduct', targetSku: 'vga') }

        it 'is expected to discount nil' do
            subject.addToDiscount(discount)
            expect(subject.discount).not_to be_nil
        end
    end
end