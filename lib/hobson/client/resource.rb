require 'ostruct'

class Hobson::Client::Resource < OpenStruct

  def self.resource
    Hobson::Client.server["#{@name}s"]
  end

  def self.create data
    new JSON.parse(resource.post("#{@name}" => data))["#{@name}"]
  end

  def self.get id
    new JSON.parse(resource[id].get)["#{@name}"]
  end



  def url
    Hobson::Client.server[path].url
  end


end
