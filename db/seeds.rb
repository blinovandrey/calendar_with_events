4000.times do
    Event.create!(
      title: Faker::Lorem.sentence, 
      date_start: Faker::Date.between(1.years.ago, 1.years.since), 
      repeat: 0, 
      user_id: rand(1..3))
end

4000.times do
    date = Faker::Date.between(1.years.ago, 1.years.since)
    Event.create!(
      title: Faker::Lorem.sentence, 
      date_start: date, 
      date_end: date + rand(1000),
      repeat: rand(1..4), 
      user_id: rand(1..3))
end
