require 'spec_helper'
require 'puppet/type/hue_light'

RSpec.describe 'the hue_light type' do
  it 'loads' do
    expect(Puppet::Type.type(:hue_light)).not_to be_nil
  end
end
