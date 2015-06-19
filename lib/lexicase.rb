require './hill_climb'

t = Tableau.new(100,100,100)
# t.random_ordinal!

50.times do 
  t.show_pop
  puts "\n\n"
  t = t.next_generation
end