configatron.cluster_password = ""
configatron.server.services = [ ]

if File.exists?("config/config.local.rb")
  require "config/config.local"
end

configatron.server.cluster_password = Configatron::Dynamic.new {configatron.cluster_password}
