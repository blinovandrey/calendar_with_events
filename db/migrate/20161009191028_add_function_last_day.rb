class AddFunctionLastDay < ActiveRecord::Migration
  def up
    execute %{
      CREATE OR REPLACE FUNCTION last_day(DATE)
      RETURNS DATE AS
      $$
        SELECT (date_trunc('MONTH', $1) + INTERVAL '1 MONTH - 1 day')::DATE;
      $$ LANGUAGE 'sql' IMMUTABLE STRICT;
      }
  end
  
  def down
    execute %{DROP FUNCTION last_day(DATE)}
  end
end

