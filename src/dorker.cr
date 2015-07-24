require "./dorker/*"
require "logger"
require "./dorker/docker/*"

module Dorker
  class DorkerLogger(T) < ::Logger(T)

    @class_formatter = ->(msg : String) { msg }
    def class_formatter(&block : String -> String)
      @class_formatter = block
    end

    def class_formatter(message : String) : String
        @class_formatter.call(message)
    end

    def class_format(message)
      msg = class_formatter(message)
      class_formatter &->(msg : String){  msg }
      msg
    end
  end
end

def main
  Dorker::Server.new
  server = Dorker::Server.get
  log = Dorker::DorkerLogger.new(STDOUT)
  log.level = Logger::INFO

  log.formatter =  ::Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << severity << " " << log.class_format(message)
  end

  server.logger = log
  Dorker::Server.get.run
end

main()
