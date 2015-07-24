class Dorker::Request
  def initialize(route)
  end
end
abstract class Dorker::Resource
  abstract def self.component

  def route
  	"/" + self.class.component
  end

end

abstract class Dorker::ClientResource < Dorker::Resource
  def self.client
    Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  end
end
