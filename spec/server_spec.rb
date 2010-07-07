require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pincaster::Server" do
  before(:all) do
    @test_layer_name = 'pincaster_test'
    @server = Pincaster::Server.new
  end

  after(:all) do
    @server.delete "layers/#{@test_layer_name}.json"
  end

  it "should have a default config" do
    Pincaster::Server.default_config.should be_a Struct::PincasterServerConfig
  end

  it "should expose its configuration options" do
    @server.config.host.should == Pincaster::Server.default_config.host
  end

  it "should compose a valid server URI" do
    @server.uri.should be_a URI::HTTP
    @server.uri.to_s.should == 'http://localhost:4269/api/1.0/'
  end

  it "should forget cached URI" do
    cached = @server.uri
    @server.uri!
    @server.uri.should_not equal cached
  end

  it "should respond to ping" do
    @server.ping.should be_true
  end

  # I can't fully test shutdown!... or the server would die. Do we have a
  # safe x-platform way of restarting a service? :p *cough*
  it "should respond to shutdown!" do
    @server.respond_to?("shutdown!").should be_true
  end

  it "should provide a method for each HTTP verb" do
    %w(get post put delete).each do |verb|
      @server.respond_to?(verb).should be_true
    end
  end

  it "should list layers" do
    @server.post "layers/#{@test_layer_name}.json"

    layers = @server.layers
    layers.should be_a Array
    layers.first.should be_a Pincaster::Layer

    layers.select { |layer| layer.name == @test_layer_name }.should_not be_empty
  end
end
