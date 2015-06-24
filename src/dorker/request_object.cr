require "cgi"
require "uri"
class Dorker::RequestObject
  include Dorker::Logger

  getter params
  getter path
  getter body
  getter accept
  getter headers
  getter method

  def initialize(req : HTTP::Request)

    uri = URI.parse(req.path)
    @path = uri.path
    @params = CGI.parse(uri.query.to_s)
    @body = req.body
    @accept = parse_accept(req.headers["Accept"])
    @method = req.method
    @headers = req.headers
    log.debug(self.inspect)
  end

  def parse_accept(accept : String)
    log.debug("Parsing Accept #{accept}")
  end
end
