# frozen_string_literal: true

RSpec.describe Legion::Extensions::Infoblox::Runners::Records do
  let(:client) do
    Legion::Extensions::Infoblox::Client.new(
      url:        'https://infoblox.example.com/wapi/v2.12',
      username:   'admin',
      password:   'secret',
      verify_ssl: false
    )
  end

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'https://infoblox.example.com/wapi/v2.12') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#list_records' do
    it 'returns A records' do
      stubs.get('/record:a') do
        [200, { 'Content-Type' => 'application/json' },
         [{ '_ref' => 'record:a/xyz', 'name' => 'host.example.com', 'ipv4addr' => '10.0.0.1' }]]
      end
      result = client.list_records(type: 'a')
      expect(result[:records]).to be_an(Array)
      expect(result[:records].first['name']).to eq('host.example.com')
    end

    it 'returns CNAME records' do
      stubs.get('/record:cname') do
        [200, { 'Content-Type' => 'application/json' },
         [{ '_ref' => 'record:cname/abc', 'name' => 'alias.example.com', 'canonical' => 'host.example.com' }]]
      end
      result = client.list_records(type: 'cname')
      expect(result[:records].first['canonical']).to eq('host.example.com')
    end

    it 'returns host records filtered by zone' do
      stubs.get('/record:host') do
        [200, { 'Content-Type' => 'application/json' },
         [{ '_ref' => 'record:host/def', 'name' => 'server.example.com' }]]
      end
      result = client.list_records(type: 'host', zone: 'example.com')
      expect(result[:records]).to be_an(Array)
    end
  end

  describe '#get_record' do
    it 'returns a single A record by ref' do
      stubs.get('/record:a/xyz') do
        [200, { 'Content-Type' => 'application/json' },
         { '_ref' => 'record:a/xyz', 'name' => 'host.example.com', 'ipv4addr' => '10.0.0.1' }]
      end
      result = client.get_record(ref: 'record:a/xyz')
      expect(result[:record]['name']).to eq('host.example.com')
      expect(result[:record]['ipv4addr']).to eq('10.0.0.1')
    end
  end

  describe '#create_record' do
    it 'creates an A record and returns ref' do
      stubs.post('/record:a') do
        [201, { 'Content-Type' => 'application/json' },
         '"record:a/new-ref"']
      end
      result = client.create_record(type: 'a', name: 'new.example.com', value: '10.0.0.5')
      expect(result[:ref]).to eq('record:a/new-ref')
    end

    it 'creates a CNAME record and returns ref' do
      stubs.post('/record:cname') do
        [201, { 'Content-Type' => 'application/json' },
         '"record:cname/cname-ref"']
      end
      result = client.create_record(type: 'cname', name: 'alias.example.com', value: 'host.example.com')
      expect(result[:ref]).to eq('record:cname/cname-ref')
    end

    it 'creates a host record and returns ref' do
      stubs.post('/record:host') do
        [201, { 'Content-Type' => 'application/json' },
         '"record:host/host-ref"']
      end
      result = client.create_record(type: 'host', name: 'server.example.com', value: '10.0.0.10')
      expect(result[:ref]).to eq('record:host/host-ref')
    end
  end

  describe '#delete_record' do
    it 'returns deleted true on 200' do
      stubs.delete('/record:a/xyz') do
        [200, { 'Content-Type' => 'application/json' }, '"record:a/xyz"']
      end
      result = client.delete_record(ref: 'record:a/xyz')
      expect(result[:deleted]).to be true
      expect(result[:ref]).to eq('record:a/xyz')
    end
  end
end
