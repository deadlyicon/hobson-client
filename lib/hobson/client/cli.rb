require "hobson/client"
require "rest_client"
require "yaml"
require "irb"
require "json"
require "launchy"

Signal.trap("INT") { puts; exit(1) }

class Hobson::Client::Cli

  def initialize
    response = server['test_runs'].post(test_run: test_run_data)
    data = JSON.parse(response)
    puts data.to_yaml
    Launchy.open server[data['test_run']['path']].url
  end

  def test_run_data
    {
      'project_origin' => project_origin,
      'sha'            => sha,
      'requestor'      => requestor,
    }
  end

  def server
    @server ||= RestClient::Resource.new(config[:server], :headers => {
      :accept => 'application/json, text/javascript, */*; q=0.01'
    })
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

Hobson::Client::Cli.new
