module Helpers
  def mock_amqp_connect
    queue = mock
    queue.stubs(:name).returns("generatedstring-123")
    queue.stubs(:subscribe).returns(true)

    channel = mock
    channel.stubs(:queue).with("", :exclusive => true).returns(queue)

    ::AMQP.stubs(:connect).returns(true)
    ::AMQP::Channel.stubs(:new).returns(channel)
  end
end
