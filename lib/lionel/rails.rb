require 'nullobject'

module Rails
  def self.method_missing(method, *args, &block)
    Null::Object.instance
  end

  class Railtie
    def self.method_missing(method, *args, &block)
      Null::Object.instance
    end
  end

  class Engine < Railtie
  end
end
