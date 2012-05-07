require 'spec_helper'

describe CloudBalancer::Node do

  before do
    EM::PeriodicTimer.expects(:new).with(1).returns(true)
    @node = CloudBalancer::Node.new
  end

  it "registers with the loadbalancer" do
    @node.transport.expects(:publish).with(:register, instance_of(Hash)).returns(true)
    @node.start.should be_true
  end

end
