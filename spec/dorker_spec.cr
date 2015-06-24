require "./spec_helper"

describe Dorker::Docker::Client do
  # TODO: Write tests
  it "endpoints" do
    Dorker::Docker::Client.endpoints[:container].should eq Dorker::Docker::Forms::Containers
  end

  it "should respond to containers" do
    Dorker::Docker.client.containers.class.should eq Dorker::Docker::Forms::Containers
  end

  it "should raise" do
    expect_raises(Dorker::Docker::Client::UnknownEndpoint) { Dorker::Docker.client.butts }
  end

  it "should respond to containers.index" do
    puts Dorker::Docker.client.containers.index.get do |headers, body, query|
      query[:all] = "true"
    end.body
  end
  it "should respond to containers.index" do
    ##puts Dorker::Docker.client.containers.index.post do |headers, body, query|
     # body << "hi"
    #end
  end
end


