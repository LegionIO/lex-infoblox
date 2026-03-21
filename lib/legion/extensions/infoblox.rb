# frozen_string_literal: true

require 'legion/extensions/infoblox/version'
require 'legion/extensions/infoblox/helpers/client'
require 'legion/extensions/infoblox/runners/records'
require 'legion/extensions/infoblox/runners/networks'
require 'legion/extensions/infoblox/client'

module Legion
  module Extensions
    module Infoblox
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
