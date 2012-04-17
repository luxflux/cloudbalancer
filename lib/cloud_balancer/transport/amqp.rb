module CloudBalancer
  module Transport
    class AMQP

      attr_reader :queue_name, :channel, :consumer
      attr_writer :consumer

      def initialize
        connection = ::AMQP.connect(:host => CloudBalancer::Config.amqp.host)

        @channel = ::AMQP::Channel.new(connection)
      end

      def start
        @queue = @channel.queue("", :exclusive => true)
        @queue_name = @queue.name
        @queue.subscribe(&@consumer.method(:handle_message))
      end

    end
  end
end
