# frozen_string_literal: true

RSpec.describe Legion::Extensions::Infoblox::Client do
  subject(:client) do
    described_class.new(
      url:        'https://infoblox.example.com/wapi/v2.12',
      username:   'admin',
      password:   'secret',
      verify_ssl: false
    )
  end

  describe '#initialize' do
    it 'stores url in opts' do
      expect(client.opts[:url]).to eq('https://infoblox.example.com/wapi/v2.12')
    end

    it 'stores username in opts' do
      expect(client.opts[:username]).to eq('admin')
    end

    it 'stores password in opts' do
      expect(client.opts[:password]).to eq('secret')
    end

    it 'stores verify_ssl in opts' do
      expect(client.opts[:verify_ssl]).to be false
    end

    it 'defaults verify_ssl to true when not provided' do
      c = described_class.new(url: 'https://infoblox.example.com/wapi/v2.12', username: 'u', password: 'p')
      expect(c.opts[:verify_ssl]).to be true
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#connection' do
    it 'returns a Faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end
  end
end
