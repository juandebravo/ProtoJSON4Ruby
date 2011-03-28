require 'bundler'
require 'rake/rdoctask'
require 'rake/clean'

Bundler::GemHelper.install_tasks

desc "Show the different encodings using a test file"
namespace :test do
  task :person do
    sh "ruby spec/main.rb spec/person"
  end
end


Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "LICENSE", "lib/**/*.rb")
  rd.title = 'ProtoJson'
end

