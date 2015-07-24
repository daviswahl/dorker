require "http/client"
require "socket"
require "json"
class Dorker::Docker::SocketClient < HTTP::Client
  def initialize(@host)
    @socket = UNIXSocket.new(@host)
  end

  {% for method in %w(get post put head delete patch) %}

    def {{method.id}}(path, headers = nil, body = nil)
      puts "#{{{method}}} #{path}"
                req = new_request({{method.upcase}}.to_s, path, headers, body)
                resp = exec(req)
    end

    def {{method.id}}(path, params : Hash, headers = nil, body = nil)
      path = path + hash_to_cgi(params) if params && params.keys[0]?
      self.{{method.id}}(path, headers, body)
    end
  {% end %}

  def stream(path, params : Hash, headers = nil, body = nil)
    h = HTTP::Headers.new
    string = path + hash_to_cgi(params)
    h.add("Connection", "Upgrade") 
    h.add("Upgrade","websocket")
    req = new_request("POST", string, h,  body)
    req.to_io(@socket)
    @socket
  end

  def self.parse_response(resp)

    arr = [] of Hash
    h = JSON.parse(resp.body) as Array(JSON::Type) | Hash(String, JSON::Type)

    h.each do |h2|
      r = {} of String => Nil | String | Bool | Int64 | Float64 | Hash(String, JSON::Type) | Array(JSON::Type) 
      (h2 as Hash(String, JSON::Type)).each do |k, v|
        r[k.to_s] = v
      end
      arr << r
    end
    arr
  end
  def hash_to_cgi(query)
    "?" + CGI.build_form do |form|
      query.each do |k, v|
        form.add k, v
      end
    end
  end
end
