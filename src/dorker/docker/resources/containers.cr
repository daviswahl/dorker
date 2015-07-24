require "json"

class Dorker::Docker::Resources::Containers < Dorker::ClientResource

  def self.component
    "containers"
  end

  def initialize(@id)
  end
  
  def self.json(params : Hash(String | Symbol, String | Symbol | Int32)?)
    client.class.parse_response(client.get("/containers/json", params))
  end 

  def start
    self.class.client.post("/containers/#{@id}/start")
  end

  def attach
    Dorker::Docker::Attach.attach(@id)
  end

  def read_attach
    Dorker::Docker::Attach.read(@id)
  end
end
