=======
Oatmeal
=======

Oatmeal, "Just enough Iron in your Serial," is a Ruby library that
provides a minimal wrapper around the .NET System.IO.Ports API for
IronRuby_.  It mimics the ``read`` and ``write`` methods from its more
full-featured cousin, the serialport_ Ruby library.

Prerequisites
-------------
1. IronRuby.
2. Mono or .NET.

Installation
------------

``igem install oatmeal``, or just put ``serialport.rb`` somewhere
in your ``LOAD_PATH``.

Usage
-----

Sample code::

  require 'serialport'

  port = SerialPort.new '/dev/ttyUSB0', 9600, 8, 1, SerialPort::NONE
  port.read_timeout = 1000

  begin
    port.write 'something'
    puts port.read
  ensure
    port.close
  end

.. _IronRuby: http://ironruby.net
.. _serialport: http://rubygems.org/gems/serialport
