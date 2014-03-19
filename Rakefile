task :default => :test # rubocop:disable HashSyntax
task :test => [:spec, :cucumber] # rubocop:disable HashSyntax
task :travis => :test # rubocop:disable HashSyntax

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
rescue LoadError
  task :spec do
    $stderr.puts 'RSpec is disabled'
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = '--tags ~@wip'
  end
rescue LoadError
  task :cucumber do
    $stderr.puts 'Cucumber is disabled'
  end
end
