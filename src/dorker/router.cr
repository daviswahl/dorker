module Dorker::Router
  class RoutingError < Exception; end
  extend self
  def routes
    @@routes ||= {} of String => Dorker::Controller.class
  end

  def response
    HTTP::Response.ok "butts", Dorker::Router.routes.inspect
  end

  def route(req : HTTP::Request) : HTTP::Response
    if controller = routes[req.path]?
      controller.dispatch(req)
    else
      raise RoutingError.new req.path
    end
  end
end

require "./controllers/*"
