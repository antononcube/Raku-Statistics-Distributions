
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
# 0.2648172284212543
```

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```
```
# 1.2875186780444325
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```
```
# (3.2369131874660066 5.39485807111193 4.470341296740869 1.9335527139327446 8.905389421401035 1.4785795439826508)
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
```
```
# [[2.2958483330833435 -1.6854152133675826 1.4980508866633624]
#  [0.51928324915044 -1.2428543097404838 2.6216356688479827]
#  [-1.357097078170273 2.479070128679827 2.640907979854263]
#  [0.39403163270231456 0.5903821422975302 -1.249547711122104]]
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
# {0 => 685, 1 => 315}
```

```perl6
say random-variate(BinomialDistribution.new(:n(10), :p(0.2)), 10); 
```
```
# (5 1 1 1 2 5 2 2 0 0)
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```
```
# (37.07491432901547 -9.936366460627067 31.885573558248964 12.046261466201003 17.926815678395453)
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```
```
# (53.78944978581162 2.263038773916679 29.945681003572002 6.231566671723097 34.02741653286391)
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
```
```
# [[-0.9536215397665416 -0.8036702489549027 -0.3557683312663461 0.4389959577952899]
#  [0.6619205255405533 -1.9602216024358354 -0.2749948547456336 0.46802735787659044]
#  [0.32220275072198645 1.8284593058542338 0.46303694481100555 -0.6999232613237505]]
```

**Remark:** The Markdown document 
["Random-variate-generation-examples.md"](https://github.com/antononcube/Raku-Statistics-Distributions/blob/main/docs/Random-variate-generation-examples.md),
is a guide to generating random variates with the distributions of this package.

---------

## Quantile calculations with different methods 

The sub `quantile` provided by the package can take parameters that cover 10 different methods commonly used in
statistics. (That is similar to [`Quantile`](https://reference.wolfram.com/language/ref/Quantile.html), [WRI1], of Wolfram Language.)

For example:


```raku
my @values = 3.2, 1.5, 7.8, 4.1, 9.9, 2.3, 6.5, 0.8, 5.5, 8.7;
quantile(@values, probs => (0.2, 0.4 ... 0.8), params => [[0,1],[0,1]])
```
```
# [1.66 3.56 6.1 8.52]
```

---------

## References

[AAp1] Anton Antonov
[Data::Generators Raku package](https://github.com/antononcube/Raku-Data-Generators),
(2021-2024),
[GitHub/antononcube](https://github.com/antononcube).

[WRI1] Wolfram Research (2003), [Quantile](https://reference.wolfram.com/language/ref/Quantile.html), Wolfram Language function, (updated 2024).