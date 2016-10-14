json.array!(@events) do |event|
  json.extract!(event, :id, :title, :date_start, :date_end, :last_day_of_month, :repeat, :user_id, :full_name)
  json.repeat_human event.repeat.humanize
  json.mine event.user_id == session[:user_id]
end
