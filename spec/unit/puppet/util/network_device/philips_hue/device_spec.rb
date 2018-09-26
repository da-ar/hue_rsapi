require 'spec_helper'
require 'puppet/util/network_device/philips_hue/device'

RSpec.describe Puppet::Util::NetworkDevice::Philips_hue::Device do
  let(:provider) { described_class.new(url) }
  let(:connection) { class_double('Faraday') }
  let(:url) { 'file:///spec/fixtures/homehub.conf' }
  let(:config) do
    {
      'default' =>  {
        'node' => {
          'ip' => '10.1.1.1',
          'key' => 'superdupersecretkey',
        },
      },
    }
  end

  before(:each) do
    allow(File).to receive(:exist?).and_return(true)
    allow(Hocon).to receive(:load).and_return(config)
  end

  describe '#initialize' do
    context 'when a valid file url is provided' do
      it { expect { provider }.not_to raise_error }
      it 'connects to the right url' do
        expect(Faraday).to receive(:new).with(ssl: { verify: false }, url: 'http://10.1.1.1/api/superdupersecretkey')
        provider
      end
    end

    context 'when an invalid url is provided' do
      let(:url) { 'http://www.puppet.com' }

      it { expect { provider }.to raise_error %r{Unexpected url} }
    end
  end

  describe '#facts' do
    it { expect(provider.facts).to be_a(Hash) }
    it { expect(provider.facts['operatingsystem']).to eq('philips_hue') }
  end

  describe '#config' do
    it 'returns the configuration' do
      expect(provider.config).to eq(config)
    end
  end

  describe '#hue_get(url, connection, args = nil)' do
    let(:response) { instance_double('Faraday::Response') }

    before(:each) do
      allow(connection).to receive(:get).and_return(response)
      allow(response).to receive(:body).and_return(api_data)
    end

    context 'when the api returns valid data' do
      let(:api_data) do
        <<DATA
        {
          "1": {
            "state": {
              "on": true,
              "bri": 254,
              "hue": 25072,
              "sat": 254,
              "effect": "colorloop",
              "alert": "select"
            }
          },
          "2": {
            "state": {
              "on": true,
              "bri": 254,
              "hue": 19928,
              "sat": 254,
              "effect": "colorloop",
              "alert": "none"
            }
          }
        }
DATA
      end
      let(:parsed_data) do
        {
          '1' =>
          {
            'state' =>
            {
              'on' => true,
              'bri' => 254,
              'hue' => 25_072,
              'sat' => 254,
              'effect' => 'colorloop',
              'alert' => 'select',
            },
          },
          '2' =>
          {
            'state' =>
            {
              'on' => true,
              'bri' => 254,
              'hue' => 19_928,
              'sat' => 254,
              'effect' => 'colorloop',
              'alert' => 'none',
            },
          },
        }
      end

      it 'returns parsed api data' do
        expect(provider.hue_get('someurl', connection)).to eq(parsed_data)
      end
    end

    context 'when the api returns unparsable data' do
      let(:api_data) { 'NOT JSON' }

      it {
        expect { provider.hue_get('someurl', connection) }.to raise_error Puppet::ResourceError, %r{Unable to parse JSON response}
      }
    end
  end

  describe '#hue_put(url, conection, message)' do
    let(:message) do
      {
        on: true,
        bri: 254,
        hue: 25_000,
        sat: 254,
        effect: 'none',
        alert: 'select',
      }
    end
    let(:json) { '{"on":true,"bri":254,"hue":25000,"sat":254,"effect":"none","alert":"select"}' }

    it 'sends JSON data to the HUE API' do
      expect(connection).to receive(:put).with('someurl', json)
      provider.hue_put('someurl', connection, message)
    end
  end

  describe '#self.device(url)' do
    it { expect(described_class.device(url)).to be_a(described_class) }
  end
end
