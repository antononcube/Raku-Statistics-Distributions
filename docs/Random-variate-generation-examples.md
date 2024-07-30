# Random variate generation examples

## Introduction

This document is a concise guide for generating random variates with the probability distributions
of the Raku package ["Statistics::Distributions"](https://raku.land/zef:antononcube/Statistics::Distributions), [AAp1].    

---------

## Setup

```raku
use Statistics::Distributions;
use Data::Summarizers;
use Text::Plot;
```
```
# (Any)
```

--------

## Univariate Distributions

### Beta Distribution

[Beta distribution](https://en.wikipedia.org/wiki/Beta_distribution) is a continuous probability distribution that is defined by two parameters, alpha and beta. The beta distribution is often used to model proportions.

```raku
my $beta = BetaDistribution.new(4, 4);
my @res = random-variate($beta, 12);

records-summary(@res);
```
```
# +-------------------------------+
# | numerical                     |
# +-------------------------------+
# | 3rd-Qu => 0.6354517537329725  |
# | 1st-Qu => 0.395712322153205   |
# | Max    => 0.7404134631960042  |
# | Min    => 0.07647331780511796 |
# | Median => 0.5288159916087873  |
# | Mean   => 0.48781199877425746 |
# +-------------------------------+
```

### Bernoulli Distribution

[Bernoulli distribution](https://en.wikipedia.org/wiki/Bernoulli_distribution) is a discrete probability distribution that takes the value 1 with probability p and the value 0 with probability 1-p.

```raku
my $bernoulli = BernoulliDistribution.new(:p(0.5));
my @res = random-variate($bernoulli, 12);

records-summary(@res);
```
```
# +--------------------+
# | numerical          |
# +--------------------+
# | Max    => 1        |
# | 3rd-Qu => 1        |
# | 1st-Qu => 0        |
# | Min    => 0        |
# | Median => 1        |
# | Mean   => 0.583333 |
# +--------------------+
```

### Discrete Uniform Distribution

[Discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) is a discrete probability distribution that takes on a finite number of values with equal probability.

```raku
my $discrete_uniform = DiscreteUniformDistribution.new(:min(10), :max(20));
my @res = random-variate($discrete_uniform, 12);

records-summary(@res);
```
```
# +--------------+
# | numerical    |
# +--------------+
# | 1st-Qu => 12 |
# | Median => 15 |
# | Max    => 20 |
# | Min    => 10 |
# | 3rd-Qu => 18 |
# | Mean   => 15 |
# +--------------+
```

### Normal Distribution

[Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) is a continuous probability distribution that is defined by two parameters, the mean and the standard deviation. The normal distribution is also known as the Gaussian distribution.

```raku
my $normal = NormalDistribution.new(:mean(10), :sd(20));
my @res = random-variate($normal, 12);

records-summary(@res);
```
```
# +-------------------------------+
# | numerical                     |
# +-------------------------------+
# | 3rd-Qu => 22.40913868155603   |
# | Min    => -8.094326273822894  |
# | Mean   => 12.03513538794197   |
# | Median => 13.381224250313508  |
# | Max    => 38.530719872408795  |
# | 1st-Qu => -2.7572891411053986 |
# +-------------------------------+
```

### Uniform Distribution

[Uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)) is a continuous probability distribution that is defined by two parameters, the minimum and the maximum. The uniform distribution is also known as the rectangular distribution.

```raku
my $uniform = UniformDistribution.new(:min(10), :max(20));
my @res = random-variate($uniform, 12);

records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | Min    => 10.223641488138387 |
# | 1st-Qu => 11.253778930578799 |
# | Mean   => 13.619467604000626 |
# | 3rd-Qu => 15.926927547415644 |
# | Max    => 18.060083051759637 |
# | Median => 12.957642644854175 |
# +------------------------------+
```


----

## Multivariate Distributions

### Binormal Distribution

[Binormal distribution](https://mathworld.wolfram.com/BivariateNormalDistribution.html) represents a bivariate normal distribution with mean `[μ1, μ2]` 
and covariance matrix `[[σ1 ** 2, ρ * σ1 * σ2], [ρ * σ1 * σ2, σ2 **2]]`.

```raku
my $binormal = BinormalDistribution.new([10, 4], [4, 2], 0.5);
my @res = random-variate($binormal, 40);

records-summary(@res, field-names => ['0', '1']);
```
```
# +------------------------------+---------------------------------+
# | 0                            | 1                               |
# +------------------------------+---------------------------------+
# | Min    => 2.0462139564235198 | Min    => -0.015654800560360727 |
# | 1st-Qu => 8.089504296358111  | 1st-Qu => 2.58463177879516      |
# | Mean   => 10.51006508114138  | Mean   => 3.993235060097683     |
# | Median => 10.230099644208302 | Median => 3.641919091633077     |
# | 3rd-Qu => 12.606909614445286 | 3rd-Qu => 5.046944959253183     |
# | Max    => 19.805765198890008 | Max    => 7.726785969554532     |
# +------------------------------+---------------------------------+
```

```perl6
text-list-plot(@res, width => 60, height => 20)
```
```
# +-----------+--------------+-------------+--------------+--+      
# +                                                          +  8.00
# |                         *                   *  *         |      
# |                          *                 *         *   |      
# |                           * *                            |      
# +                                                          +  6.00
# |                     *                                    |      
# |                               *           *    *         |      
# |                       *      *                           |      
# +                     *             *     *                +  4.00
# |                        *        *                        |      
# |     *          * * *        * **  *                      |      
# |   *                *            *                        |      
# +          *                      *                        +  2.00
# |           *  *   *   *                                   |      
# |              *                                           |      
# |                                                          |      
# +                       *                                  +  0.00
# |                                                          |      
# +-----------+--------------+-------------+--------------+--+      
#             5.00           10.00         15.00          20.00
```

-----

## Derived Distributions

### Mixture Distribution

[Mixture distribution](https://en.wikipedia.org/wiki/Mixture_distribution) is a probability distribution that is a weighted sum of two or more other probability distributions.

```raku
my $mixture = MixtureDistribution.new([2, 5], [NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($mixture, 12);

records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | 3rd-Qu => 10.13275896441319  |
# | Min    => 0.3634022697891579 |
# | Median => 8.092637927717053  |
# | 1st-Qu => 5.058839547802004  |
# | Max    => 11.624028287385617 |
# | Mean   => 7.505039300213447  |
# +------------------------------+
```

### Product Distribution

[Product distribution](https://en.wikipedia.org/wiki/Product_distribution) is a probability distribution that is the product of two or more other probability distributions.

```raku
my $product = ProductDistribution.new([NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($product, 60);

records-summary(@res, field-names => ['0', '1']);
```
```
# +-------------------------------+------------------------------+
# | 0                             | 1                            |
# +-------------------------------+------------------------------+
# | Min    => -8.92006839783217   | Min    => -4.309729749770877 |
# | 1st-Qu => 0.28893474502928274 | 1st-Qu => 2.7392688656027557 |
# | Mean   => 3.2435724126105816  | Mean   => 6.169088677904847  |
# | Median => 2.984125205327054   | Median => 5.839376141231427  |
# | 3rd-Qu => 5.927715532785814   | 3rd-Qu => 10.009459580920913 |
# | Max    => 14.835662523053854  | Max    => 14.493227204611797 |
# +-------------------------------+------------------------------+
```

```perl6
text-list-plot(@res, width => 60, height => 20)
```
```
# ++----------+----------+----------+----------+----------+--+       
# +                                                          +  15.00
# |                     *       *     *                      |       
# |                 * *        *                             |       
# |              *           *  *            *               |       
# +                         *  *   **                        +  10.00
# |                     *       *                            |       
# |                    *    *  *         *                   |       
# |                      **   *       * *                    |       
# |                *        * ** ** * *   *              *   |       
# +                      *    *                              +   5.00
# |                        * *     *                         |       
# |                * *  *                 * **               |       
# |                                 *     *                  |       
# +               *             *            *               +   0.00
# |                               *            *             |       
# |                                                      *   |       
# |   *                                                      |       
# +                                                          +  -5.00
# ++----------+----------+----------+----------+----------+--+       
#  -10.00     -5.00      0.00       5.00       10.00      15.00
```

--------

## References

[AAp1] Anton Antonov
[Statistics::Distributions Raku package](https://github.com/antononcube/Raku-Statistics-Distributions),
(2024),
[GitHub/antononcube](https://github.com/antononcube).