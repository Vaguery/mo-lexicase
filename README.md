# multiobjective and lexicase search


## Things Nic and I have thought about:

- lexicase selection sucks on symbolic regression (maybe? sometimes?)
- lexicase selection is kindof like multiobjective selection (except it goes in a different direction in the high-dimensional space)
- what good is lexicase selection compared to its closest relative(s)? that is, what about almost-lexicase, or kinda-lexicase?
- what's the simplest system where you could see lexicase selection "have an effect"? what's that effect going to be? will it be at the level of the population dynamics, or the genealogies, or the "performance" (WTF is that?) or what?
- there's a kind of "Ur-lexicase" thing out there, which includes all the training data, and all the _pairs_ of training data as little teeny non-domination posets, and all the _triples_, and so on up to all the training cases as a single (very bad) multiobjective search. what's up with that?

## some problems

### some easy problems to get a feel for it all

- GA, basically, with random per-gene objectives; fixed-length genomes
- simultaneous permutation pattern avoidance, for a suite of patterns (score each sequence of length N>m for whether it avoids a (random) permutation pattern of length m); variable-length genomes of numbers, permits mixed crossover (no known work extant)
- Nk landscapes

### some medium problems we know can be solved by Clojush implementations

- stuff from Nic & Tom's papers?

### some hard problems

- checksum
- bowling score problem
- other hard problems from Tom Helmuth

### Even more open questions 

- with trees, is it more difficult to recombine functionality than it is in linear representations?
- can adding noise prevent loss of important components?

## Project sketch

- poke around in Ruby and Clojure to get a sense of how to add "knobs" to lexicase selection methods
- start some runs and see what should be measured and collected
- try some of the trivial problems to inform work with the harder ones?
