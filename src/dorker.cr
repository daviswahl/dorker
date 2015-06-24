require "./dorker/*"
require "logger"


module Dorker
  def self.logger=(logger)
    @@logger = logger
  end

  def self.logger
    @@logger
  end

  def self.log
    @@logger
  end
  # TODO Put your code here
end

def main
  Dorker::Server.new
  server = Dorker::Server.get
  log = Logger.new(STDOUT)
  log.level = Logger::DEBUG
  server.logger = log

  Dorker::Server.get.run
end

main()
