module Dorker::Logger
    def log
      Dorker.logger
    end

    macro included
      def self.log
        Dorker.logger
      end
    end
end
