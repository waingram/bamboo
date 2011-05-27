require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'rcov/rcovtask'
require 'cucumber/rake/task'

desc "Run rspec tests"
RSpec::Core::RakeTask.new(:spec)

desc "Run cucumber tests"
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = '--format pretty --color'
end

namespace :rcov do
  rcov_opts = %w(
    --exclude gems\/,spec\/,features\/
    --aggregate coverage/coverage.data
  )

  desc "Run rspec tests with code coverage"
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = '--format pretty --color'
    t.rcov = true
    t.rcov_opts = rcov_opts
  end

  desc "Run cucumber tests with code coverage"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rcov = true
    t.rcov_opts = rcov_opts
    t.rcov_opts << '-Ispec'
  end

  desc "Run rspec and cucumber and aggregate coverage data"
  task :all do |t|
    rm 'coverage/coverage.data' if File.exists?('coverage/coverage.data')
    Rake::Task['rcov:spec'].invoke
    Rake::Task['rcov:cucumber'].invoke
  end
end
