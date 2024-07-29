
# Statistics::Distributions

Raku package for statistical distributions and related random variates generations.

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
# 0.17541845878637907
```

Here is a random real between 0 and 20:

```perl6
say random-real(20); 
```
```
# 16.028516092944255
```

Here are six random reals between -2 and 12:

```perl6
say random-real([-2,12], 6);
```
```
# (10.890321155441887 9.250329907971087 11.221827780422139 10.947882003708111 7.443503118508962 11.315959320648535)
```

Here is a 4-by-3 array of random reals between -3 and 3:

```perl6
say random-real([-3,3], [4,3]);
```
```
# [[-1.8271015858824613 -0.9451368646135272 -1.3073987032431427]
#  [0.11530235188287286 2.58526166208536 1.8889232976832053]
#  [0.7458748437637528 0.17395147714974346 1.3111028238318596]
#  [2.4885123717852453 0.6243378945606981 -0.19171147490052398]]
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
# (1 2 2 1 2 3 1 2 4 2)
```

```perl6
say random-variate(NormalDistribution.new( µ => 10, σ => 20), 5); 
```
```
# (-26.342123946040758 13.3280212791122 24.292815398564116 24.181585941745993 9.574089558980965)
```

```perl6
say random-variate(UniformDistribution.new(:min(2), :max(60)), 5);
```
```
# (16.64454230198472 26.447351609698725 55.084471267095836 38.982409556010175 54.98503472435345)
```

**Remark:** Only Normal distribution and Uniform distribution are implemented at this point.

**Remark:** The signature design follows Mathematica's function
[`RandomVariate`](https://reference.wolfram.com/language/ref/RandomVariate.html).

Here is an example of 2D array generation:

```perl6
say random-variate(NormalDistribution.new, [3,4]);
```
```
# [[-0.30885438533910603 0.5365343568625571 -0.6755139831111151 2.1574484398482277]
#  [-0.9980568977738549 -2.2435034113979224 -0.3572811339948709 -0.2187767800023108]
#  [0.29698698195857154 0.463105948876437 -1.3438767699675596 0.7011538348300886]]
```