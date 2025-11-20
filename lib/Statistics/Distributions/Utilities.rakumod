use v6.d;

unit module Statistics::Distributions::Utilities;

use Math::SpecialFunctions;

#------------------------------------------------------------
sub normal-dist(Numeric $µ, Numeric $σ) is export {
    sqrt(-2 * log(rand)) * cos(2 * π * rand) * $σ + $µ;
}


#------------------------------------------------------------
#| Given a vector of non-decreasing breakpoints in vec, find the interval containing each element of data;
#| i.e., if i = find-interval(x, v), for each index j in x where v[i[j]] ≤ x[j] < v[i[j]+1],
#| where v[0] = -Inf, v[N+1] = Inf and N = v.elems .
#| At the two boundaries, the returned index may differ by 1,
#| depending on the option arguments rightmost-closed and all-inside.
#| C<@data> -- numeric vector.
#| C<@vec> -- numeric vector sorted increasingly.
#| C<:$rightmost-closed> -- boolean; if true, the rightmost interval, vec[N-1] .. vec[N] is treated as closed, see below.
#| C<:$all.inside> -- boolean; if true, the returned indices are coerced into 1,...,N-1, i.e., 0 is mapped to 1 and N to N-1.
#| C<:$left.open> -- boolean; if true all the intervals are open at left and closed at right.
our proto sub find-interval($data,
                            @vec,
                            Bool :$rightmost-closed = False,
                            Bool :$all-inside = False,
                            Bool :$left-open = False)
        is export {*}

multi sub find-interval(Numeric $data, @vec, *%args) {
    return find-interval([$data,], @vec, |%args).head;
}

multi sub find-interval(@data where @data.all ~~ Numeric,
                        @vec is copy where @vec.all ~~ Numeric,
                        Bool :$rightmost-closed = False,
                        Bool :$all-inside = False,
                        Bool :$left-open = False) {

    my $n = @vec.elems;

    # Augment boundaries
    @vec = @vec.sort.Array.append(Inf);

    my @indices = @data.map(-> $x {

        my $index = do if $left-open {
            @vec.first({ $_ >= $x }, :k);
        } else {
            @vec.first({ -$x > -$_ }, :k);
        }

        if $rightmost-closed and $x == @vec[*- 2] {
            $index = $n - 1;
        }

        $index;
    });

    if $all-inside {
        @indices = @indices.map({ $_ == 0 ?? 1 !! $_ >= $n ?? $n - 1 !! $_ });
    }

    return (@indices <<+>> -1).Array;
}

#------------------------------------------------------------
sub binomial-dist(Int $n, Numeric $p, Int :$size = 1) is export {

    my @vec = (0 .. $n).map(-> $x { binomial($n, $x) * $p ** $x * (1 - $p) ** ($n - $x) });

    @vec = [\+] [0, |@vec];

    return find-interval(rand xx $size, @vec);
}

#------------------------------------------------------------
sub exponential-dist(Numeric:D $lambda, Int :$size = 1) is export {
    my @u = rand xx $size;
    return @u.map({ -log($_) / $lambda });
}

#------------------------------------------------------------
# Using:
# George Marsaglia and Wai Wan Tsang. 2000. "A simple method for generating gamma variables."
# ACM Trans. Math. Softw. 26, 3 (Sept. 2000), 363–372.
# https://doi.org/10.1145/358407.358414
sub gamma-dist-marsaglia(Numeric:D $a) is export {
    if $a < 1 {
        die 'The first argument is expected to be larger or equal to 1.';
    }

    loop {
        my $x = normal-dist(0, 1);
        my $u = rand;
        my $d = $a - 1 / 3;
        my $c = 1 / sqrt(9 * $d);
        my $v = (1 + $c * $x) ** 3;
        if $v > 0 && log($u) < $x ** 2 / 2 + $d - $d * $v + $d * log($v) {
            return $d * $v
        }
    }
}

# Using Wikipedia's version of the Ahrens-Dieter acceptance–rejection method given here:
# https://en.wikipedia.org/wiki/Gamma_distribution#Random_variate_generation
sub gamma-dist(Numeric:D $a, Numeric:D $b) is export {
    my $delta = $a - $a.floor;
    my $xi;
    loop {
        my $u = rand;
        my $v = rand;
        my $w = rand;
        my $eta;
        # In general e can be used instead of exp(0), but highlighting gets confused.
        if $u ≤ exp(0) / ($delta + exp(0)) {
            $xi = $v ** (1 / $delta);
            $eta = $w * $xi ** ($delta - 1);
        } else {
            $xi = 1 - log($v);
            $eta = $w * exp(-$xi);
        }

        last if $eta ≤ $xi ** ($delta - 1) * exp(-$xi);
    }

    my $k = $a.floor;
    my $usum = (rand xx $k).grep({ $_ > 0 })».log.sum;
    return $b * ($xi - $usum);
}

#------------------------------------------------------------
my %benford-breaks;
sub benford-dist(UInt:D $b where $b > 2, UInt:D $size = 1) is export {
    if %benford-breaks{$b}:!exists {
        my @breaks = (1..($b-2)).map({ log(1 + 1 / $_, $b) });
        %benford-breaks{$b} = ([\+] [0, |@breaks]).Array.push(1);
    }
    return find-interval(rand xx $size, %benford-breaks{$b}) <<+>> 1;
}

#------------------------------------------------------------
sub beta-dist(Numeric:D $a, Numeric $b) is export {
    my $x = gamma-dist($a, 1);
    my $y = gamma-dist($b, 1);
    return $x / ($x + $y);
}

#------------------------------------------------------------
sub binormal-dist(@mu, @sigma, $rho) is export {
    my ($mu1, $mu2) = @mu;
    my ($sigma1, $sigma2) = @sigma;

    my ($z1, $z2) = normal-dist(0,1) xx 2;

    my $x1 = $mu1 + $sigma1 * $z1;
    my $x2 = $mu2 + $sigma2 * ($rho * $z1 + sqrt(1 - $rho ** 2) * $z2);

    return ($x1, $x2);
}

#------------------------------------------------------------
sub mixture-dist(@weights, @dists, UInt:D :$size = 1) is export {
    die "Weights and distributions must match in length."
    unless @weights.elems == @dists.elems;

    die "Weights must be non-negative numbers."
    unless (@weights.all ~~ Numeric:D) && ([&&] @weights.map({ $_ ≥ 0 }));

    die "All distributions must have method generate()."
    unless @dists.map({ 'generate' ∈ $_.^method_names });

    # Instead of this ad hoc weighted choice algorithm made from scratch,
    # the built-in weighted choice via Mix can used
    my @cumulative-weights = produce(&[+], @weights.prepend(0));
    @cumulative-weights = @cumulative-weights >>/>> @cumulative-weights.tail;
    my @baseSample = rand xx $size;
    my @picks = find-interval(@baseSample, @cumulative-weights);

    return @picks.map({ @dists[$_].generate.head }).List;
}

#------------------------------------------------------------
sub transpose(@matrix) {
    my @res;
    for ^@matrix.elems -> $i {
        for ^@matrix[0].elems -> $j {
            @res[$j][$i] = @matrix[$i][$j]
        }
    }
    return @res;
}
sub product-dist(@dists, UInt:D :$size = 1) is export {
    return @dists.map({ $_.generate(:$size) }).&transpose.List;
}

#------------------------------------------------------------
sub chi-squared-dist($nu, UInt:D :$size = 1) is export {
    die "The first argument is expected to be a positive number." unless $nu > 0;

    my @variates = do if $nu ~~ Int:D {
        ([+] (^$nu).map: { normal-dist(0, 1) ** 2 }) xx $size;
    } else {
        gamma-dist($nu / 2, 2) xx $size
    }

    return @variates.List;
}

#------------------------------------------------------------
sub student-t-dist($nu, $mean, $sd, Int :$size) is export {
    my @variates;
    for ^$size -> $ {
        my $z = normal-dist(0, 1);
        my $v = chi-squared-dist($nu).head;
        my $t = $mean + $sd * ($z / sqrt($v / $nu));
        @variates.push($t);
    }
    return @variates;
}

#------------------------------------------------------------
our proto sub quantile($data, |) {*}

multi sub quantile(@data,
                   $probs is copy = Whatever,
                   $params is copy = Whatever,
                   Bool:D :p(:$pairs) = False
                   ) {
    return quantile(@data, :$probs, :$params, :$pairs);
}


multi sub quantile(@data,
                   :probabilities(:$probs) is copy = Whatever,
                   :parameters(:$params) is copy = Whatever,
                   Bool:D :p(:$pairs) = False
                   ) {

    # Check data
    die 'The first argument is expected to be a list of numbers.'
    unless @data.all ~~ Numeric:D;

    # Handle probabilities
    if $probs.isa(Whatever) { $probs = [1/4, 1/2, 3/4] }
    die 'The value of $probs is expected to be a list of numbers between 0 and 1, or Whatever.'
    unless $probs ~~ (Array:D | List:D | Seq:D ) && $probs.cache.all ~~ Numeric:D && ([&&] |$probs.cache.map(0≤*≤1));

    # In order to make sure it is an array
    my @probs = |$probs;

    # Handle parameters
    if $params.isa(Whatever) { $params = [[0, 0], [1, 0]] }
    die 'The value of $params is expected to be a list of two lists of numbers, or Whatever.'
    unless $params ~~ (Array:D | List:D | Seq:D ) && $params.all ~~ (Array:D | List:D | Seq:D) && $params.flat(:hammer).all ~~ Numeric:D;

    my ($a, $b, $c, $d) = $params.flat(:hammer);

    # Main part
    my @sorted = @data.sort;
    my $n = @sorted.elems;
    my @result;

    for @probs -> $p {
        my $r = $a + ($n + $b) * $p;
        my $lower = $r.floor;
        my $frac  = $r - $lower;

        if $lower ≥ $n {
            @result.push( $pairs ?? ($p => @sorted.tail) !! @sorted.tail );
        } elsif $lower ≤ 1 {
            @result.push( $pairs ?? ($p => @sorted.head) !! @sorted.head );
        } else {
            my $val = @sorted[$lower - 1] + ($c + $d * $frac) * (@sorted[$lower] - @sorted[$lower - 1]);
            @result.push( $pairs ?? ($p => $val) !! $val);
        }
    }

    return @result;
}