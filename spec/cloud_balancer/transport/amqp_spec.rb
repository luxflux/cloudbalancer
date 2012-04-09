require 'spec_helper'

describe CloudBalancer::Transport::AMQP do

  #include EventedSpec::EMSpec

  context "as server" do
    before do
      mock_amqp_connect
    end

    subject do
      amqp = CloudBalancer::Transport::AMQP.new
      amqp.start
      amqp
    end

    its(:queue_name) { should be_instance_of(String) }
    its(:queue_name) { should_not be_empty }

    its(:consumer) { should be_instance_of(CloudBalancer::Server) }

  end

end
