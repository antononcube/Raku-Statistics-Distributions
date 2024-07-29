use v6.d;

unit module Statistics::Distributions;

use Statistics::Distributions::Defined;
use Statistics::Distributions::Utilities;

#===========================================================
constant \BetaDistribution is export := Statistics::Distributions::Defined::Beta;
constant \BernoulliDistribution is export := Statistics::Distributions::Defined::Bernoulli;
constant \BinomialDistribution is export := Statistics::Distributions::Defined::Binomial;
constant \ExponentialDistribution is export := Statistics::Distributions::Defined::Exponential;
constant \GammaDistribution is export := Statistics::Distributions::Defined::Gamma;
constant \NormalDistribution is export := Statistics::Distributions::Defined::Normal;
constant \UniformDistribution is export := Statistics::Distributions::Defined::Uniform;

#============================================================
# RandomVariate
#============================================================

#| Gives a pseudorandom variate from the distribution $dist.
our proto RandomVariate($dist, |) is export {*}

#------------------------------------------------------------
multi RandomVariate($dist) {
    return RandomVariate($dist, 1)[0];
}

multi RandomVariate($dist ,
                    @size where { $_.all ~~ Numeric and [and]($_.map({ $_ > 0 })) and $_.elems == 2 }) {
    my @res = RandomVariate($dist, [*] @size).List;
    my @res2[@size[0];@size[1]] = @res.rotor(@size[1]);
    @res2
}

#------------------------------------------------------------
multi RandomVariate($dist, UInt $size --> List) {
    given $dist {
        when BetaDistribution {
            (beta-dist($_.a, $_.b) xx $size).List
        }
        when BernoulliDistribution {
            (rand xx $size).map({ $_ ≤ $dist.p ?? 1 !! 0 }).List
        }
        when BinomialDistribution {
            binomial-dist($dist.n, $dist.p, :$size).List
        }
        when ExponentialDistribution {
            exponential-dist($dist.lambda, :$size).List
        }
        when GammaDistribution {
            (gamma-dist($dist.a, $dist.b) xx $size).List
        }
        when NormalDistribution {
            (normal-dist($_.mean, $_.sd) xx $size).List
        }
        when UniformDistribution {
            (($_.min .. $_.max).rand xx $size).List
        }
        default {
            die "Unknown random variate class."
        }
    }
}


#===========================================================
#| Gives a pseudorandom variate from the distribution specification.
our proto sub random-variate(|) is export {*}

multi sub random-variate(**@args, *%args) {
    RandomVariate(|@args, |%args)
}

#===========================================================
#| Gives a pseudorandom variate from the uniform distribution with specified range.
our proto sub random-real(|) is export {*}

multi sub random-real(Numeric $max = 1) {
    return random-real((0, $max), 1)[0]
}

multi sub random-real(Numeric $max, UInt $size) {
    return random-real((0, $max), $size)
}

multi sub random-real(Numeric $max, @size) {
    return random-real((0, $max), @size)
}

multi sub random-real((Numeric $min, Numeric $max)) {
    return random-real(($min, $max), 1)[0];
}

multi sub random-real((Numeric $min, Numeric $max), UInt $size) {
    return RandomVariate(UniformDistribution.new(:$min, :$max), $size);
}

multi sub random-real((Numeric $min, Numeric $max), @size) {
    return RandomVariate(UniformDistribution.new(:$min, :$max), @size);
}

multi sub random-real(Numeric :$min = 0, Numeric :$max = 1) {
    return random-real(($min, $max));
}

multi sub random-real(Numeric :$min = 0, Numeric :$max = 1, :$size = 1) {
    return random-real(($min, $max), $size);
}