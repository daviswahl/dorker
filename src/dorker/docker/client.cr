class Dorker::Docker::Client
  include Dorker::Logger

  class UnknownEndpoint < Exception; end
  enum RestMethod
  GET
  POST
  PUT
  end


end
