module CloudBalancer

  autoload :LoadBalancer, 'cloud_balancer/load_balancer'
  autoload :Config, 'cloud_balancer/config'
  autoload :Transport, 'cloud_balancer/transport'
  autoload :Runner, 'cloud_balancer/runner'
  autoload :Node, 'cloud_balancer/node'

  autoload :Logger, 'cloud_balancer/logger'
  autoload :Status, 'cloud_balancer/status'

end
