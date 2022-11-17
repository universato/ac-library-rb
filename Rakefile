require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new :copy do
  # for make ./lib_lock to use ./lib
  require_relative "./bin/lock_lib.rb"
end

Rake::TestTask.new :test do |t|
  t.warning = false
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => %i[copy test]
