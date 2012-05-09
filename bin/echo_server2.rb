 require 'eventmachine'

 module EchoServer
   def post_init
     puts "-- someone connected to the echo server!"
   end

   def receive_data data
     send_data ">>>you sent: #{data}"
     close_connection if data =~ /quit/i
   end

   def unbind
     puts "-- someone disconnected from the echo server!"
  end
end

# Note that this will block current thread.
EventMachine.run {
  EventMachine.start_server "0.0.0.0", 3001, EchoServer
}
