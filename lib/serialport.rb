class SerialPort
  NONE = 0
  EVEN = 1
  ODD  = 2

  IoPorts      = System::IO::Ports
  IoSerialPort = IoPorts::SerialPort

  attr_accessor :wait_after_send

  def initialize(name, baud, data, stop, parity)
    @wait_after_send = nil

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

    @port = IoSerialPort.new name, baud, parity, data, stop
    @port.open
  end

  def close
    @port.close
  end

  def putc(c)
    @port.write(c)
    sleep(@wait_after_send / 1000.0) if @wait_after_send
  end

  def getc
    @port.read_byte.chr
  end

  def write(s)
    @port.write(s)
    sleep(@wait_after_send / 1000.0) if @wait_after_send
  end

  def read
    @port.read_existing
  end

  def read_timeout=(ms)
    @port.read_timeout = ms
  end
end

