# frozen_string_literal: true

module Legion
  module Extensions
    module Infoblox
      module Runners
        module Networks
          def list_networks(**)
            resp = connection(**).get('/network')
            { networks: resp.body }
          end

          def get_network(ref:, **)
            resp = connection(**).get("/#{ref}")
            { network: resp.body }
          end

          def next_available_ip(network_ref:, count: 1, **)
            resp = connection(**).post("/#{network_ref}?_function=next_available_ip", { num: count })
            { ips: resp.body }
          end
        end
      end
    end
  end
end
