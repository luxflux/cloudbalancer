configatron.cluster_password = ""
configatron.services = [ :www ]
configatron.amqp.host = 'localhost'
configatron.daemon = :load_balancer
configatron.protocol = :AMQP

if File.exists?("config/config.local.rb")
  require "./config/config.local"
end

configatron.load_balancer.cluster_password = Configatron::Dynamic.new { configatron.cluster_password }
configatron.load_balancer.services = Configatron::Dynamic.new { configatron.services }
configatron.node.cluster_password = Configatron::Dynamic.new { configatron.cluster_password }
configatron.node.services = Configatron::Dynamic.new { configatron.services }
