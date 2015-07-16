require "http/client"
require "socket"

class Dorker::Docker::SocketClient < HTTP::Client
  def initialize(@host)
    @socket = UNIXSocket.new(@host)
  end
  {% for method in %w(get post put head delete patch) %}
    def {{method.id}}(path, headers = nil, body = nil) : ->
      req = new_request({{method.upcase}}.to_s, path, headers, body)
      yield(req )
      resp = exec(req)
      yield(resp) || resp
    end
 {% end %}
end
