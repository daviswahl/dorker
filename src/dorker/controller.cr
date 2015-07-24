require "./logger"
require "http"
require "./html/*"

abstract class Dorker::Controller
  include Dorker::Logger

  @headers :: HTTP::Headers
  struct RestMethod
  end
  struct Get < RestMethod
  end
  struct Post < RestMethod
  end

  alias GET = Get.class
  alias POST = Post.class
  
  enum Method
    GET 
    POST

    def rest
      case self
      when GET; Get
      when POST; Post
      else
        RestMethod
      end
    end
  end

  def respond(id, action, method)
    log.info  "no method for #{id}, #{action}, #{method} on #{self.class}"
    HTTP::Response.not_found
  end

  def respond(action, method)
    log.info  "no method for #{action}, #{method}"
    HTTP::Response.not_found
  end
  def respond(method)
    log.info  "no method for #{method}"
    HTTP::Response.not_found
  end

  macro action(name, method, id = nil, &block)
    {% if !block.args.empty? %}
      
      def respond(%id, %m : {{name.id.upcase}}, %t : {{method}})
         {{block.args.first}} = %id
         {{block.body}}
      end
    {% else %} def respond(%m : {{name}}, %t : {{method}})
         {{block.body}}
       end
    {% end %}
    {{ debug()}}
  end

 abstract def parse_endpoint
 def dynamic_dispatcher
    path = @request.path

    tuple = @dispatch_tuple
    id = tuple[0]
    action = tuple[1]
    method = tuple[2]

    if id && action 
      log.info("Dispatching #{path} with #{id}, #{action}, #{method}" )
      respond(id, action, method)
    elsif id && !action 
      log.info("Dispatching #{path} with #{id}, #{method}" )
      respond(id, method)
    elsif action && !id
      log.info("Dispatching #{path} with #{action}, #{method}")
      respond(action, method)
    else
      log.info("Dispatching #{path} with #{method}")
      respond(method)
    end
  end
  property :headers, :status, :body
  
  def initialize(req : Dorker::RequestObject, match_data)
    @request = req
    @headers = HTTP::Headers.new
    @status = 200
    @body = ""
    action = match_data["method"]? || "index"
    action = action ? parse_endpoint(action).meth : nil
    id = match_data["id"]?
    method = Method.parse(@request.method).rest
    @dispatch_tuple = Tuple.new(id, action,  method)
  end

  def dispatch
    dynamic_dispatcher
    to_response
  end
  macro endpoints(*endpoints)

    enum Endpoint
      {% for endpoint in endpoints %}
        {{endpoint.id.upcase}}
      {% end %}      
      def meth
        case self 
          {% for endpoint in endpoints %}
          when {{endpoint.id.upcase}}
            {{@type}}::{{endpoint.id.capitalize}}
          {% end %}      
        else
          nil
        end
      end
  
    end

    {% for endpoint in endpoints %}
      struct {{endpoint.id.capitalize}}; end
      alias {{endpoint.id.upcase}} = {{@type}}::{{endpoint.id.capitalize}}.class
    {% end %}

  end
  macro inherited
    macro def parse_endpoint(endpoint) : Endpoint
      Endpoint.parse(endpoint)
    end
 
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
