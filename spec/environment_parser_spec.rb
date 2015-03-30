require 'spec_helper'
require_relative '../lib/environment_parser.rb'

module Travish
  RSpec.describe EnvironmentParser do
    let(:global_env) do
      [
        'KEY1=VALUE1 KEY2=VALUE2',
        { 'KEY3' => 'VALUE3' },
        'KEY_WITH_QUOTED_VALUE="QUOTED"'
      ]
    end

    describe 'without override' do
      let(:parser) { described_class.new(global_env) }

      it 'produces the correct environment_hash' do
        hash = parser.environment_hash

        expect(hash).to eq('KEY1' => 'VALUE1',
                           'KEY2' => 'VALUE2',
                           'KEY3' => 'VALUE3',
                           'KEY_WITH_QUOTED_VALUE' => 'QUOTED')
      end
    end

    describe 'with override' do
      let(:overrides) do
        [
          { 'KEY1' => 'V1', 'KEY2' => 'V2', 'KEY3' => 'not V3' },
          { 'KEY3' => 'V3' }
        ]
      end
      let(:parser) { described_class.new(global_env, *overrides) }

      it 'produces the corect environment_hash' do
        hash = parser.environment_hash

        expect(hash).to eq('KEY1' => 'V1', 'KEY2' => 'V2',
                           'KEY3' => 'V3', 'KEY_WITH_QUOTED_VALUE' => 'QUOTED')
      end
    end

    describe 'string environment' do
      let(:parser) { described_class.new('KEY=VALUE OTHER_KEY="OTHER_VALUE"') }

      it 'produces the correct environment_hash' do
        hash = parser.environment_hash

        expect(hash).to eq('KEY' => 'VALUE', 'OTHER_KEY' => 'OTHER_VALUE')
      end
    end
  end
end
