
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
CloudBalancer::Config.server.services = [ :www ]
CloudBalancer::Config.amqp.host = "localhost"
CloudBalancer::Config.daemon = :load_balancer
CloudBalancer::Config.protocol = :AMQP

