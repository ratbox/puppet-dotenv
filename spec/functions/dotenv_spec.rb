require 'spec_helper'

describe 'dotenv' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, 'dotenv(): requires a hash argument') }
  it { is_expected.to run.with_params({}, 0).and_raise_error(Puppet::ParseError, 'dotenv(): too many arguments') }
  it { is_expected.to run.with_params(0).and_raise_error(Puppet::ParseError, 'dotenv(): requires a hash argument') }

  context 'default' do
    input = {
      'APP_NAME' => 'M-Pab',
      'APP_DESC' => 'Mental Pabulum',
    }

    output = <<-EOS
# Managed by Puppet

APP_NAME="M-Pab"
APP_DESC="Mental Pabulum"
EOS

    it { is_expected.to run.with_params(input).and_return(output) }
  end
end

# vim: ts=2 sw=2 et
