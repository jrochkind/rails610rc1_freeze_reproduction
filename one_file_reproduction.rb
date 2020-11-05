require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  # Activate the gem you are reporting the issue against.
  gem "activerecord", "6.1.0.rc1"
  gem "activejob", "6.1.0.rc1"
  gem "sqlite3"
  gem "byebug"
end

require "active_record"
require "active_job"
require "minitest/autorun"
require "logger"


# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end
end

class Post < ActiveRecord::Base
  after_commit :enqueue_post_counter_job

  def enqueue_post_counter_job
    PostCounterJob.perform_later
  end
end

class PostCounterJob < ActiveJob::Base
  # To reproduce our problem, we need to set queue_adapter to inline. In 6.0.3.4,
  # the test runs fine, although doesn't reproduce.
  #
  # In 6.1.0.rc1, setting queue adpater to inline oddly results in:
  # ActiveRecord::StatementInvalid: SQLite3::SQLException: no such table: posts
  #
  # something regarding transactions, the migration didn't happen somehow?
  self.queue_adapter = :inline

  def perform
    puts "posts: #{Post.count}"
  end
end


class DeadlockTest < ActiveSupport::TestCase
  def test_association_stuff
    post = Post.create!
    # In 6.1.0.rc1 this seems to deadlock, never coming back. In 6.0.3.4 nothing unsuual happens.
    puts "finished"
  end
end
