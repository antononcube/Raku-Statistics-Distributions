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

--------

## Univariate Distributions

### Beta Distribution

[Beta distribution](https://en.wikipedia.org/wiki/Beta_distribution) is a continuous probability distribution that is defined by two parameters, alpha and beta. The beta distribution is often used to model proportions.

```raku
my $beta = BetaDistribution.new(4, 4);
my @res = random-variate($beta, 12);

records-summary(@res);
```

### Bernoulli Distribution

[Bernoulli distribution](https://en.wikipedia.org/wiki/Bernoulli_distribution) is a discrete probability distribution that takes the value 1 with probability p and the value 0 with probability 1-p.

```raku
my $bernoulli = BernoulliDistribution.new(:p(0.5));
my @res = random-variate($bernoulli, 12);

records-summary(@res);
```

### Discrete Uniform Distribution

[Discrete uniform distribution](https://en.wikipedia.org/wiki/Discrete_uniform_distribution) is a discrete probability distribution that takes on a finite number of values with equal probability.

```raku
my $discrete_uniform = DiscreteUniformDistribution.new(:min(10), :max(20));
my @res = random-variate($discrete_uniform, 12);

records-summary(@res);
```

### Normal Distribution

[Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution) is a continuous probability distribution that is defined by two parameters, the mean and the standard deviation. The normal distribution is also known as the Gaussian distribution.

```raku
my $normal = NormalDistribution.new(:mean(10), :sd(20));
my @res = random-variate($normal, 12);

records-summary(@res);
```

### Uniform Distribution

[Uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)) is a continuous probability distribution that is defined by two parameters, the minimum and the maximum. The uniform distribution is also known as the rectangular distribution.

```raku
my $uniform = UniformDistribution.new(:min(10), :max(20));
my @res = random-variate($uniform, 12);

records-summary(@res);
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

```perl6
text-list-plot(@res, width => 60, height => 20)
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

### Product Distribution

[Product distribution](https://en.wikipedia.org/wiki/Product_distribution) is a probability distribution that is the product of two or more other probability distributions.

```raku
my $product = ProductDistribution.new([NormalDistribution.new(3, 4), NormalDistribution.new(6, 5)]);
my @res = random-variate($product, 60);

records-summary(@res, field-names => ['0', '1']);
```

```perl6
text-list-plot(@res, width => 60, height => 20)
```

--------

## References

[AAp1] Anton Antonov
[Statistics::Distributions Raku package](https://github.com/antononcube/Raku-Statistics-Distributions),
(2024),
[GitHub/antononcube](https://github.com/antononcube).