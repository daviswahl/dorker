require "json"
class Dorker::Docker::Resources::Images < Dorker::ClientResource
  class ResponseItem
    getter :created, :id, :labels
    def initialize(json)
      @data = json as Hash 
      @created = @data["Created"]
      @id = @data["Id"]
      @labels = @data["Labels"]
    end
    def to_s
      "Created: #{created}, id: #{id}, labels: #{labels}"
    end
  end
  class ResponseSet 

    include Enumerable(ResponseItem)

    def initialize(json)
      @data = json.map { |j| ResponseItem.new(j)  } 
    end

    def each
      data = @data
      if data
        data.each do |e|
          yield e
        end
      end
    end
  end
  def self.component
   "images"
  end

  has_client Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  resource("json") do
    get do
      ResponseSet.new(resp)
    end
  end
end

