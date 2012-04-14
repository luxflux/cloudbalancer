#!/usr/bin/env ruby
#
# ruby implementation of
#   http://kb.linuxvirtualserver.org/wiki/Weighted_Round-Robin_Scheduling


given_servers = {
  A: 4,
  B: 3,
  C: 2
}

servers = []
servers_weights = []

given_servers.each do |name,weight|
  servers << name
  servers_weights << weight
end

class Array
  def gcd
    me = self.dup
    my_gcd = nil
    val = me.shift
    me.each do |i|
      current_gcd = val.gcd(i)
      my_gcd = current_gcd if my_gcd.nil? or current_gcd < my_gcd
    end
    my_gcd
  end
end

i = -1
cw = 0

hits = {}

(12*1000).times do

  i = (i + 1) % servers_weights.length

  if i == 0
    cw = cw - servers_weights.gcd
    if cw <= 0
      cw = servers_weights.max
      if cw == 0
        puts "ERROR"
        next
      end
    end
  end

  if servers_weights[i] >= cw
    s = servers[i]
    hits[s] ||= 0
    hits[s] += 1
    print s
  end

end
puts ""

puts hits.inspect
