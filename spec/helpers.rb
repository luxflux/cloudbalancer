module Helpers
  def mock_amqp_connect
    exchange = mock

    queue = mock
    queue.stubs(:name).returns("generatedstring-123")
    queue.stubs(:subscribe).returns(true)
    queue.stubs(:bind).with(exchange, instance_of(Hash)).returns(queue)

    channel = mock
    channel.stubs(:topic).with('pub/sub', {:auto_delete => true}).returns(exchange)
    channel.stubs(:queue).with("", :exclusive => true).returns(queue)

    ::AMQP.stubs(:connect).returns(true)
    ::AMQP::Channel.stubs(:new).returns(channel)
  end
end
