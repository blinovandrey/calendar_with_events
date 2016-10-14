json.event do
  json.extract!(@event, :id, :title, :date_start, :date_end, :last_day_of_month, :repeat, :user_id)
  json.repeat_human @event.repeat.humanize
  json.full_name @event.user.full_name
end
json.repeats @repeats