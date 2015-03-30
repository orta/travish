module Travish
  # Handle parsing the environment from a .travis.yml file
  # and merging it with overrides from other source such as
  # ENV
  class EnvironmentParser
    STRING_REG_EX = /^(.+)="?(.+?)"?$/

    attr_accessor :environment_hash

    # Create a new instance of `EnvironmentParser`
    def initialize(env, *args)
      @env = env
      @env = [@env] if @env.is_a? String
      @override_envs = args
      @override_envs ||= []
    end

    # The resulting environment has after merging
    # the environment from the travis file with
    # the specified overrides. This method is lacy
    # and calculates its result on the first call
    def environment_hash
      @environment_hash ||= build_environment_hash
    end

    private

    def build_environment_hash
      parsed_variables = {}
      @env.each do |env_row|
        # Each row can potentially contain multiple environment
        # variables
        variables = extract_variables(env_row)

        variables.each do |variables_with_values|
          variables_with_values.each do |key, value|
            parsed_variables[key] = value
          end
        end
      end

      @override_envs.each do |env|
        parsed_variables = parsed_variables.merge env
      end

      parsed_variables
    end

    def extract_variables(variable)
      return [variable] if variable.is_a? Hash
      return extract_variables_from_string(variable) if variable.is_a? String

      []
    end

    def extract_variables_from_string(string)
      string.split(/ /).map do |defintion|
        match = defintion.match STRING_REG_EX
        next nil unless match

        { match[1] => match[2] }
      end.reject(&:nil?)
    end
  end
end
