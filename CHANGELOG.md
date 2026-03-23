# Changelog

## [0.1.2] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, and legion-transport as runtime dependencies
- Update spec_helper with real sub-gem helper stubs (Legion::Extensions::Helpers::Lex)

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client` — Faraday connection builder targeting Infoblox WAPI with Basic Auth and configurable SSL verification
- `Runners::Records` — list_records (type: a/cname/host/ptr, zone filter), get_record (ref), create_record (type, name, value), delete_record (ref)
- `Runners::Networks` — list_networks, get_network (ref), next_available_ip (network_ref, count)
- Standalone `Client` class for use outside the Legion framework
