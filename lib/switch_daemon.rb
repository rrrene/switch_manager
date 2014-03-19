# Switch Daemon wrapper.
class SwitchDaemon
  def initialize(ip_address, port, fileno, rule)
    @ip_address = ip_address
    @port = port
    @fileno = fileno
    @rule = rule
  end

  def spawn(switch_fd)
    trema_home = File.dirname(File.realpath(__FILE__)) + '/../..'
    pid = Kernel.spawn({ 'TREMA_HOME' => trema_home },
                       [executable, process_name],
                       *options,
                       switch_fd => switch_fd)
    ::Process.detach(pid)
  end

  private

  def executable
    File.dirname(File.realpath(__FILE__)) +
      '/../../objects/switch_manager/switch'
  end

  def options
    [
      "--name=#{process_name}",
      "--socket=#{@fileno}",
      '--daemonize',
      "vendor::#{@rule[:vendor]}",
      "packet_in::#{@rule[:packet_in]}",
      "port_status::#{@rule[:port_status]}",
      "state_notify::#{@rule[:vendor]}"
    ]
  end

  def process_name
    "switch.#{@ip_address}:#{@port}"
  end
end
