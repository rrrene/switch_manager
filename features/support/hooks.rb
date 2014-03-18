After do
  pid_file = Pathname(__dir__).join('..', '..', 'tmp', 'pid', 'switch_manager.pid').to_s
  if File.exist?(pid_file)
    pid = File.read(pid_file).to_i
    ::Process.kill(:TERM, pid)
  end
end
