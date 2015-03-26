require "rubygems"
require 'yaml'

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
      environment = default_yml.merge local_travis_yml
      
      run_commands environment["before_install"]
      run_commands environment["install"]
      run_commands environment["before_script"]
      run_commands environment["script"]
    end
    
    # -- faffing
    
    def initialize(args)
      # find a command
      @params = args
      command = @params[0].to_sym rescue :help
      commands.include?(command) ? send(command.to_sym) : help
    end
    
    private
    
    def run_commands array
      array.each do |command|
        system command
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
