class BinPackingProblem
  attr_reader :capacity
  attr_reader :items

  def initialize(capacity,*items)
    @capacity = capacity
    @items = items
  end

  def packed_volume(solution)
    return @items.each.with_index.inject(0) do |sum,(weight,idx)|
      if solution.choices[idx]
        sum + weight
      else
        sum
      end
    end
  end

  def overweight(solution)
    wt = packed_volume(solution)
    return (wt >= @capacity) ? (wt-@capacity) : 0
  end

  def underweight(solution)
    wt = packed_volume(solution)
    return (wt < @capacity) ? (@capacity-wt) : 0
  end
end


class BinPackingBooleanSolution
  attr_reader :number_of_items
  attr_reader :choices

  def initialize(size,choices = [])
    @number_of_items = size
    @choices = choices
  end

  def self.random(size)
    BinPackingBooleanSolution.new(size, size.times.collect {Random.rand() < 0.5})
  end
end



## playing with those tools
wts = 20.times.collect {Random.rand(100) + 1}
a = BinPackingProblem.new(200,*wts)

puts "weights: #{wts}\n\n"

puts "over,under,failure-to-pack-item"
10.times do 
  picks = BinPackingBooleanSolution.random(a.items.length)
  puts "#{a.overweight(picks)},#{a.underweight(picks)},#{picks.choices.collect {|c| c ? 0 : 1}.join(",")}"
end
