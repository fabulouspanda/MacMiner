from __future__ import division

import sys
import operator
import types

from pytools.decorator import decorator

try:
    decorator_module = __import__("decorator", level=0)
except TypeError:
    # this must be Python 2.4
    my_decorator = decorator
else:
    my_decorator = decorator_module.decorator




# {{{ math --------------------------------------------------------------------
def delta(x,y):
    if x == y:
        return 1
    else:
        return 0




def levi_civita(tup):
    """Compute an entry of the Levi-Civita tensor for the indices *tuple*."""
    if len(tup) == 2:
        i,j = tup
        return j-i
    if len(tup) == 3:
        i,j,k = tup
        return (j-i)*(k-i)*(k-j)/2
    else:
        raise NotImplementedError




def factorial(n):
    from operator import mul
    assert n == int(n)
    return reduce(mul, (i for i in xrange(1,n+1)), 1)




def perm(n, k):
    """Return P(n, k), the number of permutations of length k drawn from n
    choices.
    """
    result = 1
    assert k > 0
    while k:
        result *= n
        n -= 1
        k -= 1

    return result




def comb(n, k):
    """Return C(n, k), the number of combinations (subsets)
    of length k drawn from n choices.
    """
    return perm(n, k)//factorial(k)




def norm_1(iterable):
    return sum(abs(x) for x in iterable)

def norm_2(iterable):
    return sum(x**2 for x in iterable)**0.5

def norm_inf(iterable):
    return max(abs(x) for x in iterable)

def norm_p(iterable, p):
    return sum(i**p for i in iterable)**(1/p)

class Norm(object):
    def __init__(self, p):
        self.p = p

    def __call__(self, iterable):
        return sum(i**self.p for i in iterable)**(1/self.p)

# }}}

# {{{ data structures ---------------------------------------------------------

# {{{ record
class Record(object):
    """An aggregate of named sub-variables. Assumes that each record sub-type
    will be individually derived from this class.
    """

    __slots__ = []

    def __init__(self, valuedict=None, exclude=["self"], **kwargs):
        assert self.__class__ is not Record

        try:
            fields = self.__class__.fields
        except AttributeError:
            self.__class__.fields = fields = set()

        if valuedict is not None:
            kwargs.update(valuedict)

        for key, value in kwargs.iteritems():
            if not key in exclude:
                fields.add(key)
                setattr(self, key, value)

    def copy(self, **kwargs):
        for f in self.__class__.fields:
            if f not in kwargs:
                try:
                    kwargs[f] = getattr(self, f)
                except AttributeError:
                    pass
        return self.__class__(**kwargs)

    def __getstate__(self):
        return dict(
                (key, getattr(self, key))
                for key in self.__class__.fields
                if hasattr(self, key))

    def __setstate__(self, valuedict):
        try:
            fields = self.__class__.fields
        except AttributeError:
            self.__class__.fields = fields = set()

        for key, value in valuedict.iteritems():
            fields.add(key)
            setattr(self, key, value)

    def __repr__(self):
        return "%s(%s)" % (
                self.__class__.__name__,
                ", ".join("%s=%r" % (fld, getattr(self, fld))
                    for fld in self.__class__.fields
                    if hasattr(self, fld)))

    def __eq__(self, other):
        return (self.__class__ == other.__class__
                and self.__getstate__() == other.__getstate__())

    def __ne__(self, other):
        return not self.__eq__(other)

# }}}




class Reference(object):
    def __init__(self, value):
        self.value = value

    def get(self):
        from warnings import warn
        warn("Reference.get() is deprecated -- use ref.value instead")
        return self.value

    def set(self, value):
        self.value = value






# {{{ dictionary with default 
class DictionaryWithDefault(object):
    def __init__(self, default_value_generator, start = {}):
        self._Dictionary = dict(start)
        self._DefaultGenerator = default_value_generator

    def __getitem__(self, index):
        try:
            return self._Dictionary[index]
        except KeyError:
            value = self._DefaultGenerator(index)
            self._Dictionary[index] = value
            return value

    def __setitem__(self, index, value):
        self._Dictionary[index] = value

    def __contains__(self, item):
        return True

    def iterkeys(self):
        return self._Dictionary.iterkeys()

    def __iter__(self):
        return self._Dictionary.__iter__()

    def iteritems(self):
        return self._Dictionary.iteritems()

# }}}



class FakeList(object):
    def __init__(self, f, length):
        self._Length = length
        self._Function = f

    def __len__(self):
        return self._Length

    def __getitem__(self, index):
        try:
            return [self._Function(i)
                    for i in range(*index.indices(self._Length))]
        except AttributeError:
            return self._Function(index)




# {{{ dependent dictionary ----------------------------------------------------
class DependentDictionary(object):
    def __init__(self, f, start = {}):
        self._Function = f
        self._Dictionary = start.copy()

    def copy(self):
        return DependentDictionary(self._Function, self._Dictionary)

    def __contains__(self, key):
        try:
            self[key]
            return True
        except KeyError:
            return False

    def __getitem__(self, key):
        try:
            return self._Dictionary[key]
        except KeyError:
            return self._Function(self._Dictionary, key)

    def __setitem__(self, key, value):
        self._Dictionary[key] = value

    def genuineKeys(self):
        return self._Dictionary.keys()

    def iteritems(self):
        return self._Dictionary.iteritems()

    def iterkeys(self):
        return self._Dictionary.iterkeys()

    def itervalues(self):
        return self._Dictionary.itervalues()

# }}}

# }}}

# {{{ assertive accessors -----------------------------------------------------
def one(iterable):
    """Return the first entry of *iterable*. Assert that *iterable* has only
    that one entry.
    """
    it = iter(iterable)
    try:
        v = it.next()
    except StopIteration:
        raise ValueError, "empty iterable passed to 'one()'"

    def no_more():
        try:
            v2 = it.next()
            raise ValueError, "iterable with more than one entry passed to 'one()'"
        except StopIteration:
            return True

    assert no_more()

    return v




def is_single_valued(iterable, equality_pred=operator.eq):
    it = iter(iterable)
    try:
        first_item = it.next()
    except StopIteration:
        raise ValueError, "empty iterable passed to 'single_valued()'"

    for other_item in it:
        if not equality_pred(other_item, first_item):
            return False
    return True




def single_valued(iterable, equality_pred=operator.eq):
    """Return the first entry of *iterable*; Assert that other entries
    are the same with the first entry of *iterable*.
    """
    it = iter(iterable)
    try:
        first_item = it.next()
    except StopIteration:
        raise ValueError, "empty iterable passed to 'single_valued()'"

    def others_same():
        for other_item in it:
            if not equality_pred(other_item, first_item):
                return False
        return True
    assert others_same()

    return first_item

# }}}

# {{{ memoization -------------------------------------------------------------
@my_decorator
def memoize(func, *args):
    # by Michele Simionato
    # http://www.phyast.pitt.edu/~micheles/python/

    try:
        return func._memoize_dic[args]
    except AttributeError:
        # _memoize_dic doesn't exist yet.

        result = func(*args)
        func._memoize_dic = {args: result}
        return result
    except KeyError:
        result = func(*args)
        func._memoize_dic[args] = result
        return result
FunctionValueCache = memoize




@my_decorator
def memoize_method(method, instance, *args):
    dicname = "_memoize_dic_"+method.__name__
    try:
        return getattr(instance, dicname)[args]
    except AttributeError:
        result = method(instance, *args)
        setattr(instance, dicname, {args: result})
        return result
    except KeyError:
        result = method(instance, *args)
        getattr(instance,dicname)[args] = result
        return result




FunctionValueCache = memoize

# }}}

# {{{ plotting ----------------------------------------------------------------
def write_1d_gnuplot_graph(f, a, b, steps=100, fname=",,f.data", progress = False):
    h = float(b - a)/steps
    gnuplot_file = file(fname, "w")

    def do_plot(func):
        for n in range(steps):
            if progress:
                sys.stdout.write(".")
                sys.stdout.flush()
            x = a + h * n
            gnuplot_file.write("%f\t%f\n" % (x, func(x)))

    do_plot(f)
    if progress:
        sys.stdout.write("\n")

def write_1d_gnuplot_graphs(f, a, b, steps=100, fnames=None, progress=False):
    h = float(b - a)/steps
    if not fnames:
        result_count = len(f(a))
        fnames = [",,f%d.data" % i for i in range(result_count)]

    gnuplot_files = [file(fname, "w") for fname in fnames]

    for n in range(steps):
        if progress:
            sys.stdout.write(".")
            sys.stdout.flush()
        x = a + h * n
        for gpfile, y in zip(gnuplot_files, f(x)):
            gpfile.write("%f\t%f\n" % (x, y))
    if progress:
        sys.stdout.write("\n")



def write_2d_gnuplot_graph(f, (x0, y0), (x1, y1), (xsteps, ysteps)=(100, 100), fname=",,f.data"):
    hx = float(x1 - x0)/xsteps
    hy = float(y1 - y0)/ysteps
    gnuplot_file = file(fname, "w")

    for ny in range(ysteps):
        for nx in range(xsteps):
            x = x0 + hx * nx
            y = y0 + hy * ny
            gnuplot_file.write("%g\t%g\t%g\n" % (x, y, f(x, y)))

        gnuplot_file.write("\n")


def write_gnuplot_graph(f, a, b, steps = 100, fname = ",,f.data", progress = False):
    h = float(b - a)/steps
    gnuplot_file = file(fname, "w")

    def do_plot(func):
        for n in range(steps):
            if progress:
                sys.stdout.write(".")
                sys.stdout.flush()
            x = a + h * n
            gnuplot_file.write("%f\t%f\n" % (x, func(x)))

    if isinstance(f, types.ListType):
        for f_index, real_f in enumerate(f):
            if progress:
                sys.stdout.write("function %d: " % f_index)
            do_plot(real_f)
            gnuplot_file.write("\n")
            if progress:
                sys.stdout.write("\n")
    else:
        do_plot(f)
        if progress:
            sys.stdout.write("\n")

# }}}

# {{{ syntactical sugar -------------------------------------------------------
class InfixOperator:
    """Pseudo-infix operators that allow syntax of the kind `op1 <<operator>> op2'.

    Following a recipe from
    http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/384122
    """
    def __init__(self, function):
        self.function = function
    def __rlshift__(self, other):
        return InfixOperator(lambda x: self.function(other, x))
    def __rshift__(self, other):
        return self.function(other)
    def call(self, a, b):
        return self.function(a, b)




def monkeypatch_method(cls):
    # from GvR, http://mail.python.org/pipermail/python-dev/2008-January/076194.html
    def decorator(func):
        setattr(cls, func.__name__, func)
        return func
    return decorator




def monkeypatch_class(name, bases, namespace):
    # from GvR, http://mail.python.org/pipermail/python-dev/2008-January/076194.html

    assert len(bases) == 1, "Exactly one base class required"
    base = bases[0]
    for name, value in namespace.iteritems():
        if name != "__metaclass__":
            setattr(base, name, value)
    return base

# }}}

# {{{ generic utilities -------------------------------------------------------
def add_tuples(t1, t2):
    return tuple([t1v + t2v for t1v, t2v in zip(t1, t2)])

def negate_tuple(t1):
    return tuple([-t1v for t1v in t1])





def shift(vec, dist):
    """Return a copy of C{vec} shifted by C{dist}.

    @postcondition: C{shift(a, i)[j] == a[(i+j) % len(a)]}
    """

    result = vec[:]

    N = len(vec)
    dist = dist % N

    # modulo only returns positive distances!
    if dist > 0:
        result[dist:] = vec[:N-dist]
        result[:dist] = vec[N-dist:]

    return result



def len_iterable(iterable):
    return sum(1 for i in iterable)




def flatten(list):
    """For an iterable of sub-iterables, generate each member of each
    sub-iterable in turn, i.e. a flattened version of that super-iterable.

    Example: Turn [[a,b,c],[d,e,f]] into [a,b,c,d,e,f].
    """
    for sublist in list:
        for j in sublist:
            yield j




def general_sum(sequence):
    return reduce(operator.add, sequence)




def linear_combination(coefficients, vectors):
    result = coefficients[0] * vectors[0]
    for c,v in zip(coefficients, vectors)[1:]:
        result += c*v
    return result




def all_equal(iterable):
    it = iterable.__iter__()
    try:
        value = it.next()
    except StopIteration:
        return True # empty sequence

    for i in it:
        if i != value:
            return False
    return True




def all_roughly_equal(iterable, threshold):
    it = iterable.__iter__()
    try:
        value = it.next()
    except StopIteration:
        return True # empty sequence

    for i in it:
        if abs(i - value) > threshold:
            return False
    return True




def common_prefix(iterable, empty=None):
    it = iter(iterable)
    try:
        pfx = it.next()
    except StopIteration:
        return  empty

    for v in it:
        for j in range(len(pfx)):
            if pfx[j] != v[j]:
                pfx = pfx[:j]
                if j == 0:
                    return pfx
                break

    return pfx




def decorate(function, list):
    return map(lambda x: (x, function(x)), list)




def partition(criterion, list):
    part_true = []
    part_false = []
    for i in list:
        if criterion(i):
            part_true.append(i)
        else:
            part_false.append(i)
    return part_true, part_false




def partition2(iterable):
    part_true = []
    part_false = []
    for pred, i in iterable:
        if pred:
            part_true.append(i)
        else:
            part_false.append(i)
    return part_true, part_false




def product(iterable):
    from operator import mul
    return reduce(mul, iterable, 1)




try:
    all = __builtins__.all
    any = __builtins__.any
except AttributeError:
    def all(iterable):
        for i in iterable:
            if not i:
                return False
        return True

    def any(iterable):
        for i in iterable:
            if i:
                return True
        return False






def reverse_dictionary(the_dict):
    result = {}
    for key, value in the_dict.iteritems():
        if value in result:
            raise RuntimeError(
                    "non-reversible mapping, duplicate key '%s'" % value)
        result[value] = key
    return result

def set_sum(set_iterable):
    from operator import or_
    return reduce(or_, set_iterable, set())




def div_ceil(nr, dr):
    return -(-nr // dr)




def uniform_interval_splitting(n, granularity, max_intervals):
    """ Return *(interval_size, num_intervals)* such that::

        num_intervals * interval_size >= n

    and::

        (num_intervals - 1) * interval_size < n

    and *interval_size* is a multiple of *granularity*.
    """
    # ported from Thrust -- minor Apache v2 license violation

    grains  = div_ceil(n, granularity)

    # one grain per interval
    if grains <= max_intervals:
        return granularity, grains

    grains_per_interval = div_ceil(grains, max_intervals)
    interval_size = grains_per_interval * granularity
    num_intervals = div_ceil(n, interval_size)

    return interval_size, num_intervals




def find_max_where(predicate, prec=1e-5, initial_guess=1, fail_bound=1e38):
    """Find the largest value for which a predicate is true,
    along a half-line. 0 is assumed to be the lower bound."""

    # {{{ establish bracket

    mag = 1

    if predicate(mag):
        mag *= 2
        while predicate(mag):
            mag *= 2

            if mag > fail_bound:
                raise RuntimeError("predicate appears to be true "
                        "everywhere, up to %g" % fail_bound)

        lower_true = mag/2
        upper_false = mag
    else:
        mag /= 2

        while not predicate(mag):
            mag /= 2

            if mag < prec:
                return mag

        lower_true = mag
        upper_false = mag*2

    # }}}

    # {{{ refine

    # Refine a bracket between *lower_true*, where the predicate is true,
    # and *upper_false*, where it is false, until *prec* is satisfied.

    assert predicate(lower_true)
    assert not predicate(upper_false)

    while abs(lower_true-upper_false) > prec:
        mid = (lower_true+upper_false)/2
        if predicate(mid):
            lower_true = mid
        else:
            upper_false = mid
    else:
        return lower_true

    # }}}

# }}}

# {{{ argmin, argmax ----------------------------------------------------------
def argmin_f(list, f = lambda x: x):
    # deprecated -- the function has become unnecessary because of
    # generator expressions
    current_min_index = -1
    current_min = f(list[0])

    for idx, item in enumerate(list[1:]):
        value = f(item)
        if value < current_min:
            current_min_index = idx
            current_min = value
    return current_min_index+1




def argmax_f(list, f = lambda x: x):
    # deprecated -- the function has become unnecessary because of
    # generator expressions
    current_max_index = -1
    current_max = f(list[0])

    for idx, item in enumerate(list[1:]):
        value = f(item)
        if value > current_max:
            current_max_index = idx
            current_max = value
    return current_max_index+1




def argmin(iterable):
    return argmin2(enumerate(iterable))




def argmax(iterable):
    return argmax2(enumerate(iterable))




def argmin2(iterable, return_value=False):
    it = iter(iterable)
    try:
        current_argmin, current_min = it.next()
    except StopIteration:
        raise ValueError, "argmin of empty iterable"

    for arg, item in it:
        if item < current_min:
            current_argmin = arg
            current_min = item

    if return_value:
        return current_argmin, current_min
    else:
        return current_argmin




def argmax2(iterable, return_value=False):
    it = iter(iterable)
    try:
        current_argmax, current_max = it.next()
    except StopIteration:
        raise ValueError, "argmax of empty iterable"

    for arg, item in it:
        if item > current_max:
            current_argmax = arg
            current_max = item

    if return_value:
        return current_argmax, current_max
    else:
        return current_argmax

# }}}

# {{{ cartesian products etc. -------------------------------------------------
def cartesian_product(list1, list2):
    for i in list1:
        for j in list2:
            yield (i,j)





def distinct_pairs(list1, list2):
    for i, xi in enumerate(list1):
        for j, yj in enumerate(list2):
            if i != j:
                yield (xi, yj)




def cartesian_product_sum(list1, list2):
    """This routine returns a list of sums of each element of
    list1 with each element of list2. Also works with lists.
    """
    for i in list1:
        for j in list2:
            yield i+j

# }}}

# {{{ elementary statistics ---------------------------------------------------
def average(iterable):
    """Return the average of the values in iterable.

    iterable may not be empty.
    """
    it = iterable.__iter__()

    try:
        sum = it.next()
        count = 1
    except StopIteration:
        raise ValueError, "empty average"

    for value in it:
        sum = sum + value
        count += 1

    return sum/count




class VarianceAggregator:
    """Online variance calculator.
    See http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
    Adheres to pysqlite's aggregate interface.
    """
    def __init__(self, entire_pop):
        self.n = 0
        self.mean = 0
        self.m2 = 0

        self.entire_pop = entire_pop

    def step(self, x):
        self.n += 1
        delta = x - self.mean
        self.mean += delta/self.n
        self.m2 += delta*(x - self.mean)

    def finalize(self):
        if self.entire_pop:
            if self.n == 0:
                return None
            else:
                return self.m2/self.n
        else:
            if self.n <= 1:
                return None
            else:
                return self.m2/(self.n - 1)




def variance(iterable, entire_pop):
    v_comp = VarianceAggregator(entire_pop)

    for x in iterable:
        v_comp.step(x)

    return v_comp.finalize()




def std_deviation(iterable, finite_pop):
    from math import sqrt
    return sqrt(variance(iterable, finite_pop))

# }}}

# {{{ permutations, tuples, integer sequences ---------------------------------
def wandering_element(length, wanderer=1, landscape=0):
    for i in range(length):
        yield i*(landscape,) + (wanderer,) + (length-1-i)*(landscape,)




def indices_in_shape(shape):
    if len(shape) == 0:
        yield ()
    elif len(shape) == 1:
        for i in xrange(0, shape[0]):
            yield (i,)
    else:
        remainder = shape[1:]
        for i in xrange(0, shape[0]):
            for rest in indices_in_shape(remainder):
                yield (i,)+rest




def generate_nonnegative_integer_tuples_below(n, length=None, least=0):
    """n may be a sequence, in which case length must be None."""
    if length is None:
        if len(n) == 0:
            yield ()
            return

        my_n = n[0]
        n = n[1:]
        next_length = None
    else:
        my_n = n

        assert length >= 0
        if length == 0:
            yield ()
            return

        next_length = length-1

    for i in range(least, my_n):
        my_part = (i,)
        for base in generate_nonnegative_integer_tuples_below(n, next_length, least):
            yield my_part + base

def generate_decreasing_nonnegative_tuples_summing_to(n, length, min=0, max=None):
    sig = (n,length,max)
    if length == 0:
        yield ()
    elif length == 1:
        if n <= max:
            #print "MX", n, max
            yield (n,)
        else:
            return
    else:
        if max is None or n < max:
            max = n

        for i in range(min, max+1):
            #print "SIG", sig, i
            for remainder in generate_decreasing_nonnegative_tuples_summing_to(
                    n-i, length-1, min, i):
                yield (i,) + remainder


def generate_nonnegative_integer_tuples_summing_to_at_most(n, length):
    """Enumerate all non-negative integer tuples summing to at most n,
    exhausting the search space by varying the first entry fastest,
    and the last entry the slowest.
    """
    assert length >= 0
    if length == 0:
        yield ()
    else:
        for i in range(n+1):
            for remainder in generate_nonnegative_integer_tuples_summing_to_at_most(
                    n-i, length-1):
                yield remainder + (i,)

def generate_all_nonnegative_integer_tuples(length, least=0):
    assert length >= 0
    current_max = least
    while True:
        for max_pos in range(length):
            for prebase in generate_nonnegative_integer_tuples_below(current_max, max_pos, least):
                for postbase in generate_nonnegative_integer_tuples_below(current_max+1, length-max_pos-1, least):
                    yield prebase + [current_max] + postbase
        current_max += 1

 # backwards compatibility
generate_positive_integer_tuples_below = generate_nonnegative_integer_tuples_below
generate_all_positive_integer_tuples = generate_all_nonnegative_integer_tuples

def _pos_and_neg_adaptor(tuple_iter):
    for tup in tuple_iter:
        nonzero_indices = [i for i in range(len(tup)) if tup[i] != 0]
        for do_neg_tup in generate_nonnegative_integer_tuples_below(2, len(nonzero_indices)):
            this_result = list(tup)
            for index, do_neg in enumerate(do_neg_tup):
                if do_neg:
                    this_result[nonzero_indices[index]] *= -1
            yield tuple(this_result)

def generate_all_integer_tuples_below(n, length, least_abs=0):
    return _pos_and_neg_adaptor(generate_nonnegative_integer_tuples_below(
        n, length, least_abs))

def generate_all_integer_tuples(length, least_abs=0):
    return _pos_and_neg_adaptor(generate_all_nonnegative_integer_tuples(
        length, least_abs))





def generate_permutations(original):
    """Generate all permutations of the list `original'.

    Nicked from http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/252178
    """
    if len(original) <=1:
        yield original
    else:
        for perm in generate_permutations(original[1:]):
            for i in range(len(perm)+1):
                #nb str[0:1] works in both string and list contexts
                yield perm[:i] + original[0:1] + perm[i:]






def generate_unique_permutations(original):
    """Generate all unique permutations of the list `original'.
    """

    had_those = set()

    for perm in generate_permutations(original):
        if perm not in had_those:
            had_those.add(perm)
            yield perm

def enumerate_basic_directions(dimensions):
    coordinate_list = [[0], [1], [-1]]
    return reduce(cartesian_product_sum, [coordinate_list] * dimensions)[1:]

# }}}

# {{{ index mangling ----------------------------------------------------------
def get_read_from_map_from_permutation(original, permuted):
    """With a permutation given by C{original} and C{permuted},
    generate a list C{rfm} of indices such that
    C{permuted[i] == original[rfm[i]]}.

    Requires that the permutation can be inferred from
    C{original} and C{permuted}.

    >>> for p1 in generate_permutations(range(5)):
    ...     for p2 in generate_permutations(range(5)):
    ...         rfm = get_read_from_map_from_permutation(p1, p2)
    ...         p2a = [p1[rfm[i]] for i in range(len(p1))]
    ...         assert p2 == p2a
    """
    assert len(original) == len(permuted)
    where_in_original = dict(
            (original[i], i) for i in xrange(len(original)))
    assert len(where_in_original) == len(original)
    return tuple(where_in_original[pi] for pi in permuted)




def get_write_to_map_from_permutation(original, permuted):
    """With a permutation given by C{original} and C{permuted},
    generate a list C{wtm} of indices such that
    C{permuted[wtm[i]] == original[i]}.

    Requires that the permutation can be inferred from
    C{original} and C{permuted}.

    >>> for p1 in generate_permutations(range(5)):
    ...     for p2 in generate_permutations(range(5)):
    ...         wtm = get_write_to_map_from_permutation(p1, p2)
    ...         p2a = [0] * len(p2)
    ...         for i, oi in enumerate(p1):
    ...             p2a[wtm[i]] = oi
    ...         assert p2 == p2a
    """
    assert len(original) == len(permuted)

    where_in_permuted = dict(
            (permuted[i], i) for i in xrange(len(permuted)))

    assert len(where_in_permuted) == len(permuted)
    return tuple(where_in_permuted[oi] for oi in original)

# }}}

# {{{ graph algorithms

def a_star(initial_state, goal_state, neighbor_map,
        estimate_remaining_cost=None,
        get_step_cost=lambda x, y: 1):
    """
    With the default cost and heuristic, this amounts to Dijkstra's algorithm.
    """

    from heapq import heappop, heappush

    if estimate_remaining_cost is None:
        def estimate_remaining_cost(x):
            if x != goal_state:
                return 1
            else:
                return 0

    class AStarNode(object):
        __slots__ = ["state", "parent", "path_cost"]
        def __init__(self, state, parent, path_cost):
            self.state = state
            self.parent = parent
            self.path_cost = path_cost

    inf = float("inf")
    init_remcost = estimate_remaining_cost(initial_state)
    assert init_remcost != inf

    queue = [(init_remcost, AStarNode(initial_state, parent=None, path_cost=0))]
    visited_states = set()

    while len(queue):
        _, top = heappop(queue)
        visited_states.add(top.state)

        if top.state == goal_state:
            result = []
            it = top
            while it is not None:
                result.append(it.state)
                it = it.parent
            return result[::-1]

        for state in neighbor_map[top.state]:
            if state in visited_states:
                continue

            remaining_cost = estimate_remaining_cost(state)
            if remaining_cost == inf:
                continue
            step_cost = get_step_cost(top, state)

            estimated_path_cost = top.path_cost+step_cost+remaining_cost
            heappush(queue, 
                (estimated_path_cost, 
                    AStarNode(state, top, path_cost=top.path_cost + step_cost)))

    raise RuntimeError("no solution")

# }}}

# {{{ formatting --------------------------------------------------------------

# {{{ table formatting --------------------------------------------------------
class Table:
    """An ASCII table generator."""
    def __init__(self):
        self.rows = []

    def add_row(self, row):
        self.rows.append([str(i) for i in row])

    def __str__(self):
        columns = len(self.rows[0])
        col_widths = [max(len(row[i]) for row in self.rows)
                      for i in range(columns)]

        lines = [
            "|".join([cell.ljust(col_width)
                      for cell, col_width in zip(row, col_widths)])
            for row in self.rows]
        lines[1:1] = ["+".join("-"*col_width
                              for col_width in col_widths)]
        return "\n".join(lines)

    def latex(self, skip_lines=0, hline_after=[]):
        lines = []
        for row_nr, row in list(enumerate(self.rows))[skip_lines:]:
            lines.append(" & ".join(row)+r" \\")
            if row_nr in hline_after:
                lines.append(r"\hline")

        return "\n".join(lines)

# }}}

# {{{ histogram formatting ----------------------------------------------------
def string_histogram(iterable, min_value=None, max_value=None, bin_count=20, width=70,
        bin_starts=None, use_unicode=True):
    if bin_starts is None:
        if min_value is None or max_value is None:
            iterable = list(iterable)
            min_value = min(iterable)
            max_value = max(iterable)

        bin_width = (max_value - min_value)/bin_count
        bin_starts = [min_value+bin_width*i for i in range(bin_count)]

    bins = [0 for i in range(len(bin_starts))]

    from bisect import bisect
    for value in iterable:
        if max_value is not None and value > max_value or value < bin_starts[0]:
            from warnings import warn
            warn("string_histogram: out-of-bounds value ignored")
        else:
            bin_nr = bisect(bin_starts, value)-1
            try:
                bins[bin_nr] += 1
            except:
                print value, bin_nr, bin_starts
                raise

    from math import floor, ceil
    if use_unicode:
        def format_bar(cnt):
            scaled = cnt*width/max_count
            full = int(floor(scaled))
            eighths = int(ceil((scaled-full)*8))
            if eighths:
                return full*unichr(0x2588) + unichr(0x2588+(8-eighths))
            else:
                return full*unichr(0x2588)
    else:
        def format_bar(cnt):
            return int(ceil(cnt*width/max_count))*"#"

    max_count = max(bins)
    total_count = sum(bins)
    return "\n".join("%9g |%9d | %3.0f %% | %s" % (
        bin_start,
        bin_value,
        bin_value/total_count*100,
        format_bar(bin_value))
        for bin_start, bin_value in zip(bin_starts, bins))

# }}}

def word_wrap(text, width, wrap_using="\n"):
    # http://code.activestate.com/recipes/148061-one-liner-word-wrap-function/
    """
    A word-wrap function that preserves existing line breaks
    and most spaces in the text. Expects that existing line
    breaks are posix newlines (\n).
    """
    space_or_break = [" ", wrap_using]
    return reduce(lambda line, word, width=width: '%s%s%s' %
            (line,
                space_or_break[(len(line)-line.rfind('\n')-1
                    + len(word.split('\n',1)[0]
                        ) >= width)],
                    word),
            text.split(' ')
            )

# }}}

# {{{ command line interfaces -------------------------------------------------

class CPyUserInterface(object):
    class Parameters(Record):
        pass

    def __init__(self, variables, constants={}, doc={}):
        self.variables = variables
        self.constants = constants
        self.doc = doc

    def show_usage(self, progname):
        print "usage: %s <FILE-OR-STATEMENTS>" % progname
        print
        print "FILE-OR-STATEMENTS may either be Python statements of the form"
        print "'variable1 = value1; variable2 = value2' or the name of a file"
        print "containing such statements. Any valid Python code may be used"
        print "on the command line or in a command file. If new variables are"
        print "used, they must start with 'user_' or just '_'."
        print
        print "The following variables are recognized:"
        for v in sorted(self.variables):
            print "  %s = %s" % (v, self.variables[v])
            if v in self.doc:
                print "    %s" % self.doc[v]

        print
        print "The following constants are supplied:"
        for c in sorted(self.constants):
            print "  %s = %s" % (c, self.constants[c])
            if c in self.doc:
                print "    %s" % self.doc[c]

    def gather(self, argv=None):
        import sys

        if argv is None:
            argv = sys.argv

        if len(argv) == 1 or (
                ("-h" in argv) or
                ("help" in argv) or
                ("-help" in argv) or
                ("--help" in argv)):
            self.show_usage(argv[0])
            sys.exit(2)

        execenv = self.variables.copy()
        execenv.update(self.constants)

        import os
        for arg in argv[1:]:
            if os.access(arg, os.F_OK):
                exec open(arg, "r") in execenv
            else:
                exec arg in execenv

        # check if the user set invalid keys
        for added_key in (
                set(execenv.keys())
                - set(self.variables.keys())
                - set(self.constants.keys())):
            if not (added_key.startswith("user_") or added_key.startswith("_")):
                raise ValueError(
                        "invalid setup key: '%s' "
                        "(user variables must start with 'user_' or '_')" % added_key)

        result = self.Parameters(dict((key, execenv[key]) for key in self.variables))
        self.validate(result)
        return result

    def validate(self, setup):
        pass

# }}}

# {{{ code maintenance --------------------------------------------------------

class MovedFunctionDeprecationWrapper:
    def __init__(self, f):
        self.f = f

    def __call__(self, *args, **kwargs):
        from warnings import warn
        warn("This function is deprecated. Use %s.%s instead." % (
            self.f.__module__, self.f.__name__),
            DeprecationWarning, stacklevel=2)

        return self.f(*args, **kwargs)

# }}}

# {{{ debugging ---------------------------------------------------------------

def typedump(val, max_seq=5, special_handlers={}):
    try:
        hdlr = special_handlers[type(val)]
    except KeyError:
        pass
    else:
        return hdlr(val)

    try:
        len(val)
    except TypeError:
        return type(val).__name__
    else:
        if isinstance(val, dict):
            return "{%s}" % (
                    ", ".join(
                        "%r: %s" % (str(k), typedump(v))
                        for k, v in val.iteritems()))

        try:
            if len(val) > max_seq:
                return "%s(%s,...)" % (
                        type(val).__name__,
                        ",".join(typedump(x, max_seq, special_handlers)
                            for x in val[:max_seq]))
            else:
                return "%s(%s)" % (
                        type(val).__name__,
                        ",".join(typedump(x, max_seq, special_handlers)
                            for x in val))
        except TypeError:
            return val.__class__.__name__




def invoke_editor(s, filename="edit.txt", descr="the file"):
    from tempfile import mkdtemp
    tempdir = mkdtemp()

    from os.path import join
    full_name = join(tempdir, filename)

    outf = open(full_name, "w")
    outf.write(str(s))
    outf.close()

    import os
    if "EDITOR" in os.environ:
        from subprocess import Popen
        p = Popen([os.environ["EDITOR"], full_name])
        os.waitpid(p.pid, 0)[1]
    else:
        print "(Set the EDITOR environment variable to be " \
                "dropped directly into an editor next time.)"
        raw_input("Edit %s at %s now, then hit [Enter]:"
                % (descr, full_name))

    inf = open(full_name, "r")
    result = inf.read()
    inf.close()

    return result

# }}}

# {{{ progress bars -----------------------------------------------------------
class ProgressBar:
    def __init__(self, descr, total, initial=0, length=40):
        import time
        self.description = descr
        self.total = total
        self.done = initial
        self.length = length
        self.last_squares = -1
        self.start_time = time.time()
        self.last_update_time = self.start_time

        self.speed_meas_start_time = self.start_time
        self.speed_meas_start_done = initial

        self.time_per_step = None

    def draw(self):
        import time

        now = time.time()
        squares = int(self.done/self.total*self.length)
        if squares != self.last_squares or now-self.last_update_time > 0.5:
            if (self.done != self.speed_meas_start_done
                    and now-self.speed_meas_start_time > 3):
                new_time_per_step = (now-self.speed_meas_start_time) \
                        / (self.done-self.speed_meas_start_done)
                if self.time_per_step is not None:
                    self.time_per_step = (new_time_per_step + self.time_per_step)/2
                else:
                    self.time_per_step = new_time_per_step

                self.speed_meas_start_time = now
                self.speed_meas_start_done = self.done

            if self.time_per_step is not None:
                eta_str = "%6.1fs" % max(0, (self.total-self.done) * self.time_per_step)
            else:
                eta_str = "?"

            import sys
            sys.stderr.write("%-20s [%s] ETA %s\r" % (
                self.description,
                squares*"#"+(self.length-squares)*" ",
                eta_str))

            self.last_squares = squares
            self.last_update_time = now

    def progress(self, steps=1):
        self.set_progress(self.done + steps)

    def set_progress(self, done):
        self.done = done
        self.draw()

    def finished(self):
        import sys
        self.set_progress(self.total)
        sys.stderr.write("\n")

# }}}

# {{{ file system related -----------------------------------------------------
def assert_not_a_file(name):
    import os
    if os.access(name, os.F_OK):
        raise IOError, "file `%s' already exists" % name


def add_python_path_relative_to_script(rel_path):
    import sys
    from os.path import dirname, join, abspath

    script_name = sys.argv[0]
    rel_script_dir = dirname(script_name)

    sys.path.append(abspath(join(rel_script_dir, rel_path)))

# }}}

# {{{ numpy dtype mangling ----------------------------------------------------
def common_dtype(dtypes, default=None):
    dtypes = list(dtypes)
    if dtypes:
        return argmax2((dtype, dtype.num) for dtype in dtypes)
    else:
        if default is not None:
            return default
        else:
            raise ValueError(
                    "cannot find common dtype of empty dtype list")





def to_uncomplex_dtype(dtype):
    import numpy
    if dtype == numpy.complex64:
        return numpy.float32
    elif dtype == numpy.complex128:
        return numpy.float64
    if dtype == numpy.float32:
        return numpy.float32
    elif dtype == numpy.float64:
        return numpy.float64
    else:
        raise TypeError("unrecgonized dtype '%s'" % dtype)




def match_precision(dtype, dtype_to_match):
    import numpy

    tgt_is_double = dtype_to_match in [
            numpy.float64, numpy.complex128]

    dtype_is_complex = dtype.kind == "c"
    if dtype_is_complex:
        if tgt_is_double:
            return numpy.dtype(numpy.complex128)
        else:
            return numpy.dtype(numpy.complex64)
    else:
        if tgt_is_double:
            return numpy.dtype(numpy.float64)
        else:
            return numpy.dtype(numpy.float32)

# }}}




def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

# vim: foldmethod=marker
