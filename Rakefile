require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :env, [:env] do |_t, args|
  require 'string_to_number'
end

desc 'Start a console'
task :console do
  exec 'irb -I lib -r string_to_number'
end
