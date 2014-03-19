require 'optparse'

module SwitchManager
  # This class handles command line options.
  class Options
    DEFAULT_TCP_PORT = 6653

    def initialize
      @options = {}
      @options[:port] = DEFAULT_TCP_PORT
      @options[:rule] = {}
    end

    def parse(args)
      OptionParser.new do |parser|
        parser.banner = 'Usage: switch_manager [options]'

        add_server_options(parser)
        add_logging_options(parser)
        add_forwarding_options(parser)

        parser.on_tail('-h', '--help', 'Show this message') do
          puts parser
          exit
        end
        parser.on_tail('--version', 'Show version') do
          puts SwitchManager::VERSION
          exit
        end

        parser.parse!(args)
      end
      @options
    end

    private

    def add_server_options(parser)
      parser.on('-p', '--port NUMBER',
                "Listen port (default: #{DEFAULT_TCP_PORT})") do |v|
        @options[:port] = v
      end
      parser.on('-s', '--socket STRING',
                'Secure channel socket path') do |v|
        fail 'TODO'
      end
    end

    def add_logging_options(parser)
      parser.on('-l', '--logging_level STRING',
                'Set logging level') do |v|
        fail 'TODO'
      end
      parser.on('-g', '--syslog',
                'Outputs log messages to syslog') do |v|
        fail 'TODO'
      end
      parser.on('-f', '--syslog_facility STRING',
                'Set syslog facility') do |v|
        fail 'TODO'
      end
    end

    def add_forwarding_options(parser)
      parser.on('--port_status STRING',
                'Forwards port status messages to the specified application') do |v|
        @options[:rule][:port_status] = v
      end
      parser.on('--packet_in STRING',
                'Forwards PacketIn messages to the specified application') do |v|
        @options[:rule][:packet_in] = v
      end
      parser.on('--state_notify STRING',
                'Forwards state notify messages to the specified application') do |v|
        @options[:rule][:state_notify] = v
      end
      parser.on('--vendor STRING',
                'Forwards vendor messages to the specified application') do |v|
        @options[:rule][:vendor] = v
      end
    end
  end
end
