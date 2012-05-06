#!/usr/bin/env ruby
#
# ruby implementation of
#   http://kb.linuxvirtualserver.org/wiki/Weighted_Round-Robin_Scheduling



class ServersArray < Array

  def weights
    self.map { |server| server[:weight] }
  end

  def gcd
    my_weights = weights
    my_gcd = nil
    val = my_weights.shift
    my_weights.each do |i|
      current_gcd = val.gcd(i)
      my_gcd = current_gcd if my_gcd.nil? or current_gcd < my_gcd
    end
    my_gcd
  end

  def max
    weights.max
  end
end

given_servers = ServersArray.new
given_servers << {name: 'A', weight: 4}
given_servers << {name: 'B', weight: 3}
given_servers << {name: 'C', weight: 2}

i = -1
cw = 0

hits = {}

(12*1000).times do

  i = (i + 1) % given_servers.length

  if i == 0
    cw = cw - given_servers.gcd
    if cw <= 0
      cw = given_servers.max
      if cw == 0
        puts "ERROR"
        next
      end
    end
  end

  if given_servers[i][:weight] >= cw
    s = given_servers[i]
    hits[s[:name]] ||= 0
    hits[s[:name]] += 1
    print s
  end

end
puts ""

puts hits.inspect
