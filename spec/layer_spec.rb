require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pincaster::Layer" do
  before(:all) do
    @local_server = Pincaster::Server.new
  end

  it "should instanciate cleanly" do
    Pincaster::Layer.new.should be_a Pincaster::Layer
  end

  it "should register a new layer" do
    layer = Pincaster::Layer.new :name => 'a_new_layer', :server => @local_server
    layer.register.should be_true

    layer2 = Pincaster::Layer.register 'a_new_layer', :server => @local_server
    layer2.should be_a Pincaster::Layer
  end

  it "should delete a layer" do
    Pincaster::Server.new.layers.first.delete.should be_true
  end

  it "should raise an exception when trying to create layers without a server" do
    failing = lambda { Pincaster::Layer.new(:name => "foo").save }
    failing.should raise_error Pincaster::LayerError
  end

  it "should raise an exception when trying to delete non-existent layers" do
    failing = lambda { Pincaster::Layer.new(:name => "i_dont_exist", :server => @local_server).delete! }
    failing.should raise_error Pincaster::NoSuchLayer
  end
end
