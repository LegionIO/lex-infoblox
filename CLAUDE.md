# lex-infoblox: Infoblox IPAM/DNS Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Infoblox WAPI for DNS and network management. Provides runners for DNS record operations and network resource management.

**GitHub**: https://github.com/LegionIO/lex-infoblox
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Infoblox
├── Runners/
│   ├── Records    # list_records, get_record, create_record, delete_record (A, CNAME, HOST, PTR)
│   └── Networks   # list_networks, get_network, next_available_ip
├── Helpers/
│   └── Client     # Faraday connection (Infoblox WAPI, Basic Auth)
└── Client         # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/infoblox.rb` | Entry point, extension registration |
| `lib/legion/extensions/infoblox/runners/records.rb` | DNS record runners (A, CNAME, HOST, PTR) |
| `lib/legion/extensions/infoblox/runners/networks.rb` | Network management runners |
| `lib/legion/extensions/infoblox/helpers/client.rb` | Faraday connection builder (HTTP Basic Auth) |
| `lib/legion/extensions/infoblox/client.rb` | Standalone Client class |

## Authentication

Infoblox WAPI uses HTTP Basic Authentication (`username` + `password`). The client also accepts `verify_ssl: false` for environments with self-signed certificates.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (~> 2.0) | HTTP client for Infoblox WAPI |

## Development

19 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
