# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/records'
require_relative 'runners/networks'

module Legion
  module Extensions
    module Infoblox
      class Client
        include Helpers::Client
        include Runners::Records
        include Runners::Networks

        attr_reader :opts

        def initialize(url:, username:, password:, verify_ssl: true, **extra)
          @opts = { url: url, username: username, password: password, verify_ssl: verify_ssl, **extra }
        end

        def settings
          { options: @opts }
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
