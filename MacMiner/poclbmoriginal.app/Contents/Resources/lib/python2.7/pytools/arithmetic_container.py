from __future__ import division
from decorator import decorator
import operator




class ArithmeticList(list):
    """A list with elementwise arithmetic operations."""

    def assert_same_length(self, other):
        assert len(self) == len(other)

    def unary_operator(self, operator):
        return ArithmeticList(operator(v) for v in self)

    def binary_operator(self, other, operator):
        if not isinstance(other, ArithmeticList):
            return ArithmeticList(operator(v, other) for v in self)

        self.assert_same_length(other)
        return ArithmeticList(operator(v, w) for v, w in zip(self, other))

    def reverse_binary_operator(self, other, operator):
        if not isinstance(other, ArithmeticList):
            return ArithmeticList(operator(other, v) for v in self)

        self.assert_same_length(other)
        return ArithmeticList(operator(w, v) for v, w in zip(self, other))

    def __neg__(self): return self.unary_operator(operator.neg)
    def __pos__(self): return self.unary_operator(operator.pos)
    def __abs__(self): return self.unary_operator(operator.abs)
    def __invert__(self): return self.unary_operator(operator.invert)

    def __add__(self, other): return self.binary_operator(other, operator.add)
    def __sub__(self, other): return self.binary_operator(other, operator.sub)
    def __mul__(self, other): return self.binary_operator(other, operator.mul)
    def __div__(self, other): return self.binary_operator(other, operator.div)
    def __truediv__(self, other): return self.binary_operator(other, operator.truediv)
    def __floordiv__(self, other): return self.binary_operator(other, operator.floordiv)
    def __mod__(self, other): return self.binary_operator(other, operator.mod)
    def __pow__(self, other): return self.binary_operator(other, operator.pow)
    def __lshift__(self, other): return self.binary_operator(other, operator.lshift)
    def __rshift__(self, other): return self.binary_operator(other, operator.rshift)
    def __and__(self, other): return self.binary_operator(other, operator.and_)
    def __or__(self, other): return self.binary_operator(other, operator.or_)
    def __xor__(self, other): return self.binary_operator(other, operator.xor)

    def __radd__(self, other): return self.reverse_binary_operator(other, operator.add)
    def __rsub__(self, other): return self.reverse_binary_operator(other, operator.sub)
    def __rmul__(self, other): return self.reverse_binary_operator(other, operator.mul)
    def __rdiv__(self, other): return self.reverse_binary_operator(other, operator.div)
    def __rtruediv__(self, other): return self.reverse_binary_operator(other, operator.truediv)
    def __rfloordiv__(self, other): return self.reverse_binary_operator(other, operator.floordiv)
    def __rmod__(self, other): return self.reverse_binary_operator(other, operator.mod)
    def __rpow__(self, other): return self.reverse_binary_operator(other, operator.pow)
    def __rlshift__(self, other): return self.reverse_binary_operator(other, operator.lshift)
    def __rrshift__(self, other): return self.reverse_binary_operator(other, operator.rshift)
    def __rand__(self, other): return self.reverse_binary_operator(other, operator.and_)
    def __ror__(self, other): return self.reverse_binary_operator(other, operator.or_)
    def __rxor__(self, other): return self.reverse_binary_operator(other, operator.xor)

    def __iadd__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] += other[i]
        return self

    def __isub__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] -= other[i]
        return self

    def __imul__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] *= other[i]
        return self

    def __idiv__(self, other): 
        from operator import div
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] = div(self[i], other[i])
        return self

    def __itruediv__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] /= other[i]
        return self

    def __ifloordiv__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] //= other[i]
        return self

    def __imod__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] %= other[i]
        return self

    def __ipow__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] **= other[i]
        return self

    def __ilshift__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] <<= other[i]
        return self

    def __irshift__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] >>= other[i]
        return self

    def __iand__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] &= other[i]
        return self

    def __ior__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] |= other[i]
        return self

    def __ixor__(self, other): 
        self.assert_same_length(other)
        for i in range(len(self)): 
            self[i] ^= other[i]
        return self

    def __getslice__(self, i, j):
        return ArithmeticList(list.__getslice__(self, i, j))

    def __str__(self):
        return "ArithmeticList(%s)" % list.__repr__(self)

    def __repr__(self):
        return "ArithmeticList(%s)" % list.__repr__(self)

    def plus(self, other):
        """Return a copy of self extended by the entries from the iterable
        C{other}.
        
        Makes up for the loss of the C{+} operator (which is now arithmetic).
        """
        result = ArithmeticList(self)
        result.extend(other)
        return result




def join_fields(*fields):
    result = ArithmeticList()
    for f in fields:
        if isinstance(f, (ArithmeticList, list)):
            result.extend(f)
        else:
            result.append(f)
    return result




@decorator
def work_with_arithmetic_containers(f, *args, **kwargs):
    """This decorator allows simple elementwise functions to automatically
    accept containers of arithmetic types, by acting on each element.

    At present, it only works for ArithmeticList.
    """

    class SimpleArg:
        def __init__(self, arg_number):
            self.arg_number = arg_number

        def eval(self, current_tp):
            return args[self.arg_number]

    class SimpleKwArg:
        def __init__(self, arg_name):
            self.arg_name = arg_name

        def eval(self, current_tp):
            return kwargs[self.arg_name]

    class ListArg:
        def __init__(self, list_number):
            self.list_number = list_number

        def eval(self, current_tp):
            return current_tp[self.list_number]

    lists = []
    formal_args = []
    formal_kwargs = {}

    for arg in args:
        if isinstance(arg, ArithmeticList):
            formal_args.append(ListArg(len(lists)))
            lists.append(arg)
        else:
            formal_args.append(SimpleArg(len(formal_args)))

    for name, arg in kwargs.iteritems():
        if isinstance(arg, ArithmeticList):
            formal_kwargs[name] = ListArg(len(lists))
            lists.append(arg)
        else:
            formal_kwargs[name] = SimpleKwArg(name)

    if lists:
        from pytools import all_equal
        assert all_equal(len(lst) for lst in lists)

        return ArithmeticList(
                f(
                    *list(formal_arg.eval(tp) for formal_arg in formal_args), 
                    **dict((name, formal_arg.eval(tp)) 
                        for name, formal_arg in formal_kwargs.iteritems())
                    )
                for tp in zip(*lists))
    else:
        return f(*args, **kwargs)




def outer_product(al1, al2, mult_op=operator.mul):
    return ArithmeticListMatrix(
            [[mult_op(al1i, al2i) for al2i in al2] for al1i in al1]
            )




class ArithmeticListMatrix:
    """A matrix type that operates on L{ArithmeticLists}."""
    def __init__(self, matrix):
        """Initialize the ArithmeticListMatrix.

        C{matrix} must allow the following interface:

          - len(matrix) gives the height of the matrix.
          - matrix is iterable, giving the rows of the matrix.

        Each row, in turn, must support C{len()} and iteration.
        """
        self.matrix = matrix

    def times(self, other, mult_op):
        if not isinstance(other, ArithmeticList):
            raise NotImplementedError

        result = ArithmeticList(None for i in range(len(self.matrix)))

        for i, row in enumerate(self.matrix):
            if len(row) != len(other):
                raise ValueError, "matrix width does not match ArithmeticList"

            for j, entry in enumerate(row):
                if not isinstance(entry, (int, float)) or entry:
                    if not isinstance(entry, (int, float)) or entry != 1:
                        contrib = mult_op(entry, other[j])
                    else:
                        contrib = other[j]

                    if result[i] is None:
                        result[i] = contrib
                    else:
                        result[i] += contrib

        for i in range(len(result)):
            if result[i] is None and len(other):
                result[i] = 0 * other[0]

        return result

    def __mul__(self, other):
        if not isinstance(other, ArithmeticList):
            return NotImplemented

        from operator import mul
        return self.times(other, mul)

    def map(self, entry_map):
        return ArithmeticListMatrix([[
            entry_map(entry)
            for j, entry in enumerate(row)]
            for i, row in enumerate(self.matrix)])




class ArithmeticDictionary(dict):
    """A dictionary with elementwise (on the values, not the keys) 
    arithmetic operations."""

    def _get_empty_self(self):
        return ArithmeticDictionary()

    def assert_same_keys(self, other):
        for key in self:
            assert key in other
        for key in other:
            assert key in self

    def unary_operator(self, operator):
        result = self._get_empty_self()
        for key in self:
            result[key] = operator(self[key])
        return result

    def binary_operator(self, other, operator):
        try:
            self.assert_same_keys(other)
            result = self._get_empty_self()
            for key in self:
                result[key] = operator(self[key], other[key])
            return result
        except TypeError:
            result = self._get_empty_self()
            for key in self:
                result[key] = operator(self[key], other)
            return result

    def reverse_binary_operator(self, other, operator):
        try:
            self.assert_same_keys(other)
            result = self._get_empty_self()
            for key in self:
                result[key] = operator(other[key], self[key])
            return result
        except TypeError:
            result = self._get_empty_self()
            for key in self:
                result[key] = operator(other, self[key])
            return result

    def __neg__(self): return self.unary_operator(operator.neg)
    def __pos__(self): return self.unary_operator(operator.pos)
    def __abs__(self): return self.unary_operator(operator.abs)
    def __invert__(self): return self.unary_operator(operator.invert)

    def __add__(self, other): return self.binary_operator(other, operator.add)
    def __sub__(self, other): return self.binary_operator(other, operator.sub)
    def __mul__(self, other): return self.binary_operator(other, operator.mul)
    def __div__(self, other): return self.binary_operator(other, operator.div)
    def __mod__(self, other): return self.binary_operator(other, operator.mod)
    def __pow__(self, other): return self.binary_operator(other, operator.pow)
    def __lshift__(self, other): return self.binary_operator(other, operator.lshift)
    def __rshift__(self, other): return self.binary_operator(other, operator.rshift)
    def __and__(self, other): return self.binary_operator(other, operator.and_)
    def __or__(self, other): return self.binary_operator(other, operator.or_)
    def __xor__(self, other): return self.binary_operator(other, operator.xor)

    def __radd__(self, other): return self.reverse_binary_operator(other, operator.add)
    def __rsub__(self, other): return self.reverse_binary_operator(other, operator.sub)
    def __rmul__(self, other): return self.reverse_binary_operator(other, operator.mul)
    def __rdiv__(self, other): return self.reverse_binary_operator(other, operator.div)
    def __rmod__(self, other): return self.reverse_binary_operator(other, operator.mod)
    def __rpow__(self, other): return self.reverse_binary_operator(other, operator.pow)
    def __rlshift__(self, other): return self.reverse_binary_operator(other, operator.lshift)
    def __rrshift__(self, other): return self.reverse_binary_operator(other, operator.rshift)
    def __rand__(self, other): return self.reverse_binary_operator(other, operator.and_)
    def __ror__(self, other): return self.reverse_binary_operator(other, operator.or_)
    def __rxor__(self, other): return self.reverse_binary_operator(other, operator.xor)

    def __iadd__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] += other[key]
        return self

    def __isub__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] -= other[key]
        return self

    def __imul__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] *= other[key]
        return self

    def __idiv__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] /= other[key]
        return self

    def __imod__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] %= other[key]
        return self

    def __ipow__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] **= other[key]
        return self

    def __ilshift__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] <<= other[key]
        return self

    def __irshift__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] >>= other[key]
        return self

    def __iand__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] &= other[key]
        return self

    def __ior__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] |= other[key]
        return self

    def __ixor__(self, other): 
        self.assert_same_keys(other)
        for key in self: 
            self[key] ^= other[key]
        return self
