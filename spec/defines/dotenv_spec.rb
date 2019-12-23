require 'spec_helper'

describe 'dotenv' do
  let(:params) do
    {
      entries: {
        APP_NAME: 'M-Pab',
        APP_DESC: 'Mental Pabulum',
      },
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:title) do
        if facts[:osfamily] == 'windows'
          'C:\app\.env'
        else
          '/opt/app/.env'
        end
      end

      it { is_expected.to compile }
    end
  end
end

# vim: ts=2 sw=2 et
