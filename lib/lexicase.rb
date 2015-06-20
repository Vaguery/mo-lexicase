require './hill_climb'

t = Tableau.new(200,100)
t.random_ordinal!


File.open("../discard.csv", "w") do |outfile|
  100.times do |i|
    step = t.show_pop
    puts i
    outfile.puts step
    break if t.population.uniq.length == 1
    t = t.next_crossover_tournament_generation(2)
  end
end

puts t.show_pop