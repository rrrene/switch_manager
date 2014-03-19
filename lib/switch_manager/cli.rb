require 'logger'
require 'switch_manager/list_switches_reply'
require 'switch_manager/messenger_server'
require 'switch_manager/openflow_channel_server'
require 'switch_manager/options'

module SwitchManager
  # The CLI is a class responsible of handling all the command line
  # interface logic.
  class CLI
    def initialize
      @openflow_channel_server = OpenflowChannelServer.new
      @messenger_server = MessengerServer.new
    end

    def run
      parse_options
      start_logging
      daemonize
      write_pid
      create_openflow_channel_server
      create_messenger_server
      main_loop
    rescue => e
      @logger.error "While starting a switch manager, unpexected #{e.class}: #{e}" if @logger
    ensure
      @messenger_server.close
    end

    private

    def parse_options(args = ARGV)
      @options = Options.new.parse(args)
    end

    def daemonize
      if RUBY_VERSION < '1.9'
        exit if fork
        ::Process.setsid
        exit if fork
        Dir.chdir '/'
        STDIN.reopen '/dev/null'
        STDOUT.reopen '/dev/null'
        STDERR.reopen '/dev/null'
      else
        ::Process.daemon
      end
    end

    def write_pid
      File.open(pid_file, File::CREAT | File::EXCL | File::WRONLY) do |file|
        file.write ::Process.pid
      end
      at_exit { File.delete(pid_file) if File.exist?(pid_file) }
    rescue Errno::EEXIST
      check_pid!
      retry
    end

    def pid_file
      File.dirname(File.realpath(__FILE__)) + '/../../tmp/pid/switch_manager.pid'
    end

    def check_pid!
      case pid_file_process_status
      when :running, :not_owned
        @logger.error 'A switch manager is already running.'
        exit 1
      when :dead
        File.delete pid_file
      end
    end

    def pid_file_process_status
      return :exited unless File.exist?(pid_file)

      pid = File.read(pid_file).to_i
      return :dead if pid == 0

      ::Process.kill(0, pid)
      :running
    rescue Errno::ESRCH
      :dead
    rescue Errno::EPERM
      :not_owned
    end

    def start_logging
      @logger = Logger.new(log_file)
      @logger.info 'Switch Manager started.'
    end

    def log_file
      File.dirname(File.realpath(__FILE__)) + '/../../tmp/log/switch_manager.log'
    end

    def create_openflow_channel_server
      @openflow_channel_server.open(@options[:port])
      @logger.info "Successfully started listening on port #{@options[:port]}."
    end

    def create_messenger_server
      @messenger_server.open
      @logger.info "Successfully started listening on socket #{@messenger_server.socket_file}."
    end

    def main_loop
      loop do
        rs, = IO.select([@openflow_channel_server.socket, @messenger_server.socket])
        if rs[0] == @openflow_channel_server.socket
          @openflow_channel_server.start(@options[:rule])
        else
          @messenger_server.start
        end
      end
    end
  end
end
