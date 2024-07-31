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
my @res = random-variate($beta, 200);

records-summary(@res);
```
```
# +-------------------------------+
# | numerical                     |
# +-------------------------------+
# | Mean   => 0.4933713295636193  |
# | 1st-Qu => 0.3844090947246037  |
# | 3rd-Qu => 0.6167605580528748  |
# | Min    => 0.07249604622942857 |
# | Median => 0.4761216744181751  |
# | Max    => 0.9689344121753427  |
# +-------------------------------+
```

```perl6
text-histogram(@res, title => 'Beta Distribution')
```
```
# Beta Distribution                      
# +----------+----------+-----------+-----------+----------+-+       
# |                                                          |       
# +                     □ □                                  +  25.00
# |                     * *                                  |       
# +                     * *                                  +  20.00
# |                     * *  □         □                     |       
# +                     * *  *    □    *                     +  15.00
# |                □ □  * *  * □  *  □ *                     |       
# +                * *  * *  * *  *  * *    □                +  10.00
# |          □  □  * *  * *  * *  *  * *    *                |       
# +        □ *  *  * *  * *  * *  *  * *  □ *                +   5.00
# |        * *  *  * *  * *  * *  *  * *  * *                |       
# +   □    * *  *  * *  * *  * *  *  * *  * *  □  □      □   +   0.00
# |                                                          |       
# +----------+----------+-----------+-----------+----------+-+       
#            0.20       0.40        0.60        0.80       1.00
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
# | Mean   => 0.583333 |
# | 1st-Qu => 0        |
# | 3rd-Qu => 1        |
# | Median => 1        |
# | Min    => 0        |
# | Max    => 1        |
# +--------------------+
```

### Discrete Uniform Distribution

[Discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) is a discrete probability distribution that takes on a finite number of values with equal probability.

```raku
my $discrete_uniform = DiscreteUniformDistribution.new(:min(10), :max(20));
my @res = random-variate($discrete_uniform, 200);

records-summary(@res);
```
```
# +--------------+
# | numerical    |
# +--------------+
# | Max    => 20 |
# | 1st-Qu => 12 |
# | Mean   => 15 |
# | 3rd-Qu => 18 |
# | Min    => 10 |
# | Median => 15 |
# +--------------+
```

```perl6
text-list-plot(@res.&tally.kv.rotor(2), title => 'Discrete Uniform Distribution tallies')
```
```
# Discrete Uniform Distribution tallies            
# +---+---------+---------+----------+---------+---------+---+       
# |                                                          |       
# |                                       *                  |       
# +        *                                                 +  25.00
# |                                                          |       
# |                                            *             |       
# +                                                          +  20.00
# |                                                 *        |       
# |   *         *         *          *                       |       
# |                                                          |       
# +                            *                             +  15.00
# |                                                      *   |       
# |                  *                                       |       
# +                                                          +  10.00
# +---+---------+---------+----------+---------+---------+---+       
#     10.00     12.00     14.00      16.00     18.00     20.00
```

### Normal Distribution

[Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) is a continuous probability distribution that is defined by two parameters, the mean and the standard deviation. The normal distribution is also known as the Gaussian distribution.

```raku
my $normal = NormalDistribution.new(:mean(10), :sd(2));
my @res = random-variate($normal, 200);

records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | Min    => 4.717058781945211  |
# | Mean   => 9.945278573794406  |
# | 3rd-Qu => 11.382490722586429 |
# | Max    => 15.066827262353309 |
# | 1st-Qu => 8.63330161702207   |
# | Median => 9.931032883779704  |
# +------------------------------+
```

```perl6
text-histogram(@res, title => 'Normal Distribution')
```
```
# Normal Distribution                     
# +---------+---------+---------+---------+---------+--------+       
# |                                                          |       
# |                       □       □                          |       
# +                       *       *                          +  20.00
# |                  □    *    □  *    □                     |       
# +                  *  □ *  □ *  *    *                     +  15.00
# |                  *  * *  * *  *  □ *  □                  |       
# |                  *  * *  * *  *  * *  *                  |       
# +                □ *  * *  * *  *  * *  *                  +  10.00
# |             □  * *  * *  * *  *  * *  * □  □             |       
# +          □  *  * *  * *  * *  *  * *  * *  *             +   5.00
# |   □ □  □ *  *  * *  * *  * *  *  * *  * *  *  □    □     |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  * □  * □   +   0.00
# |                                                          |       
# +---------+---------+---------+---------+---------+--------+       
#           6.00      8.00      10.00     12.00     14.00
```

### Uniform Distribution

[Uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)) is a continuous probability distribution that is defined by two parameters, the minimum and the maximum. The uniform distribution is also known as the rectangular distribution.

```raku
my $uniform = UniformDistribution.new(:min(-10), :max(5));
my @res = random-variate($uniform, 200);

records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | 1st-Qu => -6.138998899203754 |
# | Min    => -9.992336384814417 |
# | 3rd-Qu => 0.9587773392229311 |
# | Median => -2.60046162992163  |
# | Mean   => -2.653097771031485 |
# | Max    => 4.966623004322626  |
# +------------------------------+
```

```perl6
text-histogram(@res, title => 'Uniform Distribution')
```
```
# Uniform Distribution                    
# +---+----------------+----------------+----------------+---+       
# |                                                          |       
# |   □            □           □       □          □          |       
# |   *            *    □ □  □ *       *       □  *          |       
# +   *      □  □  *    * *  * *     □ *  □    *  *          +  10.00
# |   * □    *  *  *    * *  * *     * *  *    *  * □        |       
# |   * *    *  *  * □  * *  * *  □  * *  *    *  * *        |       
# |   * *  □ *  *  * *  * *  * *  *  * *  * □  *  * *        |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *        +   5.00
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *        |       
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  □     |       
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  * □   +   0.00
# |                                                          |       
# +---+----------------+----------------+----------------+---+       
#     -10.00           -5.00            0.00             5.00
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
# +------------------------------+------------------------------+
# | 0                            | 1                            |
# +------------------------------+------------------------------+
# | Min    => 3.126845329726824  | Min    => 0.5669495165957725 |
# | 1st-Qu => 6.796151847845332  | 1st-Qu => 2.944060696125733  |
# | Mean   => 9.92700023359102   | Mean   => 4.4038168050578985 |
# | Median => 9.96620699701577   | Median => 4.4678447070721745 |
# | 3rd-Qu => 12.097628186652472 | 3rd-Qu => 5.7560359097338685 |
# | Max    => 19.607603457253706 | Max    => 8.915840675765043  |
# +------------------------------+------------------------------+
```

```perl6
text-list-plot(@res, width => 60, height => 20, title => 'Binormal Distribution random variates')
```
```
# Binormal Distribution random variates            
# +--------+---------------+---------------+---------------+-+      
# |                                                          |      
# |                                                      *   |      
# |                                                          |      
# +                         *                                +  8.00
# |                        *    *                            |      
# |                          *   *      *                    |      
# +                           *  *                           +  6.00
# |                  *            *          *               |      
# |                     *        *   **                  *   |      
# |   **                      *                       *      |      
# +                    *   *                                 +  4.00
# |       *     **          *         *                      |      
# |        *              *                                  |      
# |     *     *  *   *                                       |      
# +               *                                          +  2.00
# |         *           *                                    |      
# |    *                                                     |      
# +                                                          +  0.00
# +--------+---------------+---------------+---------------+-+      
#          5.00            10.00           15.00           20.00
```

-----

## Derived Distributions

### Mixture Distribution

[Mixture distribution](https://en.wikipedia.org/wiki/Mixture_distribution) is a probability distribution that is a weighted sum of two or more other probability distributions.

```raku
my $mixture = MixtureDistribution.new([2, 5], [NormalDistribution.new(3, 4), NormalDistribution.new(16, 5)]);
my @res = random-variate($mixture, 300);

records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | Max    => 29.97988072254067  |
# | 1st-Qu => 5.625553940978383  |
# | 3rd-Qu => 17.64796620872335  |
# | Median => 12.818222578426187 |
# | Min    => -7.442778967486351 |
# | Mean   => 11.707767528338996 |
# +------------------------------+
```

```perl6
text-histogram(@res, title => 'Mixture Distribution', width => 80)
```
```
# Mixture Distribution                              
# +-----------------+------------------+------------------+-----------------+----+       
# |                                                                              |       
# +                                          □  □                                +  30.00
# |                                      □   *  *   □                            |       
# +                                      *   *  *   *                            +  25.00
# |                                      *   *  *   *                            |       
# |                                      *   *  *   *                            |       
# +                                      *   *  *   *      □                     +  20.00
# |                        □      □   □  *   *  *   *      *                     |       
# |                     □  *   □  *   *  *   *  *   *  □   *                     |       
# +                     *  *   *  *   *  *   *  *   *  *   *                     +  15.00
# |                 □   *  *   *  *   *  *   *  *   *  *   *  □                  |       
# +              □  *   *  *   *  *   *  *   *  *   *  *   *  *                  +  10.00
# |              *  *   *  *   *  *   *  *   *  *   *  *   *  *   □              |       
# |       □  □   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *              |       
# +   □   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *              +   5.00
# |   *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  □           |       
# +   *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *      □    +   0.00
# |                                                                              |       
# +-----------------+------------------+------------------+-----------------+----+       
#                   0.00               10.00              20.00             30.00
```

### Product Distribution

[Product distribution](https://en.wikipedia.org/wiki/Product_distribution) is a probability distribution that is the product of two or more other probability distributions.

```raku
my $product = ProductDistribution.new([NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($product, 60);

records-summary(@res, field-names => ['0', '1']);
```
```
# +------------------------------+------------------------------+
# | 0                            | 1                            |
# +------------------------------+------------------------------+
# | Min    => -4.16776860721348  | Min    => -9.377737554909633 |
# | 1st-Qu => 1.0168330466759363 | 1st-Qu => 2.874748295461403  |
# | Mean   => 3.238636694793194  | Mean   => 6.092095526592996  |
# | Median => 2.998735983735804  | Median => 6.578421106674605  |
# | 3rd-Qu => 5.86664338890022   | 3rd-Qu => 9.853530032695765  |
# | Max    => 12.084239335313105 | Max    => 22.529073896534314 |
# +------------------------------+------------------------------+
```

```perl6
text-list-plot(@res, width => 60, height => 20, title => "Product Distribution random variates")
```
```
# Product Distribution random variates            
# ++---------------+---------------+---------------+---------+       
# |                                                          |       
# |                   *                                      |       
# +                                                          +  20.00
# |                                                          |       
# |                                            *             |       
# |             *  *                  *                      |       
# |                   *  *  *     * *                        |       
# +              *     *   ***    *   *       *          *   +  10.00
# |   *  *        *     *  *  *   *  *        *    *         |       
# |                       *  *    *   ***                    |       
# |           *   *    *  *   * * * *  *                 *   |       
# |                        *  * *              *             |       
# +   *   * *                          *                     +   0.00
# |                        *            *                    |       
# |     *                 *                                  |       
# |                                                          |       
# |            *                                             |       
# +                                                          + -10.00
# ++---------------+---------------+---------------+---------+       
#  -5.00           0.00            5.00            10.00
```

--------

## References

[AAp1] Anton Antonov
[Statistics::Distributions Raku package](https://github.com/antononcube/Raku-Statistics-Distributions),
(2024),
[GitHub/antononcube](https://github.com/antononcube).