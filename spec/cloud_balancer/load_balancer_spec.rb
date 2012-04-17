require 'spec_helper'

describe CloudBalancer::LoadBalancer do

  context "Communication to the nodes" do

    it "connects to a message queue server on start" do
      pending "Dunno how to test this, yet"
    end

    context "registration" do

      subject do
        CloudBalancer::LoadBalancer.new
      end

      let(:metadata) do
        { topic: "register" }
      end

      let(:register_payload) do
        { password: "testpass", services: [ "www", "smtp" ] }
      end

      it "adds the node to the setup" do
        expect { subject.handle_message(metadata, register_payload) }.to change { subject.services[:www][:nodes].length }.from(0).to(1)
      end

    end

    context "status" do

      subject do
        CloudBalancer::LoadBalancer.new
      end

      let(:metadata) do
        { topic: "status", reply_to: "uuid-queue", message_id: Kernel.rand(10101010).to_s, immediate: true }
      end

      it "replies with the current services/servers to a status question" do
        subject.transport.expects(:publish).with(:reply, {services: subject.services}, {reply_to: "uuid-queue"}).returns(true)
        subject.handle_message(metadata, {}).should be_true
      end

    end

  end

end
