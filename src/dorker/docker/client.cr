class Dorker::Docker::Client
  include Dorker::Logger

  class UnknownEndpoint < Exception; end
  enum RestMethod
  GET
  POST
  PUT
  end

  def self.endpoints
    @@endpoints ||= {} of Symbol => Dorker::Docker::Form.class
  end

  def initialize(host : String)
    @socket = SocketClient.new(host)
  end

  {% for method in %w(get put post delete) %}
   def {{method.id}}(path)
    @socket.{{method.id}}(path)
   end

   def {{method.id}}(path)
     headers = HTTP::Headers.new
     headers["Host"] = "/var/run/docker.sock"
     query = {} of Symbol => String

     body = String.build do |body|
       yield(headers, body, query)
     end
     params = CGI.build_form do |form|
       query.each do |k,v|
        form.add k.to_s, v
       end
     end
     uri = String.build { |p| p << path << "?" << params }
     log.info(uri, body)
     @socket.{{method.id}}(uri, headers, body)
   end
  {% end %}
  macro method_missing(name, *args, block)
    if self.class.endpoints[:{{name.id}}]?
      self.class.endpoints[:{{name.id}}].new
    else
      raise UnknownEndpoint.new "Endpoint #{{{name}}} Not Defined"
    end
  end
end
