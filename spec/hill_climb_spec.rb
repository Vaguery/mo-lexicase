require 'hill_climb.rb'

describe "tableau initialization" do
  it "should have a population" do
    expect(Tableau.new(10,100).population.length).to eq 10
  end

  it "should assign a score/gene for each rubric" do
    t = Tableau.new(10,20)
    t.population.each do |answer|
      expect(answer.length).to eq 20
    end
  end

  it "should store the number of rubrics" do
    t = Tableau.new(10,20)
    expect(t.rubrics).to eq 20
  end

  it "should respond to #pop_size" do
    t = Tableau.new(11,20)
    expect(t.pop_size).to eq 11
  end

  it "should set the score range" do
    expect(Tableau.new(11,20).range).to eq 1000
    expect(Tableau.new(11,20,2).range).to eq 2
  end

  it "should use the score range to set rubric values" do
    t = Tableau.new(11,1000,2)
    t.population.each do |answer|
      expect(answer.uniq.sort).to eq [0,1]
    end
  end
end

describe "lexicase selection" do
  it "should pick the clear winner when there is one" do
    t = Tableau.new(10,20)
    t.population[0] = [0]*20
    expect(t.lexicase_index).to eq 0
  end

  it "should pick a random winner when there isn't one" do
    t = Tableau.new(10,1)
    t.population.each {|answer| answer[0] = 77}
    100.times do 
      expect(t.lexicase_index).to be < 10
    end
  end

  it "should winnow down to one dude no matter what" do
    t = Tableau.new(10,1000)
    100.times do 
      expect(t.lexicase_index).to be < 10
    end
  end
end

describe "crossover" do
  it "should take two arrays and produce a new array of the same length" do
    a = [1] * 10
    b = [2] * 10
    expect(Tableau.crossover(a,b).length).to eq 10
  end

  it "should mix the values" do
    a = [1] * 100
    b = [2] * 100
    expect(Tableau.crossover(a,b).uniq.sort).to eq [1,2]
  end

  it "should not be byRef (just in case; hey I'm paranoid)" do
    a = [1] * 10
    baby = Tableau.crossover(a,a)
    a[2] = 666
    expect(baby[2]).to eq 1
  end
end

describe "next_generation" do
  it "should return a Tableau with the same basic parameters" do
    t = Tableau.new(10,11,12)
    expect(t.next_generation.pop_size).to eq 10
    expect(t.next_generation.rubrics).to eq 11
    expect(t.next_generation.range).to eq 12
  end

  it "should use lexicase_selection to pick parents" do
    t = Tableau.new(10,11,12)
    allow(t).to receive(:lexicase_index) { 3 }
    expect(t).to receive(:lexicase_index).exactly(20).times
    t2 = t.next_generation
  end

  it "should be populated by crossover" do
    expect(Tableau).to receive(:crossover).exactly(10).times
    t = Tableau.new(10,11,12)
    t2 = t.next_generation
  end
end
