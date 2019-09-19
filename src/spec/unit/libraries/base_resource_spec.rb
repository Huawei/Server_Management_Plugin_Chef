require 'spec_helper'

describe 'base_resource' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  msg = 'Please specify action'

  context 'ibmc_base with default action' do
    step_into :ibmc_base
    recipe do
      ibmc_base 'test'
    end

    it do
      is_expected.to write_log(msg)
    end
  end

  context 'other resource with default action' do
    step_into :ibmc_bios
    recipe do
      ibmc_bios 'test'
    end

    it do
      is_expected.to write_log(msg)
    end
  end
end
