require 'ostruct'

class Hobson::Client::TestRun < OpenStruct

  def self.resource
    Hobson::Client.server['test_runs']
  end

  def self.create data
    new JSON.parse(resource.post(test_run: data))['test_run']
  end

  def url
    Hobson::Client.server[path].url
  end

end
