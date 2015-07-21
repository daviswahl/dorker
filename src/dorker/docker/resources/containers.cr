require "json"

class Dorker::Docker::Resources::Containers < ClientResource
  class ResponseItem
    getter :created, :id, :labels
    def initialize(json)
      @data = json as Hash 
    end
    def to_s
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
    "containers"
  end

  has_client Dorker::Docker::SocketClient.new("/var/run/docker.sock")

  resource("json") do
    get do
      ResponseItem.new(resp)
    end
  end

  resource(:id) do
    resource("json") do
    end

    resource("top") do
      get() do |resp|
        puts resp.body
      end
    end
  end
end
