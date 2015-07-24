require "./spec_helper"
require "spec"
require "json"

def container
  Dorker::Docker::Resources::Containers.new
end

describe Dorker::Docker::SocketClient do

  it "should take posts" do
    #c = Dorker::Docker::Resources::Containers
    #puts c.new.id(1).top.route
  end
  it "should get" do
   #h = Dorker::Docker::Resources::Images.new.json.get({ all: true})
  end
  it "should post" do
    id = "496677cc0eeb9cc9229c7481eec8b7f09918f530bf91b48446295a015f7245fe"
    h = Dorker::Docker::Resources::Containers.new(id)
    h.attach
    sleep 2 
    puts h.read_attach
    sleep 5
    puts h.read_attach
  end

end


