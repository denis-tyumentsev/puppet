require 'spec_helper'
describe 'zabbix_up' do

  context 'with defaults for all parameters' do
    it { should contain_class('zabbix_up') }
  end
end
