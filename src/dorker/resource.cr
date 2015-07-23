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
 macro has_client(client)
    def client
      {{client}}
    end
  end

  def client
  	parent.client
  end

end
