# frozen_string_literal: true

module Legion
  module Extensions
    module Infoblox
      module Runners
        module Records
          def list_records(type: 'a', zone: nil, **)
            params = {}
            params[:zone] = zone if zone
            resp = connection(**).get("/#{type_path(type)}", params)
            { records: resp.body }
          end

          def get_record(ref:, **)
            resp = connection(**).get("/#{encode_ref(ref)}")
            { record: resp.body }
          end

          def create_record(type:, name:, value:, **)
            body = build_record_body(type, name, value)
            resp = connection(**).post("/#{type_path(type)}", body)
            { ref: resp.body }
          end

          def delete_record(ref:, **)
            resp = connection(**).delete("/#{encode_ref(ref)}")
            { deleted: resp.status == 200, ref: ref }
          end

          private

          def type_path(type)
            "record:#{type}"
          end

          def encode_ref(ref)
            ref
          end

          def build_record_body(type, name, value)
            case type.to_s.downcase
            when 'a'     then { name: name, ipv4addr: value }
            when 'cname' then { name: name, canonical: value }
            when 'ptr'   then { ptrdname: name, ipv4addr: value }
            when 'host'  then { name: name, ipv4addrs: [{ ipv4addr: value }] }
            else              { name: name, value: value }
            end
          end
        end
      end
    end
  end
end
