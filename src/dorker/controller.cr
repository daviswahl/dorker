require "./logger"
require "http"
require "./html/*"
class Thunk
  macro method_missing(name, args, block) 
    puts "woops"
  end
end

abstract class Dorker::Controller
  include Dorker::Logger
  @headers :: HTTP::Headers
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
  property :headers, :status, :body
  
  def initialize(req : Dorker::RequestObject)
    @request = req
    @headers = HTTP::Headers.new
    @status = 200
    @body = ""
  end

  def dispatch
    dynamic_dispatcher
    to_response
  end

  macro inherited
    Dorker::Router.routes[{{PATH}}] = {{@type}}
  end

  def render(k : Symbol)
    case k
    when :body
      @body = Dorker::HTML::Body.yield_into do |body|
        yield(body)
      end
    end
  end


  def to_response : HTTP::Response
    headers.add("Content-type", "text/html") if !headers.has_key?("Content-type")
    HTTP::Response.new(status, body, headers )
  end
end
