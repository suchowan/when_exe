require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create do |t|
  t.test_prelude = 'require "test_helper"'
  t.test_globs = ["test/test/*.rb", "test/test/region/*.rb", "test/test/ephemeris/*.rb"]
end

task default: :test
