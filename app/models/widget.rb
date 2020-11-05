class Widget < ApplicationRecord
  after_commit :do_bg_job

  def do_bg_job
    WidgetCountJob.perform_later
  end
end
