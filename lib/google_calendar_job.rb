require 'google_calendar'

class GoogleCalendar < Dashing::Job

  protected

  def do_execute
    events = load_calendar_events(config[:url])

    { events: events }
  end

  private

  def load_calendar_events(url)
    options = {
      username: ENV['GOOGLE_USERNAME'], # e.g. 'wei@neo.com'
      password: ENV['GOOGLE_PASSWORD'], # e.g. '[use app specific password if 2-step verification is enabled]'
      app_name: ENV['GOOGLE_APP_NAME'], # e.g. 'neo.com-neodash'
      calendar: ENV['GOOGLE_CALENDAR_NAME'] # e.g. 'Singapore Office'
    }
    cal = Google::Calendar.new(options)

    events = cal.find_future_events.map do |e|
      {
        title: e.title,
        start: Time.parse(e.start_time).to_i,
        end: Time.parse(e.end_time).to_i
      }
    end

    # sort by start time
    events.sort{ |a, b| a[:start] <=> b[:start] }[0..1]
  end
end
