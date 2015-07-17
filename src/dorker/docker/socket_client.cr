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
      parse_response(resp)
    end

    def {{method.id}}(path, params : Hash, headers = nil, body = nil)
      string = path + hash_to_cgi(params)
      self.{{method.id}}(string, headers, body)
    end
 {% end %}

  def parse_response(resp)

    arr = [] of Hash
    h = JSON.parse(resp.body) as Array(JSON::Type) | Hash(String, JSON::Type)

    h.each do |h2|
      r = {} of String => Nil | String | Bool | Int64 | Float64 | Hash(String, JSON::Type) | Array(JSON::Type) 
      (h2 as Hash(String, JSON::Type)).each do |k, v|
        r[k.to_s] = v
      end
      arr << r
    end
  end
  def hash_to_cgi(query)
    "?" + CGI.build_form do |form|
      query.each do |k, v|
       form.add k, v
      end
    end
  end
end
