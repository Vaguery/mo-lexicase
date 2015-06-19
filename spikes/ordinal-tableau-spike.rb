require 'rspec'

# exploring a slight extension of the max-ones problem

@number_of_individuals = 100
@number_of_rubrics = 10

tableau = @number_of_rubrics.times.collect do |i|
  @number_of_individuals.times.collect {Random.rand(3)}
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
  scratch = @tt.dup

  until filter_order.empty? || scratch.length < 2
    filter = filter_order.pop
    best = (scratch.collect {|individual| individual[filter]}).min
    scratch = scratch.keep_if {|individual| individual[filter] == best}
  end

  return @tt.find_index(scratch.sample)
end

# puts @tt.inspect

# tourney_histogram = Hash.new(0)
# tourney_winners = 5000.times do
#   tourney_histogram[tournament_select(tableau,7)] += 1
# end

# lexi_histogram = Hash.new(0)
# lexi_winners = 5000.times.collect do
#   lexi_histogram[lexicase_select(tableau)] += 1
# end

# puts "Tournament (7): #{tourney_histogram.length}"
# puts "Lexicase: #{lexi_histogram.length}"

def crossover(mom,dad,prob=0.5)
  babies = [[],[]]
  from_mom = true
  mom.each_with_index do |token,idx|
    from_mom = Random.rand() < prob
    babies[0].push (from_mom ? token : dad[idx])
    babies[1].push (from_mom ? dad[idx] : token)
  end
  # puts "#{mom.inspect} x #{dad.inspect} -> #{babies.inspect}"
  return babies
end

# m = (1..30).to_a
# d = (31..60).to_a
# puts crossover(m,d,0.1).inspect

def next_lexicase_tableau(tableau,prob=0.5)
  result = []
  (@number_of_individuals/2).times do
    mom = tableau[lexicase_select(tableau)]
    dad = tableau[lexicase_select(tableau)]
    babies = crossover(mom,dad,prob)
    result << babies[0]
    result << babies[1]
  end
  return result
end

def next_tournament_tableau(tableau,prob=0.5)
  result = []
  (@number_of_individuals/2).times do
    mom = tableau[tournament_select(tableau,7)]
    dad = tableau[tournament_select(tableau,7)]
    babies = crossover(mom,dad,prob)
    result << babies[0]
    result << babies[1]
  end
  return result
end


## You know, this could take a while…

File.open("spikes/1000x200x300-lexicase.csv", "w") do |out_file|
  @lexi = @tt.clone
  p "writing original tableau"

  (0..300).each do |gen|
    p "generation #{gen}..."
    (0...@number_of_individuals).each do |idx|
      total_error = @lexi[idx].inject(0) {|sum,err| sum+err}
      line = "#{gen},#{idx},#{total_error}," + @lexi[idx].join(",")
      out_file.puts line
    end
    @lexi = next_lexicase_tableau(@lexi)
  end
  
end

## tournament
File.open("spikes/1000x200x300-tournament.csv", "w") do |out_file|
  @tournie = @tt.dup
  p "writing original tableau"

  (0...300).each do |gen|
    p "generation #{gen}..."
    (0...@number_of_individuals).each do |idx|
      total_error = @tournie[idx].inject(0) {|sum,err| sum+err}
      line = "#{gen},#{idx},#{total_error}," + @tournie[idx].join(",")
      out_file.puts line
    end
    @tournie = next_tournament_tableau(@tournie)
  end
end