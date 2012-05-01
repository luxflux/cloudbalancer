module CloudBalancer
  class LoadBalancer

    autoload :FindNameMixin, 'cloud_balancer/load_balancer/find_name_mixin'
    autoload :Services, 'cloud_balancer/load_balancer/services'
    autoload :Service, 'cloud_balancer/load_balancer/service'
    autoload :ServiceNodes, 'cloud_balancer/load_balancer/service_nodes'
    autoload :ServiceNode, 'cloud_balancer/load_balancer/service_node'

    attr_reader :services, :topics, :logger
    attr_accessor :transport

    def initialize()
      @config = CloudBalancer::Config.load_balancer

      @services = Services.new
      @config.services.each do |service|
        @services << Service.new(service)
      end

      @logger = CloudBalancer::Logger.new.logger

      @topics = [
        :register,
        :status,
        :heartbeat
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

          when :heartbeat
            update_heartbeat(payload)

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

        unless my_service = @services.find_name(service)
          @logger.error "I cannot add a node to service '#{service}' as I don't know this service"

        else
          unless my_service.nodes.find_name(node)
            my_service.nodes << ServiceNode.new(node)
            @logger.info "Node #{node} added to service #{service}"
          else
            @logger.error "Node is already registered (#{my_service.nodes.find_name(node)}"
          end
        end

      else
        @logger.error "Password was wrong (#{password}/#{@config.cluster_password})"
      end
    end

    def reply_status(to, id)
      @transport.reply(to, id, {services: @services})
    end

    def update_heartbeat(payload)
      payload[:services].each do |service|
        if my_service = @services.find_name(service.to_sym)
          if node = my_service.nodes.find_name(payload[:node])
            node.last_heartbeat = Time.now
            unless node.online?
              node.online = true
              @logger.info "Node #{payload[:node]} enabled for service #{my_service}"
            end
          else
            @logger.error "Node #{payload[:node]} is not registered for service #{my_service}"
          end
        else
          @logger.error "Service #{service} not found."
        end
      end
    end

    def heartbeat_check
      @services.each do |service|
        service.nodes.each do |node|
          if node.last_heartbeat.nil? or node.last_heartbeat < Time.now - 3.seconds
            unless node.offline?
              @logger.info "Heartbeat: Disabling node #{node.name} for service #{service}."
              node.online = false
            end
          end
        end
      end
    end

    def start_heartbeat_check
      EM::PeriodicTimer.new(0.5) do
        heartbeat_check
      end

    end

  end
end
