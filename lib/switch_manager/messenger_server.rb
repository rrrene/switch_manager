require 'fileutils'
require 'socket'
require 'stringio'
require 'switch_manager/message'

module SwitchManager
  # Handles messenger messages.
  class MessengerServer
    attr_reader :socket

    def initialize
      @read_buffer = StringIO.new('')
      @known_datapath_id = []
      Thread.abort_on_exception = true
    end

    def open
      @socket = Socket.new(:UNIX, :SOCK_STREAM, 0)
      @socket.bind(Addrinfo.unix(socket_file))
      @socket.listen(Socket::SOMAXCONN)
    end

    def start
      Thread.start(@socket.accept) do |switchd, |
        loop { main(switchd) }
      end
    end

    def close
      @socket.close
      FileUtils.rm_f socket_file
    end

    def socket_file
      File.dirname(File.realpath(__FILE__)) +
        '/../../tmp/sock/trema.switch_manager.sock'
    end

    private

    def main(switchd)
      request = read(switchd)
      case request.message_type
      when MESSAGE_TYPE_NOTIFY
        add_dpid request.datapath_id
      when MESSAGE_TYPE_REQUEST
        send_list_switches_reply(request.transaction_id, request.service_name)
      else
        fail "Unkonown message type: #{request.message_type}"
      end
    end

    def read(switchd)
      if @read_buffer.eof?
        binary, = switchd.recvfrom(100_000)
        @read_buffer = StringIO.new(binary)
      end
      Message.read(@read_buffer)
    end

    def add_dpid(dpid)
      @known_datapath_id << dpid unless @known_datapath_id.include?(dpid)
    end

    def send_list_switches_reply(transaction_id, service_name)
      switchd = Socket.new(:UNIX, :SOCK_SEQPACKET, 0)
      reply = ListSwitchesReply.new(transaction_id: transaction_id,
                                    dpids: @known_datapath_id)
      reply.header.assign(message_type: MESSAGE_TYPE_REPLY,
                          tag: 0,
                          message_length: reply.num_bytes)
      switchd.connect(Addrinfo.unix(socket_file(service_name)))
      switchd.write(reply.to_binary_s)
    end
  end
end
