require 'spec_helper'

describe CloudBalancer::Runner do

  it "should instantiate a worker of the defined protocol" do
    CloudBalancer::Config.daemon = :server
    CloudBalancer::Config.protocol = :AMQP
    runner = CloudBalancer::Runner.new
    runner.run!
    runner.worker.should be_instance_of(CloudBalancer::Transport::AMQP)
  end

end
