require 'spec_helper'

describe CloudBalancer::LoadBalancer::TCPServer do

  let(:backend) do
    OpenStruct.new(name: 'test1', port: 8080)
  end

  let(:algorithm) do
    OpenStruct.new(backends: nil, options: nil, get_backend: backend, options_for_next_run: nil)
  end

  let(:service) do
    OpenStruct.new(nodes: [], port: 80)
  end

  before(:all) do
    class TestTCPServer
      include CloudBalancer::LoadBalancer::TCPServer
      attr_reader :backend
    end
  end

  before(:each) do
    @tcp_server = TestTCPServer.new
  end

  describe "#post_init" do
    before do
      EM.expects(:connect).
        with('test1', 8080, CloudBalancer::LoadBalancer::TCPClient, instance_of(TestTCPServer)).
        returns(OpenStruct.new(close_connection_after_writing: true))
      @tcp_server.post_init(service, algorithm)
    end

    subject do
      @tcp_server
    end

    its('backend.name') { should eq('test1') }
    its('backend.port') { should eq(8080) }

  end

end
