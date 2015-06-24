require "http/client"
require "socket"

class Dorker::Docker::SocketClient < HTTP::Client
  def initialize(@host)
    @socket = UNIXSocket.new(@host)
  end
end
