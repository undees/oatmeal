require 'forwardable'

class SerialPort
  extend ::Forwardable

  NONE = 0
  EVEN = 1
  ODD  = 2

  HARD = 1
  SOFT = 2

  IoPorts      = System::IO::Ports
  IoSerialPort = IoPorts::SerialPort

  attr_accessor :wait_after_send

  def initialize(name, options = {})
    @wait_after_send = nil

    baud = options['baud'] || 9600
    data = options['data_bits'] || 8
    stop = options['stop_bits'] || 1
    parity = options['parity'] || NONE
    
    io_parity = case parity
    when NONE then IoPorts::Parity.None
    when EVEN then IoPorts::Parity.Even
    when ODD  then IoPorts::Parity.Odd
    end

    io_stop = case stop
    when 0   then IoPorts::StopBits.None
    when 1   then IoPorts::StopBits.One
    when 1.5 then IoPorts::StopBits.OnePointFive
    when 2   then IoPorts::StopBits.Two
    end

    @port = IoSerialPort.new name, baud, io_parity, data, io_stop
    @port.open
  end

  def flow_control=(control)
    case control
    when NONE
      @port.handshake = IoPorts::Handshake.None
    when HARD
      @port.handshake = IoPorts::Handshake.RequestToSend
    when SOFT
      @port.handshake = IoPorts::Handshake.XOnXOff
    when HARD|SOFT
      @port.handshake = IoPorts::Handshake.RequestToSendXOnXOff
    else
      raise "Invalid flow control"
    end
  end

  def flow_control
    case @port.flow_control
    when IoPorts::Handshake.None
      NONE
    when IoPorts::Handshake.RequestToSend
      HARD
    when IoPorts::Handshake.XOnXOff
      SOFT
    when IoPorts::Handshake.RequestToSendXOnXOff
      HARD|SOFT
    end
  end

  # Gets the number of milliseconds before a time-out occurs when a write operation does not finish.
  def_delegator :@port, :write_timeout

  # Sets the number of milliseconds before a time-out occurs when a write operation does not finish.
  def_delegator :@port, :write_timeout=

  # Sets the number of milliseconds before a time-out occurs when a read operation does not finish.
  def_delegator :@port, :read_timeout

  # Gets the number of milliseconds before a time-out occurs when a read operation does not finish.
  def_delegator :@port, :read_timeout=

  # Closes the port connection and disposes of the internal Stream object.
  def_delegator :@port, :close

  # Gets the open or closed status of the SerialPort object.
  def closed?
    !@port.is_open
  end

  # Writes one character to the serial port.
  def putc(c)
    @port.write(c)
    sleep(@wait_after_send / 1000.0) if @wait_after_send
  end

  # Synchronously reads one byte.
  def getc
    @port.read_byte.chr
  end

  # Writes the specified string to the serial port.
  def write(s)
    @port.write(s)
    sleep(@wait_after_send / 1000.0) if @wait_after_send
  end

  # Reads all immediately available bytes, based on the encoding, in both the stream and the input buffer of the SerialPort object.
  def_delegator :@port, :read_existing, :read

  # Reads up to the line separator value in the input buffer.
  def readline(sep="\n")
    @port.new_line = sep
    @port.read_line
  end
end
