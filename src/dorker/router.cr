module Dorker::Router
  include Dorker::Logger

  class RoutingError < Exception; end

  def self.routes
    @@routes ||= {} of Regex => Dorker::Controller.class
  end

  def self.find_route(req : Dorker::RequestObject)
    path = req.path
    if path 
      routes.each do |r, v|
        if r.match(path)
          puts r
          puts v
          return v.new(req) 
        end
      end
    end
    raise RoutingError.new
  end
  def self.response
    HTTP::Response.ok "butts", Dorker::Router.routes.inspect
  end

  def self.route(req : HTTP::Request) : HTTP::Response
    req = Dorker::RequestObject.new(req)
    controller = find_route(req)
    if controller.nil? || controller == false || controller.is_a?(Bool)
      raise RoutingError.new "Error routing to #{req.path}"
      return HTTP::Response.not_found
    elsif controller && !controller.is_a?(Bool) 
      log.info "Routing: #{req.method} \"#{req.path}\" AS #{req.headers["Accept"]}"
      return controller.dispatch
    end
    HTTP::Response.not_found
  end
end

require "./controllers/*"
