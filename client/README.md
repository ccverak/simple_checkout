# CabClient

This is the client of the Cab Rest API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cab_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cab_client

## Usage

Configure the client:

```ruby
CabClient.configure do |config|
    config.api_base = 'https://cab-api-prod.herokuapp.com/api/v1/'
    config.timeout = 30
end
```

### Parameters

`api_base`: Use it in case you want to deploy your own copy of the api, defaults to: https://cab-api-prod.herokuapp.com/api/v1

`timeout`: Sets the request timeout in seconds, defaults to 10 seconds

### Examples

Start by creating a client

```ruby
CabClient::Client.new
```

Creating an empty basket:

```ruby
client.create_basket
```
```json
{
    "basket":{
        "id":"c0c32bc1-a459-4659-9219-162baa57b798",
        "line_items":[],
        "price":0,
        "final_price":0,
        "discounts":0
    }
}
```

Creating a basket passing some line items:

```ruby
client.create_basket(
    basket: {
        line_items: [
            product_code: "VOUCHER",
            quantity: 2,
        ],
    },
)
```

```json
{
    "basket":{
        "id":"2c4d983a-ac58-4fd3-8ec0-979f59fc69ff",
        "line_items":[{"product_code":"VOUCHER","quantity":2}],
        "price":1000,
        "final_price":500,
        "discounts":500
    }
}
```

Retrieving an existing basket:

```ruby
client.retrieve_basket(basket_id: existing_id)
```


Destroying an existing basket:

```ruby
client.destroy_basket(basket_id: existing_id)
```

Adding a line item to a basket:

```ruby
client.add_to_basket(basket_id: existing_id, attributes: {
                                                line_item: {
                                                product_code: "VOUCHER",
                                                quantity: 2,
                                                },
                                            })
```

### Errors

- `CabClient::Client::APINotAvailable`: Raised when there was a timeout or the API didn't respond on time

- `CabClient::Client::ServerError`: Raise when something went wrong in the server side

- `CabClient::Client::NotFoundError`: Raise when certain resource you are querying for doesn't exist.

- `CabClient::Client::IncompatibleClientError`: Raise when there was something wrong with the request body, typically this means you are using and old client.

## Open Api definition

Checkout the Open Api definition (v2) at: [https://cab-api-prod.herokuapp.com/api/v1/docs](https://cab-api-prod.herokuapp.com/api/v1/docs)
