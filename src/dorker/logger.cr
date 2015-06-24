module Dorker::Logger
    def log : Dorker::DorkerLogger
      self.class.apply_log_formatter Dorker::Server.get.logger
    end

    macro included
      def self.apply_log_formatter(logger)
        logger
      end

      def self.log : Dorker::DorkerLogger
        apply_log_formatter Dorker::Server.get.logger
      end
    end
end
