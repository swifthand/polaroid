require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs        << "test"
  t.test_files  = Dir[File.join(File.dirname(__FILE__), 'test/**/*test.rb')]
end
