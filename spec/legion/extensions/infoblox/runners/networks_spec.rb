# frozen_string_literal: true

RSpec.describe Legion::Extensions::Infoblox::Runners::Networks do
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

  describe '#list_networks' do
    it 'returns an array of networks' do
      stubs.get('/network') do
        [200, { 'Content-Type' => 'application/json' },
         [
           { '_ref' => 'network/aaa', 'network' => '10.0.0.0/24', 'network_view' => 'default' },
           { '_ref' => 'network/bbb', 'network' => '192.168.1.0/24', 'network_view' => 'default' }
         ]]
      end
      result = client.list_networks
      expect(result[:networks]).to be_an(Array)
      expect(result[:networks].length).to eq(2)
      expect(result[:networks].first['network']).to eq('10.0.0.0/24')
    end
  end

  describe '#get_network' do
    it 'returns a single network by ref' do
      stubs.get('/network/aaa') do
        [200, { 'Content-Type' => 'application/json' },
         { '_ref' => 'network/aaa', 'network' => '10.0.0.0/24', 'network_view' => 'default' }]
      end
      result = client.get_network(ref: 'network/aaa')
      expect(result[:network]['network']).to eq('10.0.0.0/24')
      expect(result[:network]['_ref']).to eq('network/aaa')
    end
  end

  describe '#next_available_ip' do
    it 'returns next available IP from a network' do
      stubs.post('/network/aaa?_function=next_available_ip') do
        [200, { 'Content-Type' => 'application/json' },
         { 'ips' => ['10.0.0.5'] }]
      end
      result = client.next_available_ip(network_ref: 'network/aaa')
      expect(result[:ips]['ips']).to eq(['10.0.0.5'])
    end

    it 'returns multiple IPs when count is specified' do
      stubs.post('/network/aaa?_function=next_available_ip') do
        [200, { 'Content-Type' => 'application/json' },
         { 'ips' => ['10.0.0.5', '10.0.0.6', '10.0.0.7'] }]
      end
      result = client.next_available_ip(network_ref: 'network/aaa', count: 3)
      expect(result[:ips]['ips'].length).to eq(3)
    end
  end
end
