# NOTES:

## Currency representation

Due to the problems related with float point arithmetics all the prices are provided and returned in cents.

## Pricing rules

### Active rules

The active pricing rules are configured in `app/pricing_rules.rb` in the `active_rules` method.

### Available rules

- **free_items_on_batch**: This rule allows you to define discounts over a basket by reducing in a 100% the price of a number of items of a product for every batch of items of the product found in the basket.

Example:

4 VOUCHER products for the price of 2

should be declared as follows:

```ruby
{ type: :free_items_on_batch, product_code: "VOUCHER", batch_size: 4, free_per_batch: 2 }
```

- **two_for_one**: This rule is a shortcut for the most common free_items_on_batch, "2 for the price of 1"

I should be declared like this:

```ruby
{ type: :two_for_one, product_code: "VOUCHER" }
```
- **bulk**: This rules allows you to define a discount per item of a product where the number of items of that product is greater or exceeds a given number.

Example:

Apply a discount of 1 euro for every item in the basket if the item is present more that 5 times.

This rule should be represented like this:

```ruby
{ type: :bulk, product_code: "TSHIRT", minimum_items: 5, discount_per_item: 100 }
```


### Adding custom rules

In order to add a custom rule a new entry should be added to `active_rules` in `app/pricing_rules.rb`. Also, the new rule should be registered in the RuleFactory and its class should follow the following contract:

```ruby
def apply(basket: Basket) -> discount: Integer
```

## Deployment

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Checkout here a running version: [https://cab-api-prod.herokuapp.com/](https://cab-api-prod.herokuapp.com/)

## API docs

Checkout the Open Api definition (v2) at: [https://cab-api-prod.herokuapp.com/api/v1/docs](https://cab-api-prod.herokuapp.com/api/v1/docs)

## Clients

A ruby client of the API is located under [client](https://github.com/ccverak/simple_checkout/tree/master/client) directory.
