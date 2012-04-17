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
        start_queue
        start_exchange
        start_listen_on_topics
      end

      def publish(topic, data)
        routing_key = get_routing_key_for_topic(topic)
        @exchange.publish(data.to_json, { type: topic.to_s, routing_key: routing_key })
      end

      def handle_message(metadata, payload)
        payload = JSON.parse(payload, :symbolize_names => true)
        metadata = {
          topic: metadata.type
        }
        @consumer.logger.debug "Got message (#{metadata.inspect} / #{payload.inspect})"
        @consumer.handle_message(metadata, payload)
      end

      protected

      def get_routing_key_for_topic(topic)
        "cloud_balancer.#{topic}"
      end

      def start_queue
        @queue = @channel.queue("", :exclusive => true)
        @queue_name = @queue.name
      end

      def start_exchange
        @exchange = @channel.topic("pub/sub", :auto_delete => true)
      end

      def start_listen_on_topics
        if @consumer.respond_to?(:topics)
          @consumer.topics.each do |topic|
            t = get_routing_key_for_topic(topic)
            @queue.bind(@exchange, :routing_key => t).subscribe(&self.method(:handle_message))
            @consumer.logger.info "Started listening on #{topic} (routing_key: #{t})"
          end
        end
      end

    end
  end
end
