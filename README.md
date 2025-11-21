
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
# 0.7566029477029932
```

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```
```
# 7.782185548019564
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```
```
# (5.984218977817309 -0.7470893085067976 0.9036675312487041 2.5560218342093943 -1.910581002606549 7.685430947831199)
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
```
```
# [[-2.7840704028823544 0.8287109105292263 2.558504357563728]
#  [-1.0941755936293156 0.8651999088838096 -0.9438774646497903]
#  [1.1212043168666623 2.752612228122736 2.482152045517397]
#  [2.80676721650401 -2.970465529169304 -2.4619764627222165]]
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
# {0 => 680, 1 => 320}
```

```perl6
say random-variate(BinomialDistribution.new(:n(10), :p(0.2)), 10); 
```
```
# (1 5 3 2 2 2 8 1 1 1)
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```
```
# (-40.1003663069411 -21.037958898210185 11.71662526417637 -15.783821746585186 14.583792668629403)
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```
```
# (24.16922574013087 18.852280485082424 16.837079621903225 45.84863399963783 14.405878874364358)
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
```
```
# [[0.01191681514433013 -1.0665450738906437 0.5102179377029749 -2.2758079566657665]
#  [-1.226596770652097 -0.7170922416291008 -1.6924928241645187 -0.3585903281924563]
#  [-0.3979421974219298 -0.8014262498733147 0.21027706617767977 0.19396187939866336]]
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

[WRI1] Wolfram Research, 
[Quantile](https://reference.wolfram.com/language/ref/Quantile.html), Wolfram Language function, 
(2003), (updated 2024).