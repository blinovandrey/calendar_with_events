class AddFunctionGetEventsCounts < ActiveRecord::Migration
  def up
    execute %{
      CREATE OR REPLACE FUNCTION get_events_counts (first_day date, last_day date, usr_id int) 
      RETURNS TABLE (count bigint)
      AS $$
      begin
      drop table IF EXISTS dates;
      drop table IF EXISTS temp_events;
      create temp table dates(date date);
      insert into dates
      select generate_series(first_day, last_day, '1 day')::date;

      create temp table temp_events (date_start date, date_end date, repeat int, last_day_of_month boolean);
      insert into temp_events
      SELECT events.date_start, events.date_end, events.repeat, events.last_day_of_month
      FROM events 
      WHERE ((usr_id = 0 or events.user_id = usr_id) and (repeat = 0 and events.date_start BETWEEN first_day and last_day
              OR 
              (
                events.repeat BETWEEN 1 and 3 
                OR events.repeat = 4
                AND (
                  extract(month FROM age(last_day, events.date_start)) = 0
                  OR extract(month from age(last_day, events.date_start)) = 1 
                  AND extract(day from age(last_day, events.date_start)) <= extract(day from age(last_day, first_day))
                )
              ) and events.date_start <= last_day and coalesce(events.date_end, '3000-01-01'::date) >= first_day
              )) ;
             
      return query
      select count(temp_events.*) as count from dates left join temp_events
          on temp_events.repeat = 0 and temp_events.date_start = dates.date
          or      (temp_events.repeat = 1  
            or temp_events.repeat = 2 and extract(dow from temp_events.date_start) = extract(dow from dates.date)
            or temp_events.repeat = 3 and (extract(day from temp_events.date_start) = extract(day from dates.date)
              or temp_events.last_day_of_month = true and dates.date = last_day(dates.date) and extract(day from temp_events.date_start) > extract(day from last_day(dates.date)))
            or temp_events.repeat = 4 and extract(month from temp_events.date_start) = extract(month from dates.date) and (extract(day from temp_events.date_start) = extract(day from dates.date)
              or temp_events.last_day_of_month = true and dates.date = last_day(dates.date) and extract(day from temp_events.date_start) > extract(day from last_day(dates.date))))
          and
          dates.date between temp_events.date_start and coalesce(temp_events.date_end, '3000-01-01'::date)
          group by dates.date
          order by dates.date;
      END; 
      $$ LANGUAGE plpgsql
      }
  end
  
  def down
    execute %{DROP FUNCTION get_events_counts (first_day date, last_day date, usr_id int) }
  end
end
