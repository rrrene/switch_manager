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
        add_help_and_version_options(parser)

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
      parser.on('-l', '--logging_level STRING', 'Set logging level') do |v|
        fail 'TODO'
      end
      parser.on('-g', '--syslog', 'Outputs log messages to syslog') do |v|
        fail 'TODO'
      end
      parser.on('-f', '--syslog_facility STRING', 'Set syslog facility') do |v|
        fail 'TODO'
      end
    end

    FORWARD_OPTIONS =
      {
       port_status: 'Forwards port status messages to the specified application',
       packet_in: 'Forwards PacketIn messages to the specified application',
       state_notify: 'Forwards state notify messages to the specified application',
       vendor: 'Forwards vendor messages to the specified application'
      }

    def add_forwarding_options(parser)
      FORWARD_OPTIONS.each_pair do |name, desc|
        parser.on("--#{name} APP", desc) do |v|
          @options[:rule][name] = v
        end
      end
    end

    def add_help_and_version_options(parser)
      parser.on_tail('-h', '--help', 'Show this message') do
        puts parser
        exit
      end
      parser.on_tail('--version', 'Show version') do
        puts SwitchManager::VERSION
        exit
      end
    end
  end
end
