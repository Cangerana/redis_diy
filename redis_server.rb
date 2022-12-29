require 'socket'
require 'pry'
# binding.pry

class RedisServer
  def initialize(port=5000)
    @server = TCPServer.new(port)

    string_start = '+' 
    string_end = '\r\n'
    bulk_start = '$'
    array_start = '*'
  end

  def start
    listen
  end

  private

  def listen
    loop do
      puts 'Waiting for connections'

      connection = @server.accept
      puts 'Connection established'
      comunication connection
    end
  end

  def comunication(connection)
    while connection.sync
      msg = recivemsg(connection)
      puts "requnest: #{msg}"
      reply = parse(msg)

      puts "response: #{reply}"
      connection.sendmsg reply
    end

      puts 'Connection fineshed'
  end

  def recivemsg(connection)
    connection.recvmsg
  end
end

redis_server = RedisServer.new
redis_server.start

# todo
# Simple Strings (starting with +)
# Bulk Strings (starting with $)
# Arrays (starting with *)


