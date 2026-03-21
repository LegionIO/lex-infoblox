# lex-infoblox

LegionIO extension for Infoblox WAPI integration. Manages DNS records and network resources via the Infoblox Web API (WAPI).

## Installation

Add to your Gemfile:

```ruby
gem 'lex-infoblox'
```

## Standalone Usage

```ruby
require 'legion/extensions/infoblox'

client = Legion::Extensions::Infoblox::Client.new(
  url:        'https://infoblox.example.com/wapi/v2.12',
  username:   'admin',
  password:   'secret',
  verify_ssl: true
)

# DNS Records
client.list_records(type: 'a', zone: 'example.com')
client.list_records(type: 'cname')
client.list_records(type: 'host')
client.list_records(type: 'ptr')

client.get_record(ref: 'record:a/ZG5z...')

client.create_record(type: 'a',     name: 'server.example.com',  value: '10.0.0.5')
client.create_record(type: 'cname', name: 'alias.example.com',   value: 'server.example.com')
client.create_record(type: 'host',  name: 'host.example.com',    value: '10.0.0.6')
client.create_record(type: 'ptr',   name: 'server.example.com',  value: '10.0.0.5')

client.delete_record(ref: 'record:a/ZG5z...')

# Networks
client.list_networks
client.get_network(ref: 'network/ZG5z...')
client.next_available_ip(network_ref: 'network/ZG5z...', count: 1)
```

## Authentication

Infoblox WAPI uses HTTP Basic Authentication. Provide `username` and `password` when creating the client.

## SSL Verification

SSL verification is enabled by default (`verify_ssl: true`). Set to `false` for environments using self-signed certificates.

## License

MIT
