class Dorker::Docker::Client
  class UnknownEndpoint < Exception; end

  def self.endpoints
    @@endpoints ||= {} of Symbol => Dorker::Docker::Form.class
  end

  def initialize(host : String)
    @socket = SocketClient.new(host)
  end

  def get(path)
    @socket.get(path)
  end

  macro method_missing(name, *args, block)
    if self.class.endpoints[:{{name.id}}]?
      self.class.endpoints[:{{name.id}}].new
    else
      raise UnknownEndpoint.new "Endpoint #{{{name}}} Not Defined"
    end
  end
end
