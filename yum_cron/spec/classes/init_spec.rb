require 'spec_helper'
describe 'yum_cron' do

  context 'with defaults for all parameters' do
    it { should contain_class('yum_cron') }
  end
end
