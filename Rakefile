require 'bundler'
require 'rspec/core/rake_task'
require 'rake/clean'

Bundler::GemHelper.install_tasks

task :default => [:test]

RSpec::Core::RakeTask.new(:test) do |spec|
    spec.skip_bundler = true
    spec.pattern = 'spec/*_spec.rb'
    spec.rspec_opts = '--color --format doc'
end

desc "Show the different encodings using a test file"
namespace :test do
  task :person do
    sh "ruby examples/main.rb examples/person"
  end
end


