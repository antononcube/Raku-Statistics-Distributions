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

---

## Univariate discrete distributions

### Benford Distribution

[Benford's law](https://en.wikipedia.org/wiki/Benford%27s_law), also known as the Newcomb–Benford law, the law of anomalous numbers, or the first-digit law, is an observation that in many real-life sets of numerical data, the ***leading digit*** is likely to be small. Here the Benoford Distribution is computed for a given number base:

```raku
my $benford = BenfordDistribution.new(12);
my @res = random-variate($benford, 2_000);

@res.Bag.Hash
```

```raku
text-histogram(@res, :60width, :16height, title => 'Benford Distribution')
```


### Binomial Distribution

[Binomial distribution](https://en.wikipedia.org/wiki/Binomial_distribution) models the number of successes in a fixed number of independent trials with the same success probability.

```raku
my $binomial = BinomialDistribution.new(12, 0.35);
my @res = random-variate($binomial, 200);

sink records-summary(@res);
```

```raku
text-list-plot(@res.&tally.kv.rotor(2), title => 'Binomial Distribution tallies')
```

### Bernoulli Distribution

[Bernoulli distribution](https://en.wikipedia.org/wiki/Bernoulli_distribution) is a discrete probability distribution that takes the value 1 with probability p and the value 0 with probability 1-p.

```raku
my $bernoulli = BernoulliDistribution.new(0.5);
my @res = random-variate($bernoulli, 12);

sink records-summary(@res);
```

### Discrete Uniform Distribution

[Discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) is a discrete probability distribution that takes on a finite number of values with equal probability.

```raku
my $discrete_uniform = DiscreteUniformDistribution.new(10, 20);
my @res = random-variate($discrete_uniform, 200);

sink records-summary(@res);
```

```raku
text-list-plot(@res.&tally.kv.rotor(2), title => 'Discrete Uniform Distribution tallies')
```

---

## Univariate continuous distributions

### Beta Distribution

```raku
my $beta = BetaDistribution.new(4, 4);
my @res = random-variate($beta, 200);

sink records-summary(@res);
```

```raku
text-histogram(@res, title => 'Beta Distribution')
```

### Normal Distribution

[Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) is a continuous probability distribution specified here by its mean and standard deviation.

```raku
my $normal = NormalDistribution.new(10, 2);
my @res = random-variate($normal, 200);

sink records-summary(@res);
```

```raku
text-histogram(@res, title => 'Normal Distribution')
```


### Uniform distribution

```raku
my @res = random-variate(UniformDistribution.new(-10, 5), 1_000);
sink records-summary(@res);
```

```raku
text-histogram(@res, title => 'Uniform Distribution')
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

```raku
text-list-plot(@res, width => 60, height => 20, title => 'Binormal Distribution random variates')
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

```raku
text-histogram(@res, title => 'Mixture Distribution', width => 80)
```

### Product Distribution

[Product distribution](https://en.wikipedia.org/wiki/Product_distribution) is a probability distribution that is the product of two or more other probability distributions.

```raku
my $product = ProductDistribution.new([NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($product, 600);

sink records-summary(@res, field-names => ['0', '1']);
```

```raku
text-list-plot(@res, width => 60, height => 20, title => "Product Distribution random variates")
```

---

## References

[AAp1] Anton Antonov
[Statistics::Distributions Raku package](https://github.com/antononcube/Raku-Statistics-Distributions),
(2024),
[GitHub/antononcube](https://github.com/antononcube).