# CloudBalancer

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

## Planned features
  - Everything is a plugin
    - Want to use STOMP instead of AMQP?
    - Easily write your own checks on a node
  - Webinterface
  - HTTP-Proxying (including Varnish-Cache?)
  - SMTP-Proxying
