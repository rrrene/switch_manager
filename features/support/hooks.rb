After do
  pid_file = File.dirname(File.realpath(__FILE__)) + '/../../tmp/pid/switch_manager.pid'
  if File.exist?(pid_file)
    pid = File.read(pid_file).to_i
    ::Process.kill(:TERM, pid)
  end
end
