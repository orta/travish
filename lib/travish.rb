require "rubygems"
require 'yaml'
require 'environment_parser'

module Travish
  class Runner

    def help
      puts ""
      puts "Travish - emulates the OSX experience for travis."
      puts ""
      puts "          run  - Runs the .travis.yml."
      puts ""
      puts "                                               ./"
    end

    def run
      validate
      travis_file = default_yml.merge local_travis_yml
      parser = EnvironmentParser.new(travis_file['env']['global'], ENV)

      run_commands(travis_file["before_install"], parser.environment_hash)
      run_commands(travis_file["install"], parser.environment_hash)
      run_commands(travis_file["before_script"], parser.environment_hash)
      run_commands(travis_file["script"], parser.environment_hash)
    end

    # -- faffing

    def initialize(args)
      # find a command
      @params = args
      command = @params[0].to_sym rescue :help
      commands.include?(command) ? send(command.to_sym) : help
    end

    private

    def run_commands(array, environment = {})
      return if array.nil?
      array = [array] if array.is_a?(String)
      array.each do |command|
        system(environment, command)
      end
    end

    def local_travis_yml
      YAML.load_file('.travis.yml')
    end

    def default_yml
      {}
    end

    def validate
      unless File.exists? ".travis.yml"
        puts "You need to have a `travis.yml` in this folder."
        exit
      end
    end

    def commands
      (public_methods - Object.public_methods).sort.map{ |c| c.to_sym }
    end

  end
end
