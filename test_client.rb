require 'socket'

host = '192.168.0.100'
port = 4567
@server = TCPSocket.open host, port
while true do
   print @server.gets.chomp
end