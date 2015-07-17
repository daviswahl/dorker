class Dorker::Docker::Resources::Images < Dorker::ClientResource
  def self.component
   "images"
  end

  has_client Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  resource("json") do
    get do
      resp
    end
  end
end
