require "./logger"
abstract class Dorker::Controller
  include Dorker::Logger

  macro define_rest_endpoints(*endpoints)
    enum Endpoint
      {% for endpoint in endpoints %}
        {{ endpoint.id.upcase }}
      {% end %}
    end

    def dynamic_dispatcher
      endpoint = Endpoint.parse(@request.method)
      case endpoint
      {% for ep in endpoints %}
      when Endpoint::{{ep.id.upcase}}
        log.info("Dispatching with #{self.class}#{{ep.id}}")
        {{ep.id}}
      {% end %}
      else raise "Error"
      end
    end
  end

  def initialize(req : Dorker::RequestObject)
    @request = req
  end

  def self.dispatch(req : Dorker::RequestObject)
    controller = new(req)
    controller.dynamic_dispatcher
    controller.to_response
  end

  macro inherited
    Dorker::Router.routes[{{PATH}}] = {{@type}}
  end

  def render(k : Symbol)
    self.response[k] = String.build do |str|
      str << yield
    end
  end

  def body=(str : String)
   @body = str
  end

  def body
    @body
  end

  def response
    @response ||= {content: "text/html", body: "" } of Symbol => String
  end

  def to_response : HTTP::Response
    HTTP::Response.ok response[:content], response[:body]
  end
end
