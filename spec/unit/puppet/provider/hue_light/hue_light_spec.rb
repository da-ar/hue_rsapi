require 'spec_helper'
require 'rspec/json_expectations'

# TODO: needs some cleanup/helper to avoid this misery
module Puppet::Provider::HueLight; end
require 'puppet/provider/hue_light/hue_light'

RSpec.describe Puppet::Provider::HueLight::HueLight do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:hue_device) { instance_double('Puppet::Util::NetworkDevice::Philips_hue::device', 'hue_device') }
  let(:rest_connection) { class_double('Faraday', 'rest_connection') }

  describe '#set' do
    let(:current) do
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
      let(:changes) do
        {
          'test' => {
            is: current,
            should: {
              name: 'test',
              on: true,
              bri: 254,
              hue: 1000,
              sat: 124,
              effect: 'none',
              alert: 'none',
            },
          },
        }
      end

      it 'does not call update' do
        expect(provider).not_to receive(:update)
        provider.set(context, changes)
      end
    end

    context 'when there are changes to be made' do
      let(:changes) do
        {
          'test' => {
            is: current,
            should: {
              name: 'test',
              on: true,
              bri: 254,
              hue: 1001,
              sat: 124,
              effect: 'none',
              alert: 'none',
            },
          },
        }
      end
      let(:url) { 'lights/test/state' }

      it 'calls update with changes' do
        allow(context).to receive(:device).and_return(hue_device)
        expect(hue_device).to receive(:connection).and_return(rest_connection)

        output_should = changes['test'][:should].dup
        output_should.delete(:name)

        expect(rest_connection).to receive(:put).with(url, include_json(output_should)).once
        provider.set(context, changes)
      end
    end
  end

  describe '#get' do
  end

  describe '#update' do
  end

  describe '.hue_get' do
  end

  describe '.hue_put' do
  end
end
