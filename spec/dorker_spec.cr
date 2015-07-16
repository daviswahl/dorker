require "./spec_helper"
require "spec"

def client
  Dorker::Docker::SocketClient.new("/var/run/docker.sock")
end

describe Dorker::Docker::SocketClient do
  it "should take posts" do
    c = Dorker::Docker::Forms::Containers
    puts c.root.children.last.children.last.route
  end

end


