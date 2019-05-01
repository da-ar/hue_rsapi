require 'spec_helper'
require 'puppet/util/network_device/philips_hue/device'

RSpec.describe Puppet::Util::NetworkDevice::Philips_hue::Device do
  let(:connection_info) do
    {
      host: '10.1.1.1',
      key:  'superdupersecretkey',
    }
  end

  it 'initialises correctly' do
    expect(described_class.new(connection_info).transport).to be_instance_of(Puppet::Transport::PhilipsHue)
  end
end
