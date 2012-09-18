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

  def self.nested_resource name, options
    resource = options[:class]
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{name}
        @#{name} ||= @table[:#{name}].map do |data|
          #{resource}.new(data)
        end
      end
    RUBY
  end


  def url
    Hobson::Client.server[path].url
  end


end
