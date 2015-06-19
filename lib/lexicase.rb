require './hill_climb'

t = Tableau.new(1000,200,1000)


50.times do 
  t.show_pop
  puts "\n\n"
  t = t.next_generation
end