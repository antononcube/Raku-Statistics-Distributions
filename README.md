
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
# 0.7592622521457041
```

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```
```
# 13.75622740821709
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```
```
# (3.0033123181565013 7.113524502384845 7.819889667003045 4.667762071569815 2.2293977432836787 4.62552640792827)
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
```
```
# [[0.8962887169094373 0.8475392360917491 1.0010550608069124]
#  [-1.9147288691032502 -0.0015343761906390085 -2.9979319508996576]
#  [-1.671356089026771 2.6005681211674636 -2.6841480871096164]
#  [-2.8547683653645812 -0.19887668521620405 -0.3428770060549846]]
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
# {0 => 682, 1 => 318}
```

```perl6
say random-variate(BinomialDistribution.new(:n(10), :p(0.2)), 10); 
```
```
# (1 3 1 0 4 4 2 2 1 2)
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```
```
# (12.902823669355172 -13.257944841859484 -1.4868291672787866 0.2038154783934356 24.267632487527415)
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```
```
# (24.785346324895734 49.08911592317513 23.839282487269333 11.76219519981244 29.1045406261129)
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
```
```
# [[0.9640921640530472 -1.6220259520074567 -2.232915785778588 0.7428103187276472]
#  [-0.12436431748435604 2.272534039830153 -0.4204602985182264 -0.1257869441808453]
#  [-1.8250762803050216 1.9181693324456424 -0.8693291565656599 0.8154730584189308]]
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