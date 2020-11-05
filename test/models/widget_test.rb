require "test_helper"

class WidgetTest < ActiveSupport::TestCase
  #include ActiveJob::TestHelper
  self.use_transactional_tests = true


  test "save one" do
    $widget_count = false
    ActiveJob::Base.queue_adapter = :inline

    Widget.new(name: "joe").save!
    assert $widget_count
  end
end
