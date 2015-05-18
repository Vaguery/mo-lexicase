# multiobjective and lexicase search


## Things Nic and I have thought about:

- lexicase selection sucks on symbolic regression (maybe? sometimes?)
- lexicase selection is kindof like multiobjective selection (except it goes in a different direction in the high-dimensional space)
- what good is lexicase selection compared to its closest relative(s)? that is, what about almost-lexicase, or kinda-lexicase?
- what's the simplest system where you could see lexicase selection "have an effect"? what's that effect going to be? will it be at the level of the population dynamics, or the genealogies, or the "performance" (WTF is that?) or what?
- there's a kind of "Ur-lexicase" thing out there, which includes all the training data, and all the _pairs_ of training data as little teeny non-domination posets, and all the _triples_, and so on up to all the training cases as a single (very bad) multiobjective search. what's up with that?
- penalties for non-answering Push programs
- suppose $$X$$ and $$Y$$ both get (perfectly) a subset $$x$$ and $$y$$ respectively of all possible (Boolean) training cases, then 
  - if $$x = y$$ then they have equal chance of winning
  - if $$y \subset x$$ then $$X$$ always wins
  - if $$x \cap y \neq \empty$$ then ???
- suppose those scores aren't boolean… ???
- what about relation between number of individuals (pop size) and number of test cases (because selection)
- correlation among test cases will affect relative "importance" of each case

## some problems

### some easy problems to get a feel for it all

- GA, basically, with random per-gene objectives; fixed-length genomes
- simultaneous permutation pattern avoidance, for a suite of patterns (score each sequence of length N>m for whether it avoids a (random) permutation pattern of length m); variable-length genomes of numbers, permits mixed crossover (no known work extant) (a lot like Terry Jones's RS landscapes)
x- RS landscapes
- (sidebar: what is it that makes a GA problem suitable for lexicasing? e.g. knapsack is bad; Nk is good)

### some medium problems we know can be solved by Clojush implementations

- Mona Lisa (grayscale)
- stuff from Nic & Tom's papers?

### some hard problems

- checksum
- bowling score problem
- other hard problems from Tom Helmuth

### Even more open questions 

- with trees, is it more difficult to recombine functionality than it is in linear representations?
- can adding noise prevent loss of important components?
- would there be any advantage if you didn't have crossover? (e.g. lexicase hillclimbing)
- neutral networks???
- transition between GA and GP (Mona Lisa)

## Project sketch

- poke around in Ruby and Clojure to get a sense of how to add "knobs" to lexicase selection methods
- start some runs and see what should be measured and collected
- try some of the trivial problems to inform work with the harder ones?
