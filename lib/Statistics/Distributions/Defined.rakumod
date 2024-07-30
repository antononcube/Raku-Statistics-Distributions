use v6.d;

unit module Statistics::Distributions::Defined;

use Statistics::Distributions::Utilities;

#| Generic Distribution class
class Generic is export {
    multi method generate(UInt:D $size = 1) {
        self.generate(:$size)
    }
    multi method generate(UInt:D :$size = 1) {!!!}
}

#| Beta distribution class
class Beta is Generic is export {
    has Numeric:D $.a is required;
    #= Shape parameter left.
    has Numeric:D $.b is required;
    #= Shape parameter right.
    multi method new($a, $b) { self.bless(:$a, :$b) }
    multi method generate(UInt:D :$size) {
        (beta-dist($!a, $!b) xx $size).List
    }
}
#= Beta distribution objects are specified with shape parameters.

#| Bernoulli distribution class
class Bernoulli is Generic is export {
    has Numeric:D $.p = 0.5;
    #= Get value 1 with probability p
    multi method new($p) { self.bless(:$p) }
    multi method generate(UInt:D :$size) {
        (rand xx $size).map({ $_ ≤ $!p ?? 1 !! 0 }).List
    }
}
#= Bernoulli distribution objects are specified with probability parameter.

#| Binomial distribution class
class Binomial is Generic is export {
    has Numeric:D $.n = 2;
    #= Number of trials
    has Numeric:D $.p = 0.5;
    #= Success probability p
    multi method new($n, $p) { self.bless(:$n, :$p) }
    multi method generate(UInt:D :$size) {
        binomial-dist($!n, $!p, :$size).List
    }
}
#= Binomial distribution objects are specified with number of trials and success probability.

#| Binormal distribution class
class Binormal is Generic is export {
    has Numeric:D $.mu1 = 0;
    has Numeric:D $.mu2 = 0;
    has Numeric:D $.sigma1 = 1;
    has Numeric:D $.sigma2 = 1;
    has Numeric:D $.rho = 0;

    multi method new(($mu1, $mu2), ($sigma1, $sigma2), $rho) {
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method new(($sigma1, $sigma2), $rho) {
        my ($mu1, $mu2) = (0, 0);
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method new($rho) {
        my ($mu1, $mu2) = (0, 0);
        my ($sigma1, $sigma2) = (1, 1);
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method generate(UInt:D :$size) {
        (binormal-dist([$!mu1, $!mu2], [$!sigma1, $!sigma2], $!rho) xx $size).List
    }
}
#= Binormal distribution objects take parameters for the distribution mean and covariance matrix.

#| Exponential distribution class
class Exponential is Generic is export {
    has Numeric:D $.lambda = 0.5;
    #= Scale parameter
    multi method new($lambda) { self.bless(:$lambda) }

    multi method generate(UInt:D :$size) {
        exponential-dist($!lambda, :$size).List
    }
}
#= Exponential distribution objects are specified with scale inversely proportional to the lambda parameter.

#| Gamma distribution class
class Gamma is Generic is export {
    has Numeric:D $.a = 0.5;
    has Numeric:D $.b = 0.5;
    multi method new($a, $b) { self.bless(:$a, :$b) }

    multi method generate(UInt:D :$size) {
        (gamma-dist($!a, $!b) xx $size).List
    }
}
#= Gamma distribution objects are specified shape parameter a and inverse scale parameter b.

#| Uniform distribution class
class Mixture is Generic is export {
    has @.weights;
    has @.distributions;
    multi method new(@weights, @distributions) {
        self.bless(:@weights, :@distributions)
    }

    multi method generate(UInt:D :$size) {
        mixture-dist(@!weights, @!distributions, :$size)
    }
}

#| Normal distribution class
class Normal is Generic is export {
    has Numeric:D $.mean = 0;
    #= Mean of the Normal distribution
    has Numeric:D $.sd = 1;
    #= Standard Deviation of the Normal distribution
    submethod BUILD(:µ(:$!mean) = 0, :σ(:$!sd) = 1) {}
    multi method new($mean, $sd) { self.bless(:$mean, :$sd) }

    multi method generate(UInt:D :$size) {
        (normal-dist($!mean, $!sd) xx $size).List
    }
}
#= Normal distribution objects are specified with mean and standard deviation.

#| Uniform distribution class
class Uniform is Generic is export {
    has Numeric:D $.min = 0;
    #= Min boundary of the Uniform distribution
    has Numeric:D $.max = 1;
    #= Max boundary of the Uniform distribution
    multi method new($min, $max) { self.bless(:$min, :$max) }

    multi method generate(UInt:D :$size) {
        (($!min .. $!max).rand xx $size).List
    }
}
#= Uniform distribution objects are specified with min and max boundaries.
