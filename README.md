# Neustar::WsGetData

This gem wraps the SOAP interface for Neustar's WS-GetData Services. It
supports both interactive and batch queries.

## Installation

Add this line to your application's Gemfile:

    gem 'neustar-ws_get_data'

And then execute:

    bundle

Or install it yourself as:

    gem install neustar-ws_get_data

## Usage

```ruby
  client = Neustar::WsGetData::Client.new(
    :username   => 'username',
    :password   => 'password',
    :service_id => 123456
  )

  client.operations
  #=> [:query, :batch_query]

  client.phone_attributes('8583145300', [:phone_type])
  #=> {:phone_type => :wireless}

  client.phone_attributes('8583145300')
  #=> {:prepaid_phone    => false,
       :business_phone   => :unknown,
       :phone_in_service => "Active for 1 month or less",
       :phone_type       => :wireless}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
