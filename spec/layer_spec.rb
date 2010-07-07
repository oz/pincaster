require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pincaster::Layer" do
  it "should instanciate cleanly" do
    Pincaster::Layer.new.should be_a Pincaster::Layer
  end

  it "should register a new layer" do
    layer = Pincaster::Layer.new :name => 'a_new_layer'
    layer.register.should be_true

    layer2 = Pincaster::Layer.register :name => 'a_new_layer'
    layer2.should be_a Pincaster::Layer
  end

  it "should delete a layer" do
    Pincaster::Server.new.layers.first.delete.should be_true
  end

  it "should raise an exception when trying to delete non-existent layers" do
    lambda { Pincaster::Layer.new(:name => "i_dont_exist").delete! }.should raise_error(Pincaster::NoSuchLayer)
  end
end
