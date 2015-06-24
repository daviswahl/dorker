class Dorker::Controller

  abstract def self.get
  abstract def self.post

  def initialize(req : HTTP::Request)
    @request = req
  end

  def self.dispatch(req : HTTP::Request)
    puts req.inspect
    new(req).to_response
  end

  macro inherited
    Dorker::Router.routes[{{PATH}}] = {{@type}}
  end

  def to_response : HTTP::Response
    HTTP::Response.ok "asdf", inspect
  end
end
