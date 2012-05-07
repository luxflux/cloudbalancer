require 'spec_helper'

describe CloudBalancer::Runner do

  before do
    mock_amqp_connect

    daemon = mock()
    daemon.expects(:transport=)
    daemon.expects(:start)

    transport = mock()
    transport.expects(:daemon=)
    transport.expects(:start)

    @runner = CloudBalancer::Runner.new(daemon, transport)
  end

  it "assigns the daemon and the transport" do
    @runner.run.should be_true
  end

end
