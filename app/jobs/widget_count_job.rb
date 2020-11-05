class WidgetCountJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "about to call Widget.count"
    $widget_count = Widget.count
    puts "Widget count: #{$widget_count}"
  end
end
