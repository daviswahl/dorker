require "./logger"
require "http"
require "./html/*"

abstract class Dorker::Controller
  include Dorker::Logger
  @headers :: HTTP::Headers

    macro define_rest_methods(*methods)
      enum Method
        {% for method in methods %}
          {{ method.id.upcase }}
        {% end %}
      end
      {% for method in methods %}
        alias {{method.id.upcase}} = Method::{{method.id.upcase}}.class
      {% end %}
    end

    macro define_rest_endpoints(*endpoints)
      enum Endpoint
      {% for endpoint in endpoints %}
        {{ endpoint.id }}
      {% end %}
    end
    {% for endpoint in endpoints %}
      alias {{endpoint.id}} = Method::{{endpoint.id}}.class
    {% end %}
    end
   
    define_rest_methods(:GET, :POST)

    def dynamic_dispatcher
      req = @request.method
      meth = Method.parse(req)
      puts @endpoint
      log.info("Dispatching with #{self.class}#{req}")
      respond(typeof(meth))
    end
  property :headers, :status, :body
  
  def initialize(req : Dorker::RequestObject, match_data)
    @request = req
    @headers = HTTP::Headers.new
    @status = 200
    @body = ""
    @endpoint = match_data
  end

  def dispatch
    dynamic_dispatcher
    to_response
  end

  macro inherited
    Dorker::Router.routes[{{PATH}}] = {{@type}}
  end
  def active
    :images
  end
  def render(k : Symbol)
    case k
    when :body
      @body = Dorker::HTML::Body.yield_into(active) do |body|
        yield(body)
      end
    end
  end


  def to_response : HTTP::Response
    headers.add("Content-type", "text/html") if !headers.has_key?("Content-type")
    HTTP::Response.new(status, body, headers )
  end
end
