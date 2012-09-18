class Hobson::Client::Resource

  class << self

    def resource_name resource_name=nil
      @resource_name = resource_name unless resource_name.nil?
      @resource_name
    end

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
      @attributes ||= Set[]
      unless names.empty?
        @attributes += names.to_set
        attr_accessor *names
      end
      @attributes
    end

    def nested_resource attribute, options
      # @@nested_resources ||= Set[]
      # options[:attribute] = attribute
      # @@nested_resources << options

      klass = options[:class]
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attribute}
          @#{attribute}.map! do |instance|
            instance.is_a?(#{klass}) ? instance : #{klass}.new(instance)
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
