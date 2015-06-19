require './hill_climb'

t = Tableau.new(100,300)
t.random_ordinal!

100.times do 
  t.show_pop
  puts "\n\n"
  t = t.next_generation
end