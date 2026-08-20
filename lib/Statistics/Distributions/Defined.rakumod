use v6.d;

unit module Statistics::Distributions::Defined;

use Statistics::Distributions::Utilities;

#| Generic Distribution class
class Generic is export {
    has UInt:D $.dimension = 1;
    # I am not happy with $.continuous and $.derived being rw,
    # but that is the easiest way to initialize them correctly.
    has Bool:D $.continuous is rw = True;
    has Bool:D $.derived is rw = False;
    multi method Hash(::?CLASS:D: --> Hash) {
        { class => self.^name.split('::').tail, dimension => $!dimension, continuous => $!continuous, derived => $!derived }
    }
    multi method gist(::?CLASS:D:-->Str) {
        my %h = self.Hash;
        %h<class> ~ %h.grep(*.key ne 'class').List.raku
    }
    multi method generate(UInt:D $size = 1) {
        self.generate(:$size)
    }
    multi method generate(UInt:D :$size = 1) {!!!}
}

#| Benford distribution class
class Benford is Generic is export {
    has UInt:D $.b = 10;
    #= Digit base.
    multi method new($b) {
        die 'The parameter is expected to be an integer greater than 2.' unless $b > 2;
        self.bless(:$b)
    }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, b => $!b } }
    multi method generate(UInt:D :$size) {
        benford-dist($!b, $size).List
    }
}
#= Beta distribution objects are specified with shape parameters.


#| Beta distribution class
class Beta is Generic is export {
    has Numeric:D $.a is required;
    #= Shape parameter left.
    has Numeric:D $.b is required;
    #= Shape parameter right.
    multi method new($a, $b) { self.bless(:$a, :$b) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, a => $!a, b => $!b } }
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
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, p => $!p } }
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

    submethod BUILD(Numeric:D :$!n!, Numeric:D :$!p!) {
        self.continuous = False;
    }
    multi method new($n, $p) { self.bless(:$n, :$p) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, n => $!n, p => $!p } }
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

    multi method new((Numeric:D $mu1, Numeric:D $mu2), (Numeric:D $sigma1, Numeric:D $sigma2), Numeric:D $rho) {
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method new((Numeric:D $sigma1, Numeric:D $sigma2), Numeric:D $rho) {
        my ($mu1, $mu2) = (0, 0);
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method new(Numeric:D $rho) {
        my ($mu1, $mu2) = (0, 0);
        my ($sigma1, $sigma2) = (1, 1);
        self.bless(:$mu1, :$mu2, :$sigma1, :$sigma2, :$rho)
    }

    multi method Hash(::?CLASS:D: --> Hash) {
        { class => self.^name.split('::').tail, mu1 => $!mu1, mu2 => $!mu2, sigma1 => $!sigma1, sigma2 => $!sigma2, rho => $!rho }
    }

    multi method generate(UInt:D :$size) {
        (binormal-dist([$!mu1, $!mu2], [$!sigma1, $!sigma2], $!rho) xx $size).List
    }
}
#= Binormal distribution objects take parameters for the distribution mean and covariance matrix.

#| Chi-Square distribution class
class ChiSquare is Generic is export {
    has Numeric:D $.nu = 1;
    #= Degrees of freedom
    submethod BUILD(:ν(:$!nu) = 1) {}
    multi method new($nu) { self.bless(:$nu) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, nu => $!nu } }
    multi method generate(UInt:D :$size) {
        chi-squared-dist($!nu, :$size);
    }
}
#= A Chi-Square distribution object is specified with a positive degrees of freedom parameter (nu).


#| Discrete Uniform distribution class
class DiscreteUniform is Generic is export {
    has Int:D $.min = 0;
    #= Min boundary of the Uniform distribution
    has Int:D $.max = 1;
    #= Max boundary of the Uniform distribution

    submethod TWEAK() { self.continuous = False; }
    multi method new($min, $max) { self.bless(:$min, :$max) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, min => $!min, max => $!max } }
    multi method generate(UInt:D :$size) {
        ($!min .. $!max).roll($size).List
    }
}
#= Discrete Uniform distribution objects are specified with min and max integer boundaries.

#| Exponential distribution class
class Exponential is Generic is export {
    has Numeric:D $.lambda = 0.5;
    #= Scale parameter
    multi method new($lambda) { self.bless(:$lambda) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, lambda => $!lambda } }

    multi method generate(UInt:D :$size) {
        exponential-dist($!lambda, :$size).List
    }
}
#= Exponential distribution objects are specified with scale inversely proportional to the lambda parameter.

#| Extreme Value distribution class
class ExtremeValue is Generic is export {
    has Numeric:D $.location = 0;
    #= Location parameter
    has Numeric:D $.scale = 1;
    #= Scale parameter
    multi method new($location, $scale) { self.bless(:$location, :$scale) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, location => $!location, scale => $!scale } }

    multi method generate(UInt:D :$size) {
        extreme-value-dist($!location, $!scale, :$size).List
    }
}
#= Extreme Value distribution objects are specified with location and positive scale parameters.

#| Frechet distribution class
class Frechet is Generic is export {
    has Numeric:D $.a = 1;
    #= Shape parameter
    has Numeric:D $.b = 1;
    #= Scale parameter
    has Numeric:D $.m = 0;
    #= Location parameter
    multi method new($a, $b, $m = 0) { self.bless(:$a, :$b, :$m) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, a => $!a, b => $!b, m => $!m } }

    multi method generate(UInt:D :$size) {
        frechet-dist($!a, $!b, $!m, :$size).List
    }
}
#= Frechet distribution objects are specified with positive shape and scale parameters and a location parameter.

#| Gumbel distribution class
class Gumbel is Generic is export {
    has Numeric:D $.location = 0;
    #= Location parameter
    has Numeric:D $.scale = 1;
    #= Scale parameter
    submethod BUILD(:a(:loc(:$!location)) = 0, :b(:$!scale) = 1) {}
    multi method new($location, $scale) { self.bless(:$location, :$scale) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, location => $!location, scale => $!scale } }

    multi method generate(UInt:D :$size) {
        gumbel-dist($!location, $!scale, :$size).List
    }
}
#= Gumbel distribution objects are specified with location and positive scale parameters.

#| Min Stable distribution class
class MinStable is Generic is export {
    has Numeric:D $.mu = 0;
    #= Location parameter
    has Numeric:D $.sigma = 1;
    #= Scale parameter
    has Numeric:D $.xi = 0;
    #= Shape parameter
    submethod BUILD(:μ(:$!mu) = 0, :σ(:$!sigma) = 1, :ξ(:$!xi) = 0) {}
    multi method new($mu, $sigma, $xi) { self.bless(:$mu, :$sigma, :$xi) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, mu => $!mu, sigma => $!sigma, xi => $!xi } }

    multi method generate(UInt:D :$size) {
        min-stable-dist($!mu, $!sigma, $!xi, :$size).List
    }
}
#= Min Stable distribution objects are specified with location, positive scale, and shape parameters.

#| Max Stable distribution class
class MaxStable is Generic is export {
    has Numeric:D $.mu = 0;
    #= Location parameter
    has Numeric:D $.sigma = 1;
    #= Scale parameter
    has Numeric:D $.xi = 0;
    #= Shape parameter
    submethod BUILD(:μ(:$!mu) = 0, :σ(:$!sigma) = 1, :ξ(:$!xi) = 0) {}
    multi method new($mu, $sigma, $xi) { self.bless(:$mu, :$sigma, :$xi) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, mu => $!mu, sigma => $!sigma, xi => $!xi } }

    multi method generate(UInt:D :$size) {
        max-stable-dist($!mu, $!sigma, $!xi, :$size).List
    }
}
#= Max Stable distribution objects are specified with location, positive scale, and shape parameters.

#| Rayleigh distribution class
class Rayleigh is Generic is export {
    has Numeric:D $.sigma = 1;
    #= Scale parameter
    submethod BUILD(:σ(:$!sigma) = 1) {}
    multi method new($sigma) { self.bless(:$sigma) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, sigma => $!sigma } }

    multi method generate(UInt:D :$size) {
        rayleigh-dist($!sigma, :$size).List
    }
}
#= Rayleigh distribution objects are specified with a positive scale parameter.

#| Weibull distribution class
class Weibull is Generic is export {
    has Numeric:D $.shape = 1;
    #= Shape parameter
    has Numeric:D $.scale = 1;
    #= Scale parameter
    has Numeric:D $.location = 0;
    #= Location parameter
    submethod BUILD(:a(:$!shape) = 1, :b(:$!scale) = 1, :μ(:$!location) = 0) {}
    multi method new($shape, $scale, $location = 0) { self.bless(:$shape, :$scale, :$location) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, shape => $!shape, scale => $!scale, location => $!location } }

    multi method generate(UInt:D :$size) {
        weibull-dist($!shape, $!scale, $!location, :$size).List
    }
}
#= Weibull distribution objects are specified with positive shape and scale parameters and a location parameter.

#| Gamma distribution class
class Gamma is Generic is export {
    has Numeric:D $.a = 0.5;
    has Numeric:D $.b = 0.5;
    multi method new($a, $b) { self.bless(:$a, :$b) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, a => $!a, b => $!b } }

    multi method generate(UInt:D :$size) {
        (gamma-dist($!a, $!b) xx $size).List
    }
}
#= Gamma distribution objects are specified shape parameter a and inverse scale parameter b.

#| Mixture distribution class
class Mixture is Generic is export {
    has @.weights;
    has @.distributions;

    submethod BUILD(:@!weights!, :@!distributions!) {
        die "Weights and distributions must match in length."
        unless @!weights.elems == @!distributions.elems;

        die "The distributions must have the same dimension."
        unless @!distributions.map(*.dimension).reduce({ $^a == $^b });

        die "The distributions must be all continous or all disctete."
        unless @!distributions.map(*.continuous).reduce({ $^a == $^b });
    }

    submethod TWEAK() {
        self.continuous = @!distributions.head.continuous;
        self.derived = True;
    }

    multi method new(@weights, @distributions) {
        self.bless(:@weights, :@distributions)
    }

    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, weights => @!weights, distributions => @!distributions } }

    multi method generate(UInt:D :$size) {
        mixture-dist(@!weights, @!distributions, :$size)
    }
}
#= Mixture distribution objects are specified distributions and corresponding choice weights.

#| Normal distribution class
class Normal is Generic is export {
    has Numeric:D $.mean = 0;
    #= Mean of the Normal distribution
    has Numeric:D $.sd = 1;
    #= Standard Deviation of the Normal distribution
    submethod BUILD(:µ(:$!mean) = 0, :σ(:$!sd) = 1) {}
    multi method new($mean, $sd) { self.bless(:$mean, :$sd) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, mean => $!mean, sd => $!sd } }

    multi method generate(UInt:D :$size) {
        (normal-dist($!mean, $!sd) xx $size).List
    }
}
#= Normal distribution objects are specified with mean and standard deviation.

#| Product distribution class
class Product is Generic is export {
    has @.distributions;

    submethod BUILD(:@!distributions!) {
        die "Known distributions are expected."
        unless @!distributions.all ~~ Generic;
    }

    submethod TWEAK() {
        self.continuous = [&&] @!distributions.head.continuous;
        self.derived = True;
    }

    multi method new(+@distributions) {
        self.bless(:@distributions)
    }

    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, distributions => @!distributions } }

    multi method generate(UInt:D :$size) {
        product-dist(@!distributions, :$size)
    }
}
#= Product Distribution objects are created with lists of distribution objects.

#| Student t-distribution class
class StudentT is Generic is export {
    has Numeric:D $.nu = 1;
    #= Degrees of freedom
    has Numeric:D $.mean = 0;
    #= Location
    has Numeric:D $.sd = 1;
    #= Scale
    submethod BUILD(:ν(:$!nu) = 1, :µ(:$!mean) = 0, :σ(:$!sd) = 1) {}
    multi method new($nu) { self.bless(:$nu, mean => 0, sd => 1) }
    multi method new($nu, $mean, $sd) { self.bless(:$nu, :$mean, :$sd) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, nu => $!nu, mean => $!mean, sd => $!sd } }
    multi method generate(UInt:D :$size) {
        student-t-dist($!nu, $!mean, $!sd, :$size);
    }
}
#= A Student t-distribution object is specified with a positive degrees of freedom parameter (nu), location parameter (mu), and scale parameter (sigma).


#| Uniform distribution class
class Uniform is Generic is export {
    has Numeric:D $.min = 0;
    #= Min boundary of the Uniform distribution
    has Numeric:D $.max = 1;
    #= Max boundary of the Uniform distribution
    multi method new($min, $max) { self.bless(:$min, :$max) }
    multi method Hash(::?CLASS:D: --> Hash) { { class => self.^name.split('::').tail, min => $!min, max => $!max } }

    multi method generate(UInt:D :$size) {
        (($!min .. $!max).rand xx $size).List
    }
}
#= Uniform distribution objects are specified with min and max boundaries.
