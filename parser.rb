class Parser
  attr_accessor :message
  def initialize(message)
    self.message = message
  end

  def parse(msg)
    rgx = {
      str: /\+[a-zA-Z][a-zA-Z0-9]+\\r\\n/, 
      bulk: //, 
      arrs: //, 
    }

    calls = {
      ping: 'pong',
    }

    reply_strings = strings.(msg)
    reply = calls[reply_strings.first.to_sym] if reply_strings.size > 0

    if reply.class == String and reply.size > 1
      reply
    else
      'Unkown command'
    end
  end

  def decode
    # the the arry string
    bulk_strings = get_bulk_from_array
    # split the elements of array
    # parse the element in commands
  end

  def get_bulk_from_array
    raise 'Message isn\'t a comman' if is_array?

    amnt_elements = message.match(/[0-9]+i/).to_s.to_i
    array_str.gsub(/\$[0-9]+\\r\\n/, '')

    elements = []
    amnt_elements.times do
      amnt_bytes = array_str.match(/\$[0-9]+/).to_s.to_i 

      bulk = array_str.match(/\$[0-9]+\\r\\n.*\\r\\n/)
      elements << bulk
    end
  end

  def encode
  end

  def get_bulk(msg)
    amnt_bytes = msg.scan(/\$([0-9]+)/).flatten.map &:to_i
    msg = msg.gsub(/\$[0-9]+\\r\\n/, '')

    bulks = []
    index = 0
    amnt_bytes.each do |amnt|
      bulks << msg.slice index..index+amnt
      index += amnt + '\r\n'.size
    end

    el = []

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
puts msg_parsed.is_string?
puts msg_parsed.is_bulk?
puts msg_parsed.is_array?

