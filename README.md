
# Statistics::Distributions

Raku package for statistical distributions and related random variates generations.

The distributions and random variate functions of the generations of "Statistics::Distributions"
are automatically exported when ["Data::Generators"](https://raku.land/zef:antononcube/Data::Generators), [AAp1] is loaded.

-----

## Installation

From Zef ecosystem:

```
zef install Statistics::Distributions
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-Statistics-Distributions.git
```


------

## Random reals

This module provides the function `random-real` that can be used to generate lists of real numbers
using the uniform distribution.

Here is a random real:

```perl6
use Statistics::Distributions;
say random-real(); 
```
```
# 0.4199527954793181
```

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```
```
# 9.86785457558584
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```
```
# (4.64238262578993 7.5597573673489435 -0.6657498470161849 0.6622196436310439 -1.49472457527887 -0.08573095506348327)
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
```
```
# [[0.4067735187519572 2.1234670572727 -1.998094450503193]
#  [2.9132811969808827 -2.9279360830602705 -2.994626599483799]
#  [1.7404082895355382 -0.44550938724623457 -2.9778020582412763]
#  [-2.444232062158215 1.8007289848458408 1.508621954689069]]
```


**Remark:** The signature design follows Mathematica's function
[`RandomReal`](https://reference.wolfram.com/language/ref/RandomVariate.html).


------

## Random variates

This module provides the function `random-variate` that can be used to generate lists of real numbers
using distribution specifications.

Here are examples:

```perl6
say random-variate(BernoulliDistribution.new(:p(0.3)), 1000).BagHash.Hash; 
```
```
# {0 => 703, 1 => 297}
```

```perl6
say random-variate(BinomialDistribution.new(:n(10), :p(0.2)), 10); 
```
```
#ERROR: No such method 'continuos' for invocant of type
#ERROR: 'Statistics::Distributions::Defined::Binomial'
# Nil
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```
```
# (27.160386092505465 11.45339184256685 44.7822108310777 19.589622764239174 24.42576153388579)
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```
```
# (42.80507386881271 45.52570370216639 30.46189687553613 41.52131923470594 20.938161538422506)
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
```
```
# [[-1.8163317385732753 1.09570050911966 -0.10450107441456423 -1.030299173260216]
#  [1.4326799143559485 1.411448281298804 0.4167889419032486 -0.38779920694800313]
#  [-0.07959194817170769 -1.2112044997169233 0.03319807558698593 -0.5066769343464822]]
```

**Remark:** The Markdown document 
["Random-variate-generation-examples.md"](https://github.com/antononcube/Raku-Statistics-Distributions/blob/main/docs/Random-variate-generation-examples.md),
is a guide to generating random variates with the distributions of this package.

---------

## References

[AAp1] Anton Antonov
[Data::Generators Raku package](https://github.com/antononcube/Raku-Data-Generators),
(2021-2024),
[GitHub/antononcube](https://github.com/antononcube).