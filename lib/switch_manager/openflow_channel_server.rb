require 'socket'
require 'switch_daemon'

module SwitchManager
  class OpenflowChannelServer
    attr_reader :socket

    def initialize
      Thread.abort_on_exception = true
    end

    def open(port)
      @socket = TCPServer.open('<any>', port)
    end

    def start(rule)
      Thread.start(@socket.accept) do |client|
        sin_port, sin_addr = Socket.unpack_sockaddr_in(client.getpeername)
        SwitchDaemon.new(sin_addr, sin_port, client.fileno, rule).spawn(client)
        client.close
      end
    end
  end
end
