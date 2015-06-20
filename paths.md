# parametric paths between lexicase, tournament and multiobjective selection algorithms

## A tableau

Let me define a _tableau_ here as the _detailed of a EA's population_ at some moment. The _rows_ of this tableau representing each individual (or "answer", or "prospect") present in the population, possibly in multiple copies. The _columns_ represent the objective(s) of search, which we can (without loss of generality) refer to as "errors"; each column represents some _rubric_ by which we decide which individuals are better or worse than others. These rubrics can include errors measured for particular desired input:output training cases, structural "errors" which score an answer with regard to its structure or expressed behavior relative to some idealized target (such as "code length", for which the "ideal" might be an empty program with no structure at all), or algorithmically aggregated "errors" taken over several of these other columns (for example, total error over 15 input:output combinations; or "non-dominated on the basis of code length and total error").

The values in the "cells" of this tableau are the measured scores themselves. We should imagine for simplicity here that every value is filled in, and that every individual _can be validly scored_ with regard to every rubric.

## Selection algorithms, generally

I'll only speak here about algorithms which select a _single_ individual from the tableau, one time. For instance, in lexicase selection we begin the algorithm by producing a random permuted order over the rubric columns; I will assume this is fixed during a _single_ selection call. Similarly, in tournament selection we begin by selecting a _subset_ of the population. Whether those permutations or subsets change between selection events isn't important at the moment.

That said, I should note that we could say search (not just selection) "starts with" a single subsetting over the rubrics: a division of data for supervised learning into _training_ and _test_ cases.

## Random sampling as the default

It also feels as though the "fundamental" algorithm is uniform random selection. In tournament selection, if all scores are identical upon inspection we will return a random sample of the tourament subset; in lexicase selection, if when we exhaust the rubrics we have more than one individual remaining, we return a random sample of the filtered subset. In some sense, it's reasonable to expect that all selection algorithms can be _relaxed_ to uniform random selection. If we increase the tournament size to the population size, we are selecting the "best-scoring" individual every time; if we reduce it to 1, we are sampling the population uniformly. In "partial lexicase" selection (described below), as we reduce the number of columns on which we select to 0, we end up sampling the population uniformly.

## "partial tournament"

Tournament selection is most often defined as taking a fixed-size subset of the population, and then returning a "best" individual over that subset only. The score is typically an _aggregate_ score, calculated for each individual as a single rubric which is a reduction over _every_ training data error rubric (summed error over all training cases; summed squared error over all training cases; max error over all cases, etc.). Note that while tournament selection typically relies on this single aggregated rubric, it _implies_ the others.

Suppose we augment this to create _partial tournament selection_, which I'll define as something like "tournament selection using a score aggregated over a _fixed subset_ of the rubrics".

Where we have 200 individuals in rows and 100 "error" columns, an application of tournament selection would select $$t$$ of the rows first, and return the best-scoring individual from within that subset, scored by the aggregate calculated over every rubric. In partial tournament selection, we sample $$t$$ individuals and $$r$$ rubrics, and return the best-scoring individual from within that subset of individuals, scored by aggregate calculated only over the subset of rubrics. The initial subsampling of individuals is not changed here; rather the definition of scoring is changed. As noted above, this amounts to further reduction of the training data into a new smaller subset.

As the value of $$t$$ is increased towards the population size, and the value of $$r$$ is reduced to 0, this algorithm reduces to _partial lexicase selection_ with $$r = 1$$. And of course as $$r$$ approaches 0, it reduces to uniform random sampling.

## "partial lexicase"

Lexicase selection begins by taking a random permutation of the rubrics, and proceeds by using that permutation in a series of $$r$$ convolved filtering operations.

Let me define _partial lexicase selection_ as first selecting a random subsample of $$r$$ rubrics, and then operating on that subset as before.

For example, if we have 20 rubrics, lexicase selection would attempt to apply filtering on some entire permutation over all columns, for example `[15, 13, 10, 17, 1, 18, 4, 2, 19, 20, 3, 11, 12, 5, 9, 14, 7, 6, 16, 8]`. In the case of partial lexicase selection with $$r=7$$, the filtering might only apply to `[5, 4, 6, 14, 17, 19, 16]` and then "quit", producing a random sample if multiple individuals remained in the final stage.

As noted above, when $$r$$ is reduced to 1, the algorithm is identical to partial tournament selection with $$t$$ set to the population size and $$r=1$$. And when $$r$$ is reduced to 0, it is random selection.

## blending tournament and lexicase selection

There is of course another parametric path (of sorts) between [partial] lexicase and [partial] tournament selection, and it involves _aggregation_. Full tournament selection imposes its aggregation over all columns; full lexicase selection imposes a permutation over all columns.

What might the algorithm be called, which produces two "proxy columns", each of which contains an aggregate score of half the rubrics, and which applies lexicase selection over those two? This process might be seen as one which partitions the rubrics into subsets, so that some partitions contain exactly one rubric while others contain multiple rubrics, and which subsequently applies the _aggregation_ (reduction) to each component of the partition.

So for example suppose there are 10 rubrics. One arbitrary partition (a red flag, combinatorially speaking) of the set `[1,2,3,4,5,6,7,8,9,10]` is `[[1],[2,3],[4,7,9,10],[5,6,8]]`. If the reduction is "summed error", this reduces to four "proxy rubrics": the score on rubric 1, and the summed scores over `[2,3]`, `[4,7,9,10]` and `[5,6,8]`. If we apply (full) lexicase selection over those four _proxy_ rubrics, we are doing something that lives "between" lexicase and tournament selection in a parametric space. As the number of partitions drops to 1, we approach tournament selection, which aggregates the scores over all columns; as the number of partitions increases to $$r$$, we approach lexicase selection, which permutes each rubric in an unaggregated state.

Finally, it should be clear that this "blending" can be applied to _partial lexicase_ and _partial tournament_ selection as well.

## partial multiobjective selection = "ordinal selection" and "projective selection"

(with numerous references needed to [this paper](http://www.evolved-analytics.com/sites/EA_Documents/Publications/GPTP06/GPTP06_ParetoParadigm_Preprint.pdf) (PDF))

Multiobjective selection depends on a generalized notion of "domination". In general, given two vector-valued scores with $$o$$ components, we say one score $$A$$  _dominates_ another $$B$$ if _no component of $$A$$ is worse than the matching component of $$B$$, and at least one component of $$A$$ is better than the matching component of $$B$$_.

Without getting dragged into innumerable details (and a century of esoteric engineering work), a few notable things about this: When the number of component objectives $$o$$ is reduced to 1, multiobjective selection is reduced to simple ranking (with the possibility of ties). Aggregation of the $$o$$ objectives into a single _proxy_ objective (typically by affine combination) is traditional but often a bad idea, especially in difficult  nonlinear contexts. The "sortability" of multiobjective comparisons drops off quickly as $$o$$ increases, and it quickly becomes the case as dimensions increase that two vectors can be mutually non-dominating (and therefore "tied") _even though their values are completely different_.

I want to point out that the two approaches taken most often to deal with this _curse of dimensionality_ are (1) _aggregation_ of some or all of the objectives into proxies, and (2) _subsetting_ some of the objectives and ignoring the others. In other words, maneuvers analogous to those used in what I describe above. In ordinal optimization, a subset of objectives (a projection of the vector onto a lower-dimensional orthogonal hyperplane) is typically used; in projective optimization, all the objectives are typically aggregated into a single scalar by applying a linear transform (of which some parameters can be zeroes). Note in passing that both of these approaches can be seen as linear projections into subspaces; ordinal optimization permits the result to still be a _vector_ of lower dimension, while projective optimization reduces the entire vector to a single _scalar_.

## the selection which shall not be named

You know where this is going....