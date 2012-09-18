require "hobson/client"
require "irb"
require "json"
require "launchy"

Signal.trap("INT") { puts; exit(1) }

class Hobson::Client::Cli

  def initialize
    test_run = Hobson::Client::TestRun.create({
      'project_origin' => project_origin,
      'sha'            => sha,
      'requestor'      => requestor,
    })
    Launchy.open test_run.url
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
