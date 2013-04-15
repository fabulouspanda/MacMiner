from __future__ import division
from pytools import memoize_method
import numpy as np




def f_contiguous_strides(itemsize, shape):
    if shape:
        strides = [itemsize]
        for s in shape[:-1]:
            strides.append(strides[-1]*s)
        return tuple(strides)
    else:
        return ()

def c_contiguous_strides(itemsize, shape):
    if shape:
        strides = [itemsize]
        for s in shape[:0:-1]:
            strides.append(strides[-1]*s)
        return tuple(strides[::-1])
    else:
        return ()




class ArrayFlags:
    def __init__(self, ary):
        self.array = ary

    @property
    @memoize_method
    def f_contiguous(self):
        return self.array.strides == f_contiguous_strides(
                self.array.dtype.itemsize, self.array.shape)

    @property
    @memoize_method
    def c_contiguous(self):
        return self.array.strides == c_contiguous_strides(
                self.array.dtype.itemsize, self.array.shape)

    @property
    @memoize_method
    def forc(self):
        return self.f_contiguous or self.c_contiguous




def get_common_dtype(obj1, obj2, allow_double):
    # Yes, numpy behaves differently depending on whether
    # we're dealing with arrays or scalars.

    zero1 = np.zeros(1, dtype=obj1.dtype)

    try:
        zero2 = np.zeros(1, dtype=obj2.dtype)
    except AttributeError:
        zero2 = obj2

    result = (zero1 + zero2).dtype

    if not allow_double:
        if result == np.float64:
            result = np.dtype(np.float32)
        elif result == np.complex128:
            result = np.dtype(np.complex64)

    return result



def bound(a):
    high = a.bytes
    low = a.bytes

    for stri, shp in zip(a.strides, a.shape):
        if stri<0:
            low += (stri)*(shp-1)
        else:
            high += (stri)*(shp-1)
    return low, high

def may_share_memory(a, b):
    # When this is called with a an ndarray and b
    # a sparse matrix, numpy.may_share_memory fails.
    if a is b:
        return True
    if a.__class__ is b.__class__:
        a_l, a_h = bound(a)
        b_l, b_h = bound(b)
        if b_l >= a_h or a_l >= b_h:
            return False
        return True
    else:
        return False


# {{{ as_strided implementation

# stolen from numpy to be compatible with older versions of numpy

class _DummyArray(object):
    """ Dummy object that just exists to hang __array_interface__ dictionaries
    and possibly keep alive a reference to a base array.
    """
    def __init__(self, interface, base=None):
        self.__array_interface__ = interface
        self.base = base

def as_strided(x, shape=None, strides=None):
    """ Make an ndarray from the given array with the given shape and strides.
    """
    # work around Numpy bug 1873 (reported by Irwin Zaid)
    # Since this is stolen from numpy, this implementation has the same bug.
    # http://projects.scipy.org/numpy/ticket/1873

    if not x.dtype.isbuiltin:
        if (shape is not None and x.shape != shape) \
                or (strides is not None and x.strides != strides):
            raise NotImplementedError(
                    "as_strided won't work on non-native arrays for now."
                    "See http://projects.scipy.org/numpy/ticket/1873")
        else:
            return x

    interface = dict(x.__array_interface__)
    if shape is not None:
        interface['shape'] = tuple(shape)
    if strides is not None:
        interface['strides'] = tuple(strides)
    return np.asarray(_DummyArray(interface, base=x))

# }}}
