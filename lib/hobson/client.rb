require "rest_client"
require "yaml"

module Hobson
  module Client

    def self.config
      @config ||= YAML.load_file('config/hobson.yml')
    end

    def self.server
      @server ||= RestClient::Resource.new(config[:server], :headers => {
        :accept => 'application/json, text/javascript, */*; q=0.01'
      })
    end

  end
end

require "hobson/client/test_run"

