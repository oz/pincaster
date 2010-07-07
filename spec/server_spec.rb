require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pincaster::Server" do
  before(:all) do
    @server = Pincaster::Server.new
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

  # Can't test shutdown!, or the server would die, unless we have a x-platform, sane way
  # of restarting a service... *cough*
  it "should respond to shutdown!" do
    @server.respond_to?("shutdown!").should be_true
  end
end
