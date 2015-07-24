require "json"

class Dorker::Docker::Resources::Containers < Dorker::ClientResource

  def self.component
    "containers"
  end

  def initialize(@id)
  end
  
  def self.json(params = {} of String | Symbol => String | Symbol | Int32)
    client.class.parse_response(client.get("/containers/json"))

  end 

  def attach
    Dorker::Docker::Attach.attach(@id)
  end

  def read_attach
    Dorker::Docker::Attach.read(@id)
  end
end
