require "test_helper"

class WidgetTest < ActiveSupport::TestCase
  test "save one" do
    $widget_count = false
    ActiveJob::Base.queue_adapter = :inline

    Widget.new(name: "joe").save!
    assert $widget_count
  end
end
