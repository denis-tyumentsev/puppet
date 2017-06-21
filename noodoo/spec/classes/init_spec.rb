require 'spec_helper'
describe 'noodoo' do

  context 'with defaults for all parameters' do
    it { should contain_class('noodoo') }
  end
end
