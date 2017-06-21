require 'spec_helper'
describe 'sphinx' do

  context 'with defaults for all parameters' do
    it { should contain_class('sphinx') }
  end
end
