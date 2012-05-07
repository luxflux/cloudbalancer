
require 'rubygems'
require 'bundler'

Bundler.require

$: << 'lib'

require './config/config'

require 'cloud_balancer'
require 'ostruct'
require 'evented-spec'

require './spec/helpers'
RSpec.configure do |config|
  config.mock_with :mocha
  config.include Helpers
end

# override the configuration
CloudBalancer::Config.cluster_password = "testpass"
CloudBalancer::Config.load_balancer.services = [ { name: 'www', ip: "0.0.0.0", port: "8080", node_port: 3000 }  ]
CloudBalancer::Config.amqp.host = "localhost"

