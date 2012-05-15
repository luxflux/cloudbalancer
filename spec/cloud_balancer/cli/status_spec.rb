require 'spec_helper'

describe CloudBalancer::CLI::Status do

  before do
    CloudBalancer::Status.expects(:new)
    CloudBalancer::Transport::AMQP.expects(:new)
    runner = mock
    runner.stubs(:run).returns(true)
    CloudBalancer::Runner.expects(:new).returns(runner)
    @status = CloudBalancer::CLI::Status.new
  end

  it "returns an instance of itself" do
    @status.should be_instance_of(CloudBalancer::CLI::Status)
  end

  pending "dunno what to test here..."

end
