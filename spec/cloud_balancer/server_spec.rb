require 'spec_helper'

describe CloudBalancer::Server do
  
  context "Communication to the nodes" do

    it "connects to a message queue server on start" do
      pending "Dunno how to test this, yet"
    end

    context "announcement" do

      subject do
        CloudBalancer::Server.new
      end

      let(:metadata) do
        o = OpenStruct.new

        o.content_type = "application/json"
        o.type = "register"
        o
      end

      let(:register_payload) do
        { "queue" => "testnode1", "password" => "testpass", "service" => "www" }.to_json
      end

      it "adds the node to the setup" do
        expect { subject.handle_message(metadata, register_payload) }.to change { subject.services[:www][:nodes].length }.from(0).to(1)
      end

    end

  end

end
