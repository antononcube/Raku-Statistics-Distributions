
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

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
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

```perl6
say random-variate(BinomialDistribution.new(:n(10), :p(0.2)), 10); 
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
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