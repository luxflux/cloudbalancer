require 'socket'

module CloudBalancer
  module Transport
    class AMQP

      attr_reader :queue_name, :channel, :consumer
      attr_writer :consumer

      def initialize
        connection = ::AMQP.connect(:host => CloudBalancer::Config.amqp.host)

        @channel = ::AMQP::Channel.new(connection)
        @queue_name = Socket.gethostname
      end

      def start
        start_queue
        start_exchange
      end

      def publish(topic, data = {}, headers = {})
        routing_key = get_routing_key_for_topic(topic)
        headers.merge!(type: topic.to_s, routing_key: routing_key)
        @exchange.publish(data.to_json, headers)
        return true
      rescue => e
        @consumer.logger.error "Publish failed: #{e}"
        return false
      end

      def question(topic)
        publish(topic, {}, {message_id: Kernel.rand(10101010).to_s, reply_to: @queue_name})
      end

      def reply(to, id, data)
        puts to
        puts id
        puts data.to_json
        @channel.default_exchange.publish(data.to_json,
                                          routing_key: to,
                                          correlation_id: id,
                                          immediate: true,
                                          mandatory: true)
        return true
      rescue => e
        @consumer.logger.error "Reply failed: #{e}"
        return false
      end

      def handle_message(metadata, payload)
        payload = JSON.parse(payload, :symbolize_names => true)
        metadata = {
          topic: metadata.type,
          reply_to: metadata.reply_to,
          message_id: metadata.message_id
        }
        @consumer.logger.debug "Got message (#{metadata.inspect} / #{payload.inspect})"
        @consumer.handle_message(metadata, payload)
      end

      protected

      def get_routing_key_for_topic(topic)
        "cloud_balancer.#{topic}"
      end

      def start_queue
        @queue = @channel.queue(@queue_name, :exclusive => true, :auto_delete => true) do |queue|
          queue.subscribe(&self.method(:handle_message))
          start_listen_on_topics(queue)
        end
      end

      def start_exchange
        @exchange = @channel.topic("pub/sub", :auto_delete => true)
      end

      def start_listen_on_topics(queue)
        if @consumer.respond_to?(:topics)
          @consumer.topics.each do |topic|
            t = get_routing_key_for_topic(topic)
            queue.bind(@exchange, :routing_key => t)
            @consumer.logger.info "Started listening on #{topic} (routing_key: #{t})"
          end
        end
      end

    end
  end
end
