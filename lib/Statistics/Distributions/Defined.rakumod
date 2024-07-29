use v6.d;

unit module Statistics::Distributions::Defined;

#| Beta distribution class
class Beta is export {
    has Numeric $.a is required;
    #= Shape parameter left.
    has Numeric $.b is required;
    #= Shape parameter right.
    multi method new($a, $b) { self.bless(:$a, :$b) }
}
#= Beta distribution objects are specified with shape parameters.

#| Bernoulli distribution class
class Bernoulli is export {
    has Numeric $.p = 0.5;
    #= Get value 1 with probability p
    multi method new($p) { self.bless(:$p) }
}
#= Bernoulli distribution objects are specified with probability parameter.

#| Binomial distribution class
class Binomial is export {
    has Numeric $.n = 2;
    #= Number of trials
    has Numeric $.p = 0.5;
    #= Success probability p
    multi method new($n, $p) { self.bless(:$n, :$p) }
}
#= Binomial distribution objects are specified with number of trials and success probability.

#| Exponential distribution class
class Exponential is export {
    has Numeric $.lambda = 0.5;
    #= Scale parameter
    multi method new($lambda) { self.bless(:$lambda) }
}
#= Exponential distribution objects are specified with scale inversely proportional to the lambda parameter.

#| Gamma distribution class
class Gamma is export {
    has Numeric $.a = 0.5;
    has Numeric $.b = 0.5;
    multi method new($a, $b) { self.bless(:$a, :$b) }
}
#= Gamma distribution objects are specified shape parameter a and inverse scale parameter b.

#| Normal distribution class
class Normal is export {
    has Numeric $.mean = 0;
    #= Mean of the Normal distribution
    has Numeric $.sd = 1;
    #= Standard Deviation of the Normal distribution
    submethod BUILD(:µ(:$!mean) = 0, :σ(:$!sd) = 1) {}
    multi method new($mean, $sd) { self.bless(:$mean, :$sd) }
}
#= Normal distribution objects are specified with mean and standard deviation.

#| Uniform distribution class
class Uniform is export {
    has Numeric $.min = 0;
    #= Min boundary of the Uniform distribution
    has Numeric $.max = 1;
    #= Max boundary of the Uniform distribution
    multi method new($min, $max) { self.bless(:$min, :$max) }
}
#= Uniform distribution objects are specified with min and max boundaries.
