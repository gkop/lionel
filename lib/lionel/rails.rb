require 'nullobject'

module Rails
  def self.method_missing(method, *args, &block)
    Null::Object.instance
  end

  class Engine
  end

  class Railtie
    def self.method_missing(method, *args, &block)
      Null::Object.instance
    end
  end
end
