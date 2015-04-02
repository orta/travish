require 'spec_helper'
require_relative '../lib/environment_parser.rb'

module Travish
  RSpec.describe EnvironmentParser do
    describe '.environment_hash' do
      let(:global_env) do
        [
          'KEY1=VALUE1 KEY2=VALUE2',
          { 'KEY3' => 'VALUE3' },
          'KEY_WITH_QUOTED_VALUE="QUOTED"'
        ]
      end

      let(:overrides) do
        [
          { 'KEY1' => 'V1', 'KEY2' => 'V2', 'KEY3' => 'not V3' },
          { 'KEY3' => 'V3' }
        ]
      end

      it 'produces the correct result without overrides' do
        parser = described_class.new(global_env)
        hash = parser.environment_hash

        expect(hash).to eq('KEY1' => 'VALUE1',
                           'KEY2' => 'VALUE2',
                           'KEY3' => 'VALUE3',
                           'KEY_WITH_QUOTED_VALUE' => 'QUOTED')
      end

      it 'produces the corect result with overrides' do
        parser = described_class.new(global_env, *overrides)
        hash = parser.environment_hash

        expect(hash).to eq('KEY1' => 'V1', 'KEY2' => 'V2',
                           'KEY3' => 'V3', 'KEY_WITH_QUOTED_VALUE' => 'QUOTED')
      end

      it 'produces the correct result with a single string as the environment' do
        parser = described_class.new('KEY=VALUE OTHER_KEY="OTHER_VALUE"')
        hash = parser.environment_hash

        expect(hash).to eq('KEY' => 'VALUE', 'OTHER_KEY' => 'OTHER_VALUE')
      end
    end
  end
end
