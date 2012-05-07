require 'spec_helper'

describe CloudBalancer::Transport::AMQP do

  let(:logger) do
    l = mock()
    l.stubs(:error)
    l.stubs(:info)
    l
  end

  let(:consumer) do
    OpenStruct.new(logger: logger)
  end

  context "as server" do
    before do
      mock_amqp_connect
    end

    subject do
      amqp = CloudBalancer::Transport::AMQP.new
      amqp.consumer = consumer
      amqp.start
      amqp
    end

    its(:queue_name) { should be_instance_of(String) }
    its(:queue_name) { should_not be_empty }

  end

end
