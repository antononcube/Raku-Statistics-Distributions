use v6.d;

sub EXPORT {
    use Statistics::Distributions::Utilities;
    use Statistics::Distributions::Defined;

    Map.new:
            '&quantile' => &Statistics::Distributions::Utilities::quantile,
            'BenfordDistribution' => Statistics::Distributions::Defined::Benford,
            'BernoulliDistribution' => Statistics::Distributions::Defined::Bernoulli,
            'BetaDistribution' => Statistics::Distributions::Defined::Beta,
            'BinomialDistribution' => Statistics::Distributions::Defined::Binomial,
            'BinormalDistribution' => Statistics::Distributions::Defined::Binormal,
            'ChiSquareDistribution' => Statistics::Distributions::Defined::ChiSquare,
            'DiscreteUniformDistribution' => Statistics::Distributions::Defined::DiscreteUniform,
            'ExponentialDistribution' => Statistics::Distributions::Defined::Exponential,
            'ExtremeValueDistribution' => Statistics::Distributions::Defined::ExtremeValue,
            'FrechetDistribution' => Statistics::Distributions::Defined::Frechet,
            'GammaDistribution' => Statistics::Distributions::Defined::Gamma,
            'GumbelDistribution' => Statistics::Distributions::Defined::Gumbel,
            'MaxStableDistribution' => Statistics::Distributions::Defined::MaxStable,
            'MixtureDistribution' => Statistics::Distributions::Defined::Mixture,
            'MinStableDistribution' => Statistics::Distributions::Defined::MinStable,
            'NormalDistribution' => Statistics::Distributions::Defined::Normal,
            'ProductDistribution' => Statistics::Distributions::Defined::Product,
            'RayleighDistribution' => Statistics::Distributions::Defined::Rayleigh,
            'StudentTDistribution' => Statistics::Distributions::Defined::StudentT,
            'UniformDistribution' => Statistics::Distributions::Defined::Uniform,
            'WeibullDistribution' => Statistics::Distributions::Defined::Weibull
            ;
}

unit module Statistics::Distributions;

use Statistics::Distributions::Defined;

my %distributions-base =
    Benford          => Benford,
    Bernoulli        => Bernoulli,
    Beta             => Beta,
    Binomial         => Binomial,
    Binormal         => Binormal,
    Chi-Square       => ChiSquare,
    ChiSquare        => ChiSquare,
    Chi_Square       => ChiSquare,
    Discrete-Uniform => DiscreteUniform,
    DiscreteUniform  => DiscreteUniform,
    Discrete_Uniform => DiscreteUniform,
    Exponential      => Exponential,
    Extreme-Value    => ExtremeValue,
    Extreme_Value    => ExtremeValue,
    ExtremeValue     => ExtremeValue,
    Frechet          => Frechet,
    Gamma            => Gamma,
    Gumbel           => Gumbel,
    Max-Stable       => MaxStable,
    Max_Stable       => MaxStable,
    MaxStable        => MaxStable,
    Mixture          => Mixture,
    Min-Stable       => MinStable,
    Min_Stable       => MinStable,
    MinStable        => MinStable,
    Normal           => Normal,
    Product          => Product,
    Rayleigh         => Rayleigh,
    Student-T        => StudentT,
    StudentT         => StudentT,
    Student_T        => StudentT,
    Uniform          => Uniform,
    Weibull          => Weibull,
;

my %distributions-base-ext = %distributions-base.map({ [$_.key ~ 'Distribution' => $_.value, $_.key ~ '-Distribution' => $_.value, $_.key ~ '_Distribution' => $_.value ]}).flat;

my %known-distributions = %distributions-base , %distributions-base-ext;
%known-distributions .= map({ $_.key.lc => $_.value});

sub known-distributions(-->Map:D) is export {
    return %known-distributions.clone.Map
}

#============================================================
# RandomVariate
#============================================================

#| Gives a pseudorandom variate from the distribution $dist.
our proto RandomVariate($dist, |) is export {*}

#------------------------------------------------------------
multi RandomVariate($dist) {
    return RandomVariate($dist, 1)[0];
}

multi RandomVariate($dist,
                    @size where { $_.all ~~ Numeric and [and]($_.map({ $_ > 0 })) and $_.elems == 2 }) {
    my @res = RandomVariate($dist, [*] @size).List;
    my @res2[@size[0];@size[1]] = @res.rotor(@size[1]);
    @res2
}

#------------------------------------------------------------
multi RandomVariate($dist, UInt $size --> List) {
    given $dist {
        when $_ ~~ Generic:D {
            $dist.generate(:$size)
        }
        when $_ ~~ Generic {
            $dist.new.generate(:$size)
        }
        when $_ ~~ Str:D {
            if %known-distributions{$_.lc}:exists {
                return RandomVariate(%known-distributions{$_.lc}, $size);
            }
            die "Unknown random variate class name. Known variate class names are: \"{%known-distributions.keys.sort.join('", "')}\"."
        }
        default {
            die "Unknown random variate class: ⎡$_⎦."
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
    return RandomVariate(Statistics::Distributions::Defined::Uniform.new(:$min, :$max), $size);
}

multi sub random-real((Numeric $min, Numeric $max), @size) {
    return RandomVariate(Statistics::Distributions::Defined::Uniform.new(:$min, :$max), @size);
}

multi sub random-real(Numeric :$min = 0, Numeric :$max = 1) {
    return random-real(($min, $max));
}

multi sub random-real(Numeric :$min = 0, Numeric :$max = 1, :$size = 1) {
    return random-real(($min, $max), $size);
}
