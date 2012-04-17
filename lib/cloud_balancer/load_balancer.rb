module CloudBalancer
  class LoadBalancer

    class UnknownMessageType < RuntimeError; end
    class MessageTypeNotSpecified < RuntimeError; end
    class UnknownService < RuntimeError; end

    attr_reader :services

    def initialize()
      @config = CloudBalancer::Config.server

      @services = {}
      @config.services.each do |service|
        @services[service] = { :nodes => [] }
      end
    end

    # Starting point for a new message
    #
    # @param [OpenStruct] metadata The metadata of this message
    # @param [String] payload The message content
    #
    def handle_message(metadata, payload)
      message = parse_payload(metadata.content_type, payload)
      if metadata.type
        case metadata.type.to_sym
        when :register
          register_node(message[:service], message[:node], message[:password])
        else
          raise UnknownMessageType, "I don't know how to handle message of type #{metadata.type} (Content: #{message})."
        end
      else
        raise MessageTypeNotSpecified, "I don't know how to handle this message (#{message}), no message type specified."
      end
    end


    private

    # Parse the received payload
    #
    # @param [String] content_type The content type of payload
    # @param [String] payload The payload to parse
    #
    # @return [Hash] The parsed content of payload
    #
    def parse_payload(content_type, payload)
      JSON.parse(payload, :symbolize_names => true)
    end

    # Register a node to a service
    #
    # @param [Symbol,String] service The service where the node should be assigned
    # @param [String] node The node which should be assigned
    # @param [String] password The password to join this cluster
    #
    # @return [Boolean] The status whether it worked out
    #
    def register_node(service, node, password)
      service = service.to_sym
      if password == @config.cluster_password
        raise UnknownService, "I cannot add a node to service '#{service}' as I don't know this service" unless @services.has_key?(service)
        unless @services[service][:nodes].find { |registered_node| registered_node[:name] == node }
          @services[service][:nodes] << { :name => node, :weight => 0 }
        else
          # puts "Node is already registered"
        end
      else
        # puts "Password was wrong (#{password}/#{@config.cluster_password})"
      end
    end

  end
end
