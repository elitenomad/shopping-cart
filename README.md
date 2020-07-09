# Checkout

Welcome to Shopping cart checkout system!

## Setup

After checking out to the repo, run the below command to install dependencies.

```
 bin/setup
```

## Console

Run below command  for an interactive prompt that will allow you to verify the code.

```
bin/console
```

## Structure

```
.
├── Gemfile --> Responsible for holding dependencies of the project
├── Gemfile.lock -> Lock file for the above dependencies
├── README.md
├── Rakefile -> Added to run spec from it.
├── bin
│   ├── console -> We can interactive play with the functionality of the module
│   └── setup -> Installs all the dependencies
├── lib
│   └── shopping
│       ├── cart
│       │   ├── calculate.rb -> Takes in inventory and cart items and provides price
│       │   ├── checkout.rb -> Scans the items and takes help to fetch grand total
│       │   ├── discount.rb -> Simple inheritance class for 3 types of discounts in challenge
│       │   ├── item.rb -> Listing or item structure
│       │   └── version.rb -> bundle gem added this, will ge useful if we turn this module into a gem library
│       └── cart.rb
├── shopping-cart.gemspec -> bundle gem added this, will be useful if we turn this module into a gem library
└── spec
    ├── shopping
    │   ├── cart
    │   │   └── checkout_spec.rb - Runs e2e tests for the entire function
    │   └── cart_spec.rb - Added by ```bundle gem``` which tests the version number (Kept it as i didnt remove the original file)
    └── spec_helper.rb



```

## Usage

```
# Set up Discounts
discount_free = Shopping::Cart::FreeTypeDiscount.new(label: 'Free VGA', type: 'freeProduct', targetSku: 'vga')
discount_qtyDiscount = Shopping::Cart::QtyTypeDiscount.new(label: '3 for 2 discount', type: 'qtyDiscount', discountQty: 3, discountQtyVolume: 1)
discount_priceDiscount = Shopping::Cart::PriceTypeDiscount.new(label: 'Bulk Discount', type: 'priceDiscount', discountQty: 3, discountPrice: 499.99)

# Set up items or Listings - Attach a discount to each item
item_1 = Shopping::Cart::Item.new(sku: 'ipd', name: 'Super iPad', price: 549.99)
item_1.addTodiscount(discount_priceDiscount)
item_2 = Shopping::Cart::Item.new(sku: 'mbp', name: 'Macbook pro', price: 1399.99)
item_2.addTodiscount(discount_free)
item_3 = Shopping::Cart::Item.new(sku: 'atv', name: 'Apple TV', price: 109.50)
item_3.addTodiscount(discount_qtyDiscount)
item_4 = Shopping::Cart::Item.new(sku: 'vga', name: 'VGA Adapter', price: 30.00)

# Setup inventory
inventory = []
inventory << item_1
inventory << item_2
inventory << item_3
inventory << item_4

# Initialize the Checkout class with inventory
s = Shopping::Cart::Checkout.new(inventory)
s.scan("ipd")
s.total

```

## Spec

Run below command to run the tests.

```
rspec spec/
```

## Design

- Took ```bundle gem``` help to create a folder structure. It would be a great idea to pluck this function to a gem.
- Reason for having separate class for discounts is that, if we provide an admin interface to sales manager (for that model class - given there is a backend implementation), he/she can play around with the values. 
- Added clear function for testing purposes. (Easy to clear out existing hash instead of exiting the console and staring over again)
- Created a Calculate class instead of incorporating the logic instead of Checkout class.
- Always act up on two entities in Checkout class - Inventory (In general we look it up from DB) and cart which will have the info of the items ordered by user. Cart object acts like a meta data and real info is fetched using the inventory data.

**Assumptions**
- Items are unlimited in stock. 
- Item can have one Discount at any given point in time.
- The logic is limited to only three type of Specials/Discounts(FreeType, QtyDiscount, PriceDiscount). If we have to add another type of discount, we have to extend the logic in Calculate (checkout_price) method. (just like other types)
