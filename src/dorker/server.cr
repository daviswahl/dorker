require "http/server"
require "./router"
require "logger"
module Dorker
  class Server
    def initialize
      if $server
        raise "Cannot initialize two servers"
      end
      $server = self
    end

    def self.get : Dorker::Server
      $server || Dorker::Server.new
    end

    def run
      log.info("Starting Server")
      server = HTTP::Server.new(8080) do |request|
        response = handle_request(request)
      end
      server.listen
    end

    def handle_request(request : HTTP::Request) : HTTP::Response
      begin
        Dorker::Router.route(request)
      rescue e : Router::RoutingError
        log.error(e)
        HTTP::Response.not_found
      end
    end

    def logger=(arg)
      @logger = arg
    end

    def logger
      @logger || Dorker::DorkerLogger.new(STDOUT)
    end

    def log
      logger
    end
  end
end



