

@number_of_individuals = 1000
@number_of_rubrics = 200

tableau = @number_of_rubrics.times.collect do |i|
  @number_of_individuals.times.collect {Random.rand(@number_of_individuals)}
end

@tt = tableau.transpose

def total_error(individual_as_vector)
  return individual_as_vector.inject(0) {|sum,err| sum + err}
end


def tournament_select(tableau,tourney_size)
  tourney = @tt.sample(tourney_size)
  min_error = (tourney.collect {|individual| total_error(individual)}).min
  return @tt.find_index (tourney.find_all {|individual| total_error(individual) == min_error}).sample
end

def lexicase_select(tableau)
  filter_order = (0...@number_of_rubrics).to_a.shuffle
  candidates = (0...@number_of_individuals).to_a
  scratch = @tt.clone

  until filter_order.empty? || scratch.length < 2
    filter = filter_order.pop
    best = (scratch.collect {|individual| individual[filter]}).min
    scratch = scratch.keep_if {|individual| individual[filter] == best}
  end

  return @tt.find_index(scratch.sample)
end



# puts @tt.inspect

tourney_histogram = Hash.new(0)
tourney_winners = 1000.times do
  tourney_histogram[tournament_select(tableau,7)] += 1
end

lexi_histogram = Hash.new(0)
lexi_winners = 1000.times.collect do
  lexi_histogram[lexicase_select(tableau)] += 1
end

puts "Tournament (7): #{tourney_histogram.length}"
puts "Lexicase: #{lexi_histogram.length}"