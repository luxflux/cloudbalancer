configatron.cluster_password = ""
configatron.server.services = [ ]
configatron.amqp.host = 'localhost'
configatron.daemon = :server
configatron.protocol = :AMQP

if File.exists?("config/config.local.rb")
  require "./config/config.local"
end

configatron.server.cluster_password = Configatron::Dynamic.new {configatron.cluster_password}
