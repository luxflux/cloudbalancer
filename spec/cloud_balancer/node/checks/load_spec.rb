require 'spec_helper'

describe CloudBalancer::Node::Checks::Load do

  before do
    @load_check = CloudBalancer::Node::Checks::Load.new

  end

  it "returns load as float" do
    @load_check.run.system_load.should be_instance_of(Float)
  end

  it "returns weight as integer" do
    @load_check.run.weight.should be_instance_of(Fixnum)
  end

end
