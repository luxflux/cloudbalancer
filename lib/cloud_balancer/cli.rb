module CloudBalancer

  class CLI < Thor

    autoload :Status, 'cloud_balancer/cli/status'

    desc 'status', 'Shows the status about the running CloudBalancer'
    def status
      status = Status.new
      status.run
    end

    def help(*args)
      super
      EM.stop
    end

  end

end
