require 'spec_helper'

# TODO: needs some cleanup/helper to avoid this misery
module Puppet::Util::NetworkDevice::Philips_hue; end
require 'puppet/util/network_device/philips_hue/device'

RSpec.describe Puppet::Util::NetworkDevice::Philips_hue::Device do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
end
