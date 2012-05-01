module CloudBalancer
  class LoadBalancer

    attr_reader :services, :topics, :logger
    attr_accessor :transport

    def initialize()
      @config = CloudBalancer::Config.load_balancer

      @services = {}
      @config.services.each do |service|
        @services[service] = { :nodes => [] }
      end

      @logger = CloudBalancer::Logger.new.logger

      @topics = [
        :register,
        :status
      ]

    end

    # Starts the Loadbalancing
    def start
      start_heartbeat_check
    end

    # Starting point for a new message
    #
    # @param [OpenStruct] metadata The metadata of this message
    # @param [String] payload The message content
    #
    def handle_message(metadata, payload)

      puts metadata.inspect
      begin
        if metadata[:topic]

          case metadata[:topic].to_sym
          when :register
            payload[:services].each do |service|
              register_node(service, payload[:node], payload[:password])
            end
          when :status
            reply_status(metadata[:reply_to], metadata[:message_id])
          else
            @logger.error "I don't know how to handle message of type #{metadata[:topic]} (Content: #{payload})."
            false
          end

        else
          @logger.error "I don't know how to handle this message (#{payload}), no message type specified."
          false
        end
      rescue => e
        @logger.fatal e
        false
      end
    end


    private

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

        unless @services.has_key?(service)
          @logger.error "I cannot add a node to service '#{service}' as I don't know this service" unless @services.has_key?(service)

        else
          unless @services[service][:nodes].find { |registered_node| registered_node[:name] == node }
            @services[service][:nodes] << { name: node, weight: 0, last_heartbeat: Time.now }
            @logger.info "Node #{node} added to service #{service}"
          else
            @logger.error "Node is already registered"
          end
        end

      else
        @logger.error "Password was wrong (#{password}/#{@config.cluster_password})"
      end
    end

    def reply_status(to, id)
      @transport.reply(to, id, {services: @services})
    end

    def start_heartbeat_check
      EM::PeriodicTimer.new(0.5) do
        @services.each do |service,value|
          puts "checking service #{service}"
          puts value.inspect
          value[:nodes].delete_if do |node|
            puts "checking heartbeat of #{node}"
            node[:last_heartbeat].nil? or node[:last_heartbeat] < Time.now - 3.seconds
          end
        end
      end
    end

  end
end
