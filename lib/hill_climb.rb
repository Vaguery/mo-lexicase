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


  def self.crossover(mom,dad)
    (0...mom.length).collect {|idx| Random.rand() < 0.5 ? mom[idx] : dad[idx]}
  end


  def next_generation
    tng = Tableau.new(self.pop_size,@rubrics,@range)
    tng.population = tng.pop_size.times.collect do
      Tableau.crossover(@population[lexicase_index],@population[lexicase_index])
    end
    return tng
  end


  def show_pop
    @population.each {|a| puts a.join(",")}
  end
end