# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(/^spec\/.+_spec\.rb$/)
  watch(%r{/^lib/switch_manager/(.+)\.rb$/}) do |m|
    "spec/switch_manager/#{m[1]}_spec.rb"
  end
  watch('spec/spec_helper.rb')  { 'spec' }
end

guard :cucumber, cli: '--tags ~@wip' do
  watch(/^features\/.+\.feature$/)
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
  end
end

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if your Gemfile contains the `gemspec' command.
  # watch(/^.+\.gemspec/)
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(/(?:.+\/)?rubocop-todo\.yml$/) { |m| File.dirname(m[0]) }
  watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
end
