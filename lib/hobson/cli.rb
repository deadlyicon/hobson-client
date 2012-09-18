require "rest_client"
require "yaml"
require "irb"
require "json"

Signal.trap("INT") { puts; exit(1) }

module Hobson
  class Cli

    def initialize
      response = server['test_runs'].post(test_run: test_run_data)
      p JSON.parse(response)
    end

    def test_run_data
      {
        'project_origin' => project_origin,
        'sha'            => sha,
        'requestor'      => requestor,
      }
    end

    def server
      @server ||= RestClient::Resource.new(config[:server])
    end

    def config
      @config ||= YAML.load_file('config/hobson.yml')
    end

    def project_origin
      origin = `git config --get remote.origin.url`.chomp
      raise "unable to infer project origin" if origin.nil? || origin.empty?
      origin
    end

    def sha
      `git rev-parse HEAD`.chomp or raise
    end

    def requestor
      `git var -l | grep GIT_AUTHOR_IDENT`.split('=').last.split(' <').first
    rescue
      raise "unable to infer requestor"
    end

  end
end


Hobson::Cli.new
