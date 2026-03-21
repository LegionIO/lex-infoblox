# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Infoblox
      module Helpers
        module Client
          def connection(url: 'https://infoblox.example.com/wapi/v2.12', username: nil, password: nil,
                         verify_ssl: true, **)
            Faraday.new(url: url, ssl: { verify: verify_ssl }) do |conn|
              conn.request :authorization, :basic, username, password if username && password
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Content-Type'] = 'application/json'
              conn.headers['Accept']       = 'application/json'
              conn.adapter Faraday.default_adapter
            end
          end
        end
      end
    end
  end
end
