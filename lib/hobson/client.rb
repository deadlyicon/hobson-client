require "rest_client"
require "yaml"
require "json"

module Hobson
  module Client

    class << self
      attr_writer :config
    end

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

require "hobson/client/resource"
require "hobson/client/test_run"

