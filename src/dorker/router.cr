module Dorker::Router
  include Dorker::Logger

  class RoutingError < Exception; end

  def self.routes
    @@routes ||= {} of String => Dorker::Controller.class
  end

  def self.response
    HTTP::Response.ok "butts", Dorker::Router.routes.inspect
  end

  def self.route(req : HTTP::Request) : HTTP::Response
    req = Dorker::RequestObject.new(req)
    resp = if controller = routes[req.path]?
                      log.info "Routing: #{req.method} \"#{req.path}\" AS #{req.headers["Accept"]}"
      controller.dispatch(req)
    else
      raise RoutingError.new "Error routing to #{req.path}"
    end
    resp
  end
end

require "./controllers/*"
