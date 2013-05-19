# CloudBalancer

[![Build Status](https://secure.travis-ci.org/luxflux/cloudbalancer.png?branch=master)](http://travis-ci.org/luxflux/cloudbalancer)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/luxflux/cloudbalancer)

Ever wanted the servers behind your loadbalancer to register themself with
the it? Ever wished your loadbalancer would react on high load or other
events on the backend servers?

This project will solve your problems (as soon as its finished, haha...).

## Concept
  - A new node registers itself at its loadbalancers
  - Loadbalancer gets in a defined period of time announcements from
    the nodes about their current status
  - Loadbalancer weights the nodes according to their status
  - It will be easy to write your own node-plugin (want to check
    Seconds_behind_master on a MySQL-Slave?)
  - In the first version, there will be just generic TCP-relaying, soon
    after that there will be HTTP-Proxying
  - Primarily based on AMQP/RabbitMQ

## Whats already implemented?
  - Node check-in at the loadbalancer
  - Monitoring the heartbeat of a node
  - Simple TCP-Weighted-Round-Robin Loadbalancer
  - Hacky start scripts for each
  - Status-CLI which outputs some JSON :)

## Open parts for the first RC
  - Nice start scripts
  - Nice CLI
  - Plugin infrastructure for the weighting
  - Live rebalancing when the weight of a node changes

## Planned features
  - Everything is a plugin
    - Want to use STOMP instead of AMQP?
    - Easily write your own checks on a node
  - Webinterface
  - HTTP-Proxying (including Varnish-Cache?)
  - SMTP-Proxying


## Giving the current version a try

  * Install & start RabbitMQ
  * Start the loadbalancer:
```shell
ruby bin/cloudbalancer-loadbalancer
```

  * Start the echo servers:
```shell
ruby bin/echo-server.rb
ruby bin/echo-server2.rb
```

  * Start the nodes
```shell
ruby bin/cloudbalancer-node
ruby bin/cloudbalancer-node2
```
  
  * Connect to localhost:8080 with netcat
```shell
nc localhost 8080
```
