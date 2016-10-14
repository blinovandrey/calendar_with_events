class Event < ActiveRecord::Base
  enum repeat: { once: 0, every_day: 1, every_week: 2, every_month: 3, every_year: 4 }

  belongs_to :repeat
  belongs_to :user

  validates :title, presence: true, length: { maximum: 140 }
  validates :date_start, presence: true
  validates :user_id, presence: true
  validate :date_end_must_be_greater_than_date_start,
    :date_start_not_in_range,
    :date_end_not_in_range

  def date_end_must_be_greater_than_date_start
    if date_start.present? && date_end.present? && date_end < date_start
      errors.add(:date_end, "must be greater than date of start")
    end
  end

  def date_start_not_in_range
    if date_start.present? && (date_start < Date.new(1900, 1, 1) || date_start > Date.new(3000, 1, 1))
      errors.add(:date_start, "must be between 1900-01-01 and 3000-01-01")
    end
  end

  def date_end_not_in_range
    if date_end.present? && (date_end < Date.new(1900, 1, 1) || date_end > Date.new(3000, 1, 1))
      errors.add(:date_end, "must be between 1900-01-01 and 3000-01-01")
    end
  end

  def repeat_human
    self.repeat.humanize
  end

  def self.repeats_human
    self.repeats.map { |repeat| [repeat[0].humanize, repeat[0]] }
  end

  def self.on_day(day, user_id = 0)
    where_clause = 
      %{(repeat = 0 and date_start = :day
        or :day between events.date_start and coalesce(events.date_end, '3000-01-01'::date)
        and (repeat = 1 
            or repeat = 2 and extract(dow from events.date_start) = extract(dow from :day::date)
            or repeat = 3 and (extract(day from events.date_start) = extract(day from :day::date)
              or events.last_day_of_month = true and :day::date = last_day(:day::date) 
              and extract(day from events.date_start) > extract(day from last_day(:day::date)))
            or repeat = 4 and extract(month from events.date_start) = extract(month from :day::date) 
            and (extract(day from events.date_start) = extract(day from :day::date)
              or events.last_day_of_month = true and :day::date = last_day(:day::date) 
              and extract(day from events.date_start) > extract(day from last_day(:day::date)))))}
    where_clause << %{ and user_id = :user_id} if user_id > 0
    Event.where(where_clause, day: day, user_id: user_id)
  end
end