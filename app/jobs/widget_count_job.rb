class WidgetCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    $widget_count = Widget.count
    puts "Widget count: #{$widget_count}"
  end
end
