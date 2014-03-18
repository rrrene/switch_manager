Feature: switch_manager usage
  Scenario: switch_manager --help
    When I run `switch_manager --help`
    Then the output should contain:
      """
      Usage: switch_manager [options]
          -p, --port NUMBER                Listen port (default: 6653)
          -s, --socket STRING              Secure channel socket path
          -l, --logging_level STRING       Set logging level
          -g, --syslog                     Outputs log messages to syslog
          -f, --syslog_facility STRING     Set syslog facility
              --port_status STRING         Forwards port status messages to the specified application
              --packet_in STRING           Forwards PacketIn messages to the specified application
              --state_notify STRING        Forwards state notify messages to the specified application
              --vendor STRING              Forwards vendor messages to the specified application
          -h, --help                       Show this message
              --version                    Show version
      """
