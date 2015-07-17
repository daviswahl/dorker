module Dorker::Docker

  def self.client
    @@client ||= Dorker::Docker::Client.new("/var/run/docker.sock")
  end

end


require "./*"
require "./resources/all"
