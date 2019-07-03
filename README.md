# Cab project

[![CircleCI](https://circleci.com/gh/ccverak/simple_checkout/tree/master.svg?style=svg)](https://circleci.com/gh/ccverak/simple_checkout/tree/master)

## Server documentation

## Currency representation

Due to the problems related with float point arithmetics all the prices are provided and returned in cents.

## Pricing rules

### Active rules

The active pricing rules are configured in `app/pricing_rules.rb` in the `active_rules` method.

### Available rules

- `FreeItemsInBatchRule`: This rule allows you to define discounts over a basket by reducing in a 100% the price of a number of items of a product for every batch of items of the product found in the basket.

Example:

4 VOUCHER products for the price of 2

should be declared as follows:

```ruby
FreeItemInBatch.new product_code: "VOUCHER", batch_size: 4, free_per_batch: 2
```

- `TwoForOneRule`: This rule is a shortcut for the most common `FreeItemsInBatchRule`, "2 for the price of 1"

I should be declared like this:

```ruby
TwoForOneRule.new product_code: "VOUCHER"
```

- `BulkRule`: This rules allows you to define a discount per item of a product where the number of items of that product is greater or exceeds a given number.

Example:

Apply a discount of 1 euro for every item in the basket if the item is present more that 5 times.

This rule should be represented like this:

```ruby
BulkRule.new product_code: "TSHIRT", minimum_items: 5, discount_per_item: 100
```


### Adding custom rules

In order to add a custom rule a new entry should be added to `active_rules`.
The new rule should should follow the following contract defined in `pricing_rules/abstract_rule.rb`


```ruby
def apply(basket: Basket) -> discount: Integer
```

## Concurrency support

We have a global variable which plays a the database, this shared variable uses a lock from `concurrent_ruby` to avoid racing conditions when multiple threads try to read/write this variable.

Puma is configured to only use threads and not workers. Workers won't work well with the shared in-memory database but threads will. 

Due to all the above, this app only supports vertical scalability by increasing the power to the server and/or adding more threads to the puma configuration using the MAX_THREADS environment variable.

## Deployment

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Checkout here a running version: [https://cab-api-prod.herokuapp.com/](https://cab-api-prod.herokuapp.com/)

## API docs

Checkout the Open Api definition (v2) at: [https://cab-api-prod.herokuapp.com/api/v1/docs](https://cab-api-prod.herokuapp.com/api/v1/docs)

## Clients

A ruby client of the API is located under [client](https://github.com/ccverak/simple_checkout/tree/master/client) directory.
