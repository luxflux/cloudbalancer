require 'spec_helper'

describe CloudBalancer::LoadBalancer::Algorithms::WRR do

  let(:backends) do
    nodes = CloudBalancer::LoadBalancer::ServiceNodes.new
    nodes << OpenStruct.new(name: :test1, weight: 3)
    nodes << OpenStruct.new(name: :test2, weight: 4)
    nodes << OpenStruct.new(name: :test3, weight: 2)
    nodes
  end

  before do
    @algorithm = CloudBalancer::LoadBalancer::Algorithms::WRR.new
    @algorithm.backends = backends
  end

  describe "first run" do
    before do
      @algorithm.options = {}
    end

    subject do
      @algorithm.get_backend
    end

    its('name') { should eq(:test2) }
    its('weight') { should eq(4) }
  end

  describe "3rd run" do
    before do
      @algorithm.options = OpenStruct.new(current_weight: 4, backend: 1)
    end

    subject do
      @algorithm.get_backend
    end

    its('name') { should eq(:test1) }
    its('weight') { should eq(3) }
  end

  describe "1000 runs" do
    before do
      @backends = {}
      options = nil
      900.times do
        @algorithm = CloudBalancer::LoadBalancer::Algorithms::WRR.new
        @algorithm.backends = backends
        @algorithm.options = options
        backend = @algorithm.get_backend
        @backends[backend.name] ||= 0
        @backends[backend.name] += 1
        options = @algorithm.options_for_next_run
      end
    end

    it "returns test1 300 times" do
      @backends[:test1].should eq(300)
    end

    it "returns test2 400 times" do
      @backends[:test2].should eq(400)
    end

    it "returns test3 200 times" do
      @backends[:test3].should eq(200)
    end

  end

end
