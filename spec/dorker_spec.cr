require "./spec_helper"
require "spec"
require "json"

def container
  Dorker::Docker::Resources::Containers.new
end

describe Dorker::Docker::SocketClient do

  it "should take posts" do
    c = Dorker::Docker::Resources::Containers
    puts c.new.id(1).top.route
  end
  it "should get" do
   h = Dorker::Docker::Resources::Images.new.json.get({ all: true})
   puts h.first
  end
end


