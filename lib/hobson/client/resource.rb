class Hobson::Client::Resource

  class << self
    attr_accessor :resource_name

    def resource
      Hobson::Client.server["#{resource_name}s"]
    end

    def create data
      new JSON.parse(resource.post("#{resource_name}" => data))["#{resource_name}"]
    end

    def get id
      new JSON.parse(resource[id].get)["#{resource_name}"]
    end

    def attributes *names
      @@attributes ||= Set[]
      unless names.empty?
        @@attributes += names.to_set
        attr_accessor *names
      end
      @@attributes
    end

    def nested_resource name, options
      resource = options[:class]
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} ||= @table[:#{name}].map do |data|
            #{resource}.new(data)
          end
        end
      RUBY
    end

  end

  def initialize attributes
    attributes.each_pair do |key, value|
      instance_variable_set(:"@#{key}", value)
    end
  end

  def attributes
    self.class.attributes.inject({}) do |hash, attribute|
      hash.update(attribute => instance_variable_get(:"@#{attribute}"))
    end
  end

  def save
    puts self.class.resource[id].put("#{self.class.resource_name}" => attributes)
  end


  def url
    Hobson::Client.server[path].url
  end


end
