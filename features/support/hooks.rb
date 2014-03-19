require 'switch_manager/cli'

After do
  pid_file = SwitchManager::CLI.new.pid_file
  if File.exist?(pid_file)
    pid = File.read(pid_file).to_i
    ::Process.kill(:TERM, pid)
  end
end
