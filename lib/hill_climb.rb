class Tableau
  attr_accessor :population
  attr_reader :rubrics
  attr_reader :range

  def initialize(pop,rubrics,range=1000)
    @population = pop.times.collect do
      rubrics.times.collect do
        Random.rand(range)
      end
    end
    @rubrics = rubrics
    @range = range
  end


  def pop_size
    @population.length
  end


  def random_ordinal!
    @population = (@rubrics.times.collect {(0...pop_size).to_a.shuffle}).transpose
  end



  def lexicase_index
    filtering_order = (0...@rubrics).to_a.shuffle
    candidates = (0...pop_size).to_a

    until filtering_order.empty? || candidates.length < 2
      filter_rubric = filtering_order.pop
      remaining_scores_at_that = candidates.collect {|idx| @population[idx][filter_rubric]}
      best_score = remaining_scores_at_that.sort[0]
      new_candidates = candidates.keep_if {|idx| @population[idx][filter_rubric] == best_score}
      if new_candidates.empty?
        candidates = [candidates.sample]
      else
        candidates = new_candidates
      end
    end
    return candidates.sample
  end


  def generalized_lexicase_index(subset_size=@rubrics)
    filtering_order = (0...@rubrics).to_a.sample(subset_size).shuffle
    candidates = (0...pop_size).to_a

    until filtering_order.empty? || candidates.length < 2
      filter_rubric = filtering_order.pop
      remaining_scores_at_that = candidates.collect {|idx| @population[idx][filter_rubric]}
      best_score = remaining_scores_at_that.sort[0]
      new_candidates = candidates.keep_if {|idx| @population[idx][filter_rubric] == best_score}
      if new_candidates.empty?
        candidates = [candidates.sample]
      else
        candidates = new_candidates
      end
    end
    return candidates.sample
  end


  def tournament_index(tourney_size=7)
    candidates = (0...pop_size).to_a.sample(tourney_size)
    scored = Hash.new(0)
    candidates.each {|idx| scored[idx] = total_score(@population[idx])}
    best_score = scored.values.min
    bests = scored.select {|k,v| v==best_score}
    return bests.keys.sample
  end


  def self.crossover(mom,dad)
    (0...mom.length).collect {|idx| Random.rand() < 0.5 ? mom[idx] : dad[idx]}
  end


  def self.alternation(mom,dad,prob=0.1)
    from_mom = false
    (0...mom.length).collect do |idx|
      from_mom = !from_mom if Random.rand() < prob 
      from_mom ? mom[idx] : dad[idx]
    end
  end


  def next_crossover_lexicase_generation
    tng = Tableau.new(self.pop_size,@rubrics,@range)
    tng.population = tng.pop_size.times.collect do
      Tableau.crossover(@population[lexicase_index],@population[lexicase_index])
    end
    return tng
  end


  def next_crossover_generalized_lexicase_generation(subset_size=@rubrics)
    tng = Tableau.new(self.pop_size,@rubrics,@range)
    tng.population = tng.pop_size.times.collect do
      Tableau.crossover(@population[generalized_lexicase_index(subset_size)],
        @population[generalized_lexicase_index(subset_size)])
    end
    return tng
  end



  def next_crossover_tournament_generation(tourney_size=7)
    tng = Tableau.new(self.pop_size,@rubrics,@range)
    tng.population = tng.pop_size.times.collect do
      Tableau.crossover(@population[tournament_index(tourney_size)],
        @population[tournament_index(tourney_size)])
    end
    return tng
  end


  def next_alternation_generation
    tng = Tableau.new(self.pop_size,@rubrics,@range)
    tng.population = tng.pop_size.times.collect do
      Tableau.crossover(@population[lexicase_index],@population[lexicase_index])
    end
    return tng
  end


  def total_score(answer)
    return answer.inject(0) {|sum,rubric| sum+rubric}
  end


  def show_pop
    id = 0
    @population.inject("") do |report,answer|
      id += 1
      report + "#{id},#{total_score(answer)}," + answer.join(",") + "\n"
    end
  end
end