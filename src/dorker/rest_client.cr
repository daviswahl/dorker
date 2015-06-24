require "http/client"
require "socket/socket"

class UnixClient < HTTP::Client
  def initialize(@host)
    @socket = UNIXSocket.new(@host)
  end
end

class RestClient
  def initialize(path : String)
    @path = path
  end

  def parse_headers_and_body(io)
    headers = HTTP::Headers.new

    while line = io.gets
      if line == "\r\n" || line == "\n"
        body = nil
        if content_length = headers["content-length"]?
          body = io.read(content_length.to_i)
        elsif headers["transfer-encoding"]? == "chunked"
          body = HTTP.read_chunked_body(io)
        end
        yield headers, body
        break
      end
      str = line.chomp.split ':'
      name, value = str[0], str[1]? || ""
      headers.add(name, value.lstrip)
    end

  end

  def get(path : String)
   c = UnixClient.new("/var/run/docker.sock")
   resp = c.get("/containers/json")
   puts resp.inspect
  end
end
