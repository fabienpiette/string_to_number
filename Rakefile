# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[rubocop spec]

task :env, [:env] do |_t, _args|
  require 'string_to_number'
end

desc 'Start a console'
task :console do
  exec 'irb -I lib -r string_to_number'
end
