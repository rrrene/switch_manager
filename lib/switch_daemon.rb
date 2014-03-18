require 'pathname'

class SwitchDaemon
  def initialize(ip_address, port, fileno, rule)
    @ip_address = ip_address
    @port = port
    @fileno = fileno
    @rule = rule
  end

  def spawn(switch_fd)
    pid = Kernel.spawn({ 'TREMA_HOME' => Pathname(__dir__).join('..', '..').to_s },
                       [executable, process_name],
                       "--name=#{process_name}",
                       "--socket=#{@fileno}",
                       '--daemonize',
                       "vendor::#{@rule[:vendor]}",
                       "packet_in::#{@rule[:packet_in]}",
                       "port_status::#{@rule[:port_status]}",
                       "state_notify::#{@rule[:vendor]}",
                       switch_fd => switch_fd)
    ::Process.detach(pid)
  end

  private

  def executable
    Pathname(__dir__).join('..', '..', 'objects', 'switch_manager', 'switch').to_s
  end

  def process_name
    "switch.#{@ip_address}:#{@port}"
  end
end
