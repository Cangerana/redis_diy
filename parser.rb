class Parser
  attr_accessor :message
  def initialize(message)
    self.message = message
  end

  def decode
    raise 'Message isn\'t a array' unless is_array?
    bulk_strings = get_bulk_from_array message
    # split the elements of array
    # parse the element in commands
  end

  def get_bulk_from_array(msg)
    raise 'Message don\'t have bulks' unless is_bulk?
    cmds = []

    amnt_bytes = msg.scan(/\$([0-9]+)/).flatten.map &:to_i

    amnt_bytes.each do |amnt|
      msg = msg.match(/\$[0-9]+\\r\\n/).post_match
      cmds << msg[0..amnt-1]
      msg.delete_prefix cmds.last
    end

    cmds
  end

  def encode
  end

  def get_string(str=nil)
    str ||= message
    strings = ->(msg) { msg.match(rgx[:str]).map { |m| m.slice(1..-5) } }

    msg = msg.first if is_string(str)
  end

  def is_string?(str=nil)
    str ||= message
    !str.match(/\+.*\\r\\n/).nil?
  end

  def is_bulk?(str=nil)
    str ||= message
    !str.match(/\$[0-9]+\\r\\n.*\\r\\n/).nil?
  end

  def is_array?(str=nil)
    str ||= message
    !str.match(/\*[0-9]+\\r\\n.*/).nil?
  end
end

# testes
msg_string = '+PONG\r\n'
msg_bulk = '$30\r\nTHIS CONTAINS A \r\n INSIDE IT\r\n'
msg_array = '*2\r\n$3\r\nhey\r\n$5\r\nthere\r\n'

msg_parsed = Parser.new(msg_array)
puts msg_parsed.decode
# puts msg_parsed.is_string?
# puts msg_parsed.is_array?
# puts msg_parsed.is_bulk?

