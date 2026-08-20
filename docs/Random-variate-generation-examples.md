# Random variate generation examples

## Introduction

This document is a concise guide for generating random variates with the probability distributions
of the Raku package ["Statistics::Distributions"](https://raku.land/zef:antononcube/Statistics::Distributions), [AAp1].    

---

## Setup

```raku
use Statistics::Distributions;
use Data::Summarizers;
use Data::Translators;
use Text::Plot;
```
```
# (Any)
```

---

## Univariate discrete distributions

### Benford Distribution

[Benford's law](https://en.wikipedia.org/wiki/Benford%27s_law), also known as the Newcomb–Benford law, the law of anomalous numbers, or the first-digit law, is an observation that in many real-life sets of numerical data, the ***leading digit*** is likely to be small. Here the Benoford Distribution is computed for a given number base:

```raku
my $benford = BenfordDistribution.new(12);
my @res = random-variate($benford, 2_000);

@res.Bag.Hash
```
```
# {1 => 555, 10 => 78, 11 => 67, 2 => 347, 3 => 218, 4 => 190, 5 => 152, 6 => 123, 7 => 100, 8 => 88, 9 => 82}
```

```raku
text-histogram(@res, :60width, :16height, title => 'Benford Distribution')
```
```
# Benford Distribution                    
# +--------+---------+---------+----------+---------+--------+        
# +                                                          +  600.00
# |   □                                                      |        
# +   *                                                      +  500.00
# |   *                                                      |        
# +   *                                                      +  400.00
# |   *    □                                                 |        
# +   *    *                                                 +  300.00
# |   *    *                                                 |        
# +   *    *    □    □                                       +  200.00
# |   *    *    *    *    □                                  |        
# +   *    *    *    *    *    □     □                       +  100.00
# |   *    *    *    *    *    *     *    □    □    □    □   |        
# +   *    *    *    *    *    *     *    *    *    *    *   +    0.00
# |                                                          |        
# +--------+---------+---------+----------+---------+--------+        
#          2.00      4.00      6.00       8.00      10.00
```


### Binomial Distribution

[Binomial distribution](https://en.wikipedia.org/wiki/Binomial_distribution) models the number of successes in a fixed number of independent trials with the same success probability.

```raku
my $binomial = BinomialDistribution.new(12, 0.35);
my @res = random-variate($binomial, 200);

sink records-summary(@res);
```
```
# +-----------------+
# | numerical       |
# +-----------------+
# | 1st-Qu => 3     |
# | Max    => 9     |
# | Min    => 1     |
# | Median => 4     |
# | Mean   => 4.165 |
# | 3rd-Qu => 5     |
# +-----------------+
```

```raku
text-list-plot(@res.&tally.kv.rotor(2), title => 'Binomial Distribution tallies')
```
```
# Binomial Distribution tallies                
# +---------+------------+------------+------------+---------+       
# |                                                          |       
# +                      *                                   +  50.00
# |                *                                         |       
# +                                                          +  40.00
# |                                                          |       
# +                            *      *                      +  30.00
# |                                                          |       
# +                                                          +  20.00
# |         *                                                |       
# +   *                                     *                +  10.00
# |                                                          |       
# |                                                *     *   |       
# +                                                          +   0.00
# +---------+------------+------------+------------+---------+       
#           2.00         4.00         6.00         8.00
```

### Bernoulli Distribution

[Bernoulli distribution](https://en.wikipedia.org/wiki/Bernoulli_distribution) is a discrete probability distribution that takes the value 1 with probability p and the value 0 with probability 1-p.

```raku
my $bernoulli = BernoulliDistribution.new(0.5);
my @res = random-variate($bernoulli, 12);

sink records-summary(@res);
```
```
# +--------------------+
# | numerical          |
# +--------------------+
# | Median => 0        |
# | Mean   => 0.333333 |
# | 3rd-Qu => 1        |
# | 1st-Qu => 0        |
# | Min    => 0        |
# | Max    => 1        |
# +--------------------+
```

### Discrete Uniform Distribution

[Discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) is a discrete probability distribution that takes on a finite number of values with equal probability.

```raku
my $discrete_uniform = DiscreteUniformDistribution.new(10, 20);
my @res = random-variate($discrete_uniform, 200);

sink records-summary(@res);
```
```
# +-----------------+
# | numerical       |
# +-----------------+
# | Median => 15    |
# | 1st-Qu => 13    |
# | 3rd-Qu => 18    |
# | Mean   => 15.31 |
# | Min    => 10    |
# | Max    => 20    |
# +-----------------+
```

```raku
text-list-plot(@res.&tally.kv.rotor(2), title => 'Discrete Uniform Distribution tallies')
```
```
# Discrete Uniform Distribution tallies            
# +---+---------+---------+----------+---------+---------+---+       
# |                                                          |       
# +             *                                            +  25.00
# |                                  *              *    *   |       
# |                       *                                  |       
# +                                                          +  20.00
# |                  *                                       |       
# |                                       *                  |       
# +   *                        *               *             +  15.00
# |                                                          |       
# |                                                          |       
# +                                                          +  10.00
# |        *                                                 |       
# |                                                          |       
# +---+---------+---------+----------+---------+---------+---+       
#     10.00     12.00     14.00      16.00     18.00     20.00
```

---

## Univariate continuous distributions

### Beta Distribution

```raku
my $beta = BetaDistribution.new(4, 4);
my @res = random-variate($beta, 200);

sink records-summary(@res);
```
```
# +-------------------------------+
# | numerical                     |
# +-------------------------------+
# | Mean   => 0.5030778489116787  |
# | 3rd-Qu => 0.6228878546035261  |
# | Min    => 0.09753787653552694 |
# | Median => 0.5046959546037088  |
# | 1st-Qu => 0.37077386309644705 |
# | Max    => 0.8648500970681303  |
# +-------------------------------+
```

```raku
text-histogram(@res, title => 'Beta Distribution')
```
```
# Beta Distribution                      
# +---------+-------------+------------+-------------+-------+       
# |                                                          |       
# |                          □ □     □                       |       
# +                  □       * *  □  *                       +  15.00
# |                  *       * *  *  *                       |       
# |                □ *    □  * *  *  * □  □    □             |       
# +                * *  □ *  * *  *  * *  *    *             +  10.00
# |                * *  * *  * *  *  * *  *    *             |       
# |          □  □  * *  * *  * *  *  * *  * □  *    □        |       
# +          *  *  * *  * *  * *  *  * *  * *  *    *        +   5.00
# |          *  *  * *  * *  * *  *  * *  * *  *    *  □     |       
# |   □ □  □ *  *  * *  * *  * *  *  * *  * *  *    *  *     |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  □ *  * □   +   0.00
# |                                                          |       
# +---------+-------------+------------+-------------+-------+       
#           0.20          0.40         0.60          0.80
```

### Normal Distribution

[Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) is a continuous probability distribution specified here by its mean and standard deviation.

```raku
my $normal = NormalDistribution.new(10, 2);
my @res = random-variate($normal, 200);

sink records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | 3rd-Qu => 11.063805407911266 |
# | Max    => 14.517732325450073 |
# | Mean   => 9.910492218580673  |
# | Min    => 3.0907644609554277 |
# | 1st-Qu => 8.649101287583433  |
# | Median => 9.987517663625376  |
# +------------------------------+
```

```raku
text-histogram(@res, title => 'Normal Distribution')
```
```
# Normal Distribution                     
# +-------+--------+--------+--------+--------+--------+-----+       
# +                                                          +  30.00
# |                                    □                     |       
# +                               □  □ *                     +  25.00
# |                               *  * *                     |       
# +                               *  * *  □                  +  20.00
# |                          □ □  *  * *  *                  |       
# +                       □  * *  *  * *  *                  +  15.00
# |                       *  * *  *  * *  * □                |       
# +                     □ *  * *  *  * *  * *                +  10.00
# |                  □  * *  * *  *  * *  * *  □  □          |       
# +                □ *  * *  * *  *  * *  * *  *  *          +   5.00
# +   □      □  □  * *  * *  * *  *  * *  * *  *  * □  □ □   +   0.00
# |                                                          |       
# +-------+--------+--------+--------+--------+--------+-----+       
#         4.00     6.00     8.00     10.00    12.00    14.00
```


### Uniform distribution

```raku
my @res = random-variate(UniformDistribution.new(-10, 5), 1_000);
sink records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | 3rd-Qu => 1.304644846344135  |
# | 1st-Qu => -6.158788528823244 |
# | Mean   => -2.424862807994599 |
# | Min    => -9.98217798530156  |
# | Median => -2.532800195342364 |
# | Max    => 4.994316752722238  |
# +------------------------------+
```

```raku
text-histogram(@res, title => 'Uniform Distribution')
```
```
# Uniform Distribution                    
# +---+----------------+----------------+----------------+---+       
# |                                                          |       
# +                       □                 □                +  60.00
# |          □       □  □ *       □         *          □     |       
# |          *  □  □ *  * *       *    □  □ *          *     |       
# |   □ □  □ *  *  * *  * *    □  *  □ *  * *  □  □ □  *     |       
# +   * *  * *  *  * *  * *  □ *  *  * *  * *  *  * *  *     +  40.00
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     |       
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     +  20.00
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     |       
# |   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  *     |       
# +   * *  * *  *  * *  * *  * *  *  * *  * *  *  * *  * □   +   0.00
# |                                                          |       
# +---+----------------+----------------+----------------+---+       
#     -10.00           -5.00            0.00             5.00
```

### Additional univariate continuous distributions

```raku
my @continuous-examples =
    ChiSquareDistribution.new(4),
    ExponentialDistribution.new(1.5),
    ExtremeValueDistribution.new(0, 1),
    FrechetDistribution.new(2, 1),
    GammaDistribution.new(2, 1),
    GumbelDistribution.new(0, 1),
    MaxStableDistribution.new(0, 1, 0.2),
    MinStableDistribution.new(0, 1, 0.2),
    RayleighDistribution.new(1),
    StudentTDistribution.new(5, 0, 1),
    WeibullDistribution.new(5, 2)
;

.say for @continuous-examples
```
```
# ChiSquare(:nu(4),)
# Exponential(:lambda(1.5),)
# ExtremeValue(:scale(1), :location(0))
# Frechet(:a(2), :b(1), :m(0))
# Gamma(:b(1), :a(2))
# Gumbel(:scale(1), :location(0))
# MaxStable(:sigma(1), :mu(0), :xi(0.2))
# MinStable(:mu(0), :xi(0.2), :sigma(1))
# Rayleigh(:sigma(1),)
# StudentT(:mean(0), :nu(5), :sd(1))
# Weibull(:shape(5), :scale(2), :location(0))
```

---

## Multivariate Distributions

### Binormal Distribution

[Binormal distribution](https://mathworld.wolfram.com/BivariateNormalDistribution.html) represents a bivariate normal distribution with mean `[μ1, μ2]` 
and covariance matrix `[[σ1 ** 2, ρ * σ1 * σ2], [ρ * σ1 * σ2, σ2 **2]]`.

```raku
my $binormal = BinormalDistribution.new([10, 4], [4, 2], 0.5);
my @res = random-variate($binormal, 400);

sink records-summary(@res, field-names => ['0', '1']);
```
```
# +------------------------------+-------------------------------+
# | 0                            | 1                             |
# +------------------------------+-------------------------------+
# | Min    => -2.991350839903541 | Min    => -0.6098906860468496 |
# | 1st-Qu => 6.908936888787485  | 1st-Qu => 2.84432121975547    |
# | Mean   => 9.907156590002224  | Mean   => 4.021442254831485   |
# | Median => 10.04670871662551  | Median => 4.097568770002619   |
# | 3rd-Qu => 12.823420810481926 | 3rd-Qu => 5.30826917362687    |
# | Max    => 22.216495363514756 | Max    => 9.462755399405959   |
# +------------------------------+-------------------------------+
```

```raku
text-list-plot(@res, width => 60, height => 20, title => 'Binormal Distribution random variates')
```
```
# Binormal Distribution random variates            
# +---------+---------+---------+---------+----------+-------+      
# +                                                          + 10.00
# |                                  *                       |      
# |                              *         *      *          |      
# +                      *            ***    *      * *      +  8.00
# |                                   **     * *         *   |      
# |                   ** *    ** * *  ** ****  *   *         |      
# +           *       *    *  *** * ****  * * ** ***         +  6.00
# |                 *     ** *** ********** *  *   *         |      
# |                 * * **********************  *            |      
# +               ** **********************  *  *            +  4.00
# |            * ****** ********** *******  *  **            |      
# |   *   *   *   *  ****  *************   **                |      
# +           **** * **********  ****   *                    +  2.00
# |             **  * ******* *    * * *                     |      
# |       *    *  *   ** *     **                            |      
# +         * *       *** * * *     **                       +  0.00
# |          *       * **   **  *                            |      
# |                                                          |      
# +---------+---------+---------+---------+----------+-------+      
#           0.00      5.00      10.00     15.00      20.00
```

---

## Derived Distributions

### Mixture Distribution

[Mixture distribution](https://en.wikipedia.org/wiki/Mixture_distribution) is a probability distribution that is a weighted sum of two or more other probability distributions.

```raku
my $mixture = MixtureDistribution.new([2, 5], [NormalDistribution.new(3, 4), NormalDistribution.new(16, 5)]);
my @res = random-variate($mixture, 300);

sink records-summary(@res);
```
```
# +------------------------------+
# | numerical                    |
# +------------------------------+
# | Mean   => 12.513441750836648 |
# | 3rd-Qu => 18.167117228841796 |
# | Min    => -8.577861474267486 |
# | Median => 13.540437775592846 |
# | Max    => 27.480955837414307 |
# | 1st-Qu => 6.6389503602837685 |
# +------------------------------+
```

```raku
text-histogram(@res, title => 'Mixture Distribution', width => 80)
```
```
# Mixture Distribution                              
# +-+------------------+------------------+-------------------+------------------+       
# +                                                                              +  40.00
# |                                                 □                            |       
# |                                                 *                            |       
# |                                          □      *                            |       
# +                                          *  □   *                            +  30.00
# |                                          *  *   *                            |       
# |                                          *  *   *  □   □                     |       
# |                                          *  *   *  *   *                     |       
# +                        □                 *  *   *  *   *                     +  20.00
# |                        *             □   *  *   *  *   *                     |       
# |                        *   □         *   *  *   *  *   *  □                  |       
# |                     □  *   *         *   *  *   *  *   *  *                  |       
# +                     *  *   *  □      *   *  *   *  *   *  *   □              +  10.00
# |              □  □   *  *   *  *   □  *   *  *   *  *   *  *   *  □   □       |       
# |              *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *       |       
# |   □      □   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *       |       
# +   *      *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  *   *  □    +   0.00
# |                                                                              |       
# +-+------------------+------------------+-------------------+------------------+       
#   -10.00             0.00               10.00               20.00
```

### Product Distribution

[Product distribution](https://en.wikipedia.org/wiki/Product_distribution) is a probability distribution that is the product of two or more other probability distributions.

```raku
my $product = ProductDistribution.new([NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($product, 600);

sink records-summary(@res, field-names => ['0', '1']);
```
```
# +------------------------------+-------------------------------+
# | 0                            | 1                             |
# +------------------------------+-------------------------------+
# | Min    => -9.776010152503188 | Min    => -10.888352537691699 |
# | 1st-Qu => 0.4237206856670894 | 1st-Qu => 2.4395541096219544  |
# | Mean   => 2.9447566818538364 | Mean   => 6.062719838698967   |
# | Median => 2.7728338701097837 | Median => 6.246981287221402   |
# | 3rd-Qu => 5.335236342999617  | 3rd-Qu => 9.668987967664197   |
# | Max    => 16.327019068775755 | Max    => 20.29816630342989   |
# +------------------------------+-------------------------------+
```

```raku
text-list-plot(@res, width => 60, height => 20, title => "Product Distribution random variates")
```
```
# Product Distribution random variates            
# +--+---------+---------+---------+---------+---------+-----+       
# |                                                          |       
# +                    *    *                                +  20.00
# |                       *  *   *  *                        |       
# +                    * * **** * * *** ***                  +  15.00
# |        *   *    ********** * *** ***  *  **    *         |       
# |              ****  ************* *** * * *  *            |       
# +   *         * * ************************ **              +  10.00
# |        * *  *  ********************* ****                |       
# +                ************************** * **           +   5.00
# |           * **  ******************** ** * ***        *   |       
# |           **    ****************** **** *   *  *         |       
# +              ****   ** ** * **********  *  *  *          +   0.00
# |                   *  ***   *** ***  *  *                 |       
# +              *  * ** ********   *                        +  -5.00
# |                **          *   *    *                    |       
# |                               **                         |       
# +                                    *                     + -10.00
# |                                                          |       
# +--+---------+---------+---------+---------+---------+-----+       
#    -10.00    -5.00     0.00      5.00      10.00     15.00
```

---

## References

[AAp1] Anton Antonov
[Statistics::Distributions Raku package](https://github.com/antononcube/Raku-Statistics-Distributions),
(2024),
[GitHub/antononcube](https://github.com/antononcube).