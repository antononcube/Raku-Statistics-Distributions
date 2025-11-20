use v6.d;

unit module Statistics::Distributions;

use Statistics::Distributions::Defined;

sub EXPORT {
    use Statistics::Distributions::Utilities;
    Map.new:
            '&quantile' => &Statistics::Distributions::Utilities::quantile
}

#===========================================================
constant \BenfordDistribution is export := Statistics::Distributions::Defined::Benford;
constant \BetaDistribution is export := Statistics::Distributions::Defined::Beta;
constant \BernoulliDistribution is export := Statistics::Distributions::Defined::Bernoulli;
constant \BinomialDistribution is export := Statistics::Distributions::Defined::Binomial;
constant \BinormalDistribution is export := Statistics::Distributions::Defined::Binormal;
constant \ChiSquareDistribution is export := Statistics::Distributions::Defined::ChiSquare;
constant \DiscreteUniformDistribution is export := Statistics::Distributions::Defined::DiscreteUniform;
constant \ExponentialDistribution is export := Statistics::Distributions::Defined::Exponential;
constant \GammaDistribution is export := Statistics::Distributions::Defined::Gamma;
constant \MixtureDistribution is export := Statistics::Distributions::Defined::Mixture;
constant \NormalDistribution is export := Statistics::Distributions::Defined::Normal;
constant \StudentTDistribution is export := Statistics::Distributions::Defined::StudentT;
constant \ProductDistribution is export := Statistics::Distributions::Defined::Product;
constant \UniformDistribution is export := Statistics::Distributions::Defined::Uniform;


my %distributions-base = %(
    Benford          => Benford,
    Beta             => Beta,
    Bernoulli        => Bernoulli,
    Binomial         => Binomial,
    Binormal         => Binormal,
    ChiSquare        => ChiSquare,
    Chi-Square       => ChiSquare,
    Chi_Square       => ChiSquare,
    DiscreteUniform  => DiscreteUniform,
    Discrete-Uniform => DiscreteUniform,
    Discrete_Uniform => DiscreteUniform,
    Exponential      => Exponential,
    Gamma            => Gamma,
    Mixture          => Mixture,
    Normal           => Normal,
    StudentT         => StudentT,
    Student-T        => StudentT,
    Student_T        => StudentT,
    Product          => Product,
    Uniform          => Uniform,
);

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