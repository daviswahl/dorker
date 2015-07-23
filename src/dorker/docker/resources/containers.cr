require "json"

class Dorker::Docker::Resources::Containers < Dorker::ClientResource

  has_client Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  def self.component
    "containers"
  end
  def buffer
    ret = @buffer
    @buffer = [] of String
    ret
  end
  def initialize(@id)
    @c = UnbufferedChannel(String).new
    @buffer = [] of String
  end

  def attach
    path = route + "/" +  @id + "/attach"
    resp = client.stream(path, {  "stdin" : "1", "stream" : "1" })
    spawn do 
      resp.each_line do |l|
        puts "got line"
        @c.send(l)    
      end
    end
    spawn do
      @buffer << @c.receive
    end
  end
end
