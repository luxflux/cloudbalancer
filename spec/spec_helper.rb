
require 'rubygems'
require 'bundler'

Bundler.require

$: << 'lib'

require './config/config'

require 'cloud_balancer'
require 'ostruct'

# override the configuration
CloudBalancer::Config.cluster_password = "testpass"
CloudBalancer::Config.server.services = [ :www ]
