require 'spec_helper'
require 'rspec/json_expectations'

# TODO: needs some cleanup/helper to avoid this misery
module Puppet::Provider::HueLight; end
require 'puppet/provider/hue_light/hue_light'

RSpec.describe Puppet::Provider::HueLight::HueLight do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:hue_transport) { instance_double('Puppet::Transport::hueLight', 'hue_transport') }

  before(:each) do
    allow(context).to receive(:transport).and_return(hue_transport)
  end

  describe '#set' do
    let(:changes) do
      {
        'test' => {
          is: is_hash,
          should: should_hash,
        },
      }
    end
    let(:is_hash) do
      {
        name: 'test',
        on: true,
        bri: 254,
        hue: 1000,
        sat: 124,
        effect: 'none',
        alert: 'none',
      }
    end

    context 'when there are no changes to be made' do
      let(:should_hash) { is_hash }

      it 'does not call update' do
        expect(provider).not_to receive(:update)
        provider.set(context, changes)
      end
    end

    context 'when there are changes to be made' do
      let(:should_hash) do
        {
          name: 'test',
          on: true,
          bri: 254,
          hue: 1001,
          sat: 124,
          effect: 'none',
          alert: 'none',
        }
      end

      it 'calls update with changes' do
        expect(provider).to receive(:update).with(context, 'test', should_hash) # rubocop:disable RSpec/SubjectStub
        provider.set(context, changes)
      end
    end
  end

  describe '#get' do
    before(:each) do
      allow(hue_transport).to receive(:connection)
      allow(hue_transport).to receive(:hue_get).and_return(api_data)
    end

    context 'when no data is returned from HUE API' do
      let(:api_data) { nil }

      it 'returns no data' do
        expect(provider.get(context)).to eq([])
      end
    end

    context 'when data is returned from HUE API' do
      let(:api_data) do
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
      let(:hue_hash) do
        [{
          name: '1',
          on: true,
          bri: 254,
          hue: 25_072,
          sat: 254,
          effect: 'colorloop',
          alert: 'select',
        },
         {
           name: '2',
           on: true,
           bri: 254,
           hue: 19_928,
           sat: 254,
           effect: 'colorloop',
           alert: 'none',
         }]
      end

      it 'returns appropriate data struct' do
        expect(provider.get(context)).to eq(hue_hash)
      end
    end
  end

  describe '#update' do
    let(:should_hash) do
      {
        name: 'test',
        on: true,
        bri: 254,
        hue: 25_072,
        sat: 254,
        effect: 'colorloop',
        alert: 'none',
      }
    end

    it 'calls the hue_put method' do
      expect(hue_transport).to receive(:connection)
      expect(hue_transport).to receive(:hue_put).with('lights/test/state', anything, should_hash)
      provider.update(context, should_hash[:name], should_hash)
    end
  end
end
