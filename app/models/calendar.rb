class Calendar
  attr_reader :days, :weeks
  
  def initialize(year, month, user = 0)
    first_day = Date.new(year.to_i, month.to_i, 1).beginning_of_week
    last_day = Date.new(year.to_i, month.to_i, Time.days_in_month(month.to_i, year.to_i)).end_of_week
    @days = []
    ((last_day - first_day).to_i + 1).times do |i|
      @days << Day.new(first_day + i, 0)
    end
    @weeks = (0...(@days.count / 7)).to_a
    fill_events_counts(first_day, last_day, user)
  end

  private
  Day = Struct.new(:date, :events_count)

  def fill_events_counts(first_day, last_day, user = 0)
    events_counts = ActiveRecord::Base.connection.execute(
      "SELECT count FROM get_events_counts('#{first_day}', '#{last_day}', #{user})")
    @days.zip(events_counts).map do |day, count| 
      day.events_count = count['count']
    end
  end
end

