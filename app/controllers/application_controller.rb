class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_start_time
  after_filter :set_end_time

  def set_start_time
    @start_time = Time.now.usec
  end

  def set_end_time
    load_time = (Time.now.usec - @start_time).abs / 1000.0
    #logger.info "githost.#{Rails.env}.pageload.time: #{load_time}"
    Statsd.timing("trivote.#{Rails.env}.pageload.time", load_time)
  end

end