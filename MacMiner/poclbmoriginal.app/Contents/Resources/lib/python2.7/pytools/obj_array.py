import numpy
from pytools.decorator import decorator




def gen_len(expr):
    from pytools.obj_array import is_obj_array
    if is_obj_array(expr):
        return len(expr)
    else:
        return 1

def gen_slice(expr, slice):
    result = expr[slice]
    if len(result) == 1:
        return result[0]
    else:
        return result




def is_obj_array(val):
    try:
        return isinstance(val, numpy.ndarray) and val.dtype == object
    except AttributeError:
        return False




def to_obj_array(ary):
    ls = log_shape(ary)
    result = numpy.empty(ls, dtype=object)

    from pytools import indices_in_shape
    for i in indices_in_shape(ls):
        result[i] = ary[i]

    return result




def is_field_equal(a, b):
    if is_obj_array(a):
        return is_obj_array(b) and (a.shape == b.shape) and (a == b).all()
    else:
        return not is_obj_array(b) and a == b




def make_obj_array(res_list):
    result = numpy.empty((len(res_list),), dtype=object)
    for i, v in enumerate(res_list):
        result[i] = v

    return result




def setify_field(f):
    from hedge.tools import is_obj_array
    if is_obj_array(f):
        return set(f)
    else:
        return set([f])




def hashable_field(f):
    if is_obj_array(f):
        return tuple(f)
    else:
        return f




def field_equal(a, b):
    a_is_oa = is_obj_array(a)
    assert a_is_oa == is_obj_array(b)

    if a_is_oa:
        return (a == b).all()
    else:
        return a == b




def join_fields(*args):
    res_list = []
    for arg in args:
        if isinstance(arg, list):
            res_list.extend(arg)
        elif isinstance(arg, numpy.ndarray):
            if log_shape(arg) == ():
                res_list.append(arg)
            else:
                res_list.extend(arg)
        else:
            res_list.append(arg)

    return make_obj_array(res_list)




def log_shape(array):
    """Returns the "logical shape" of the array.

    The "logical shape" is the shape that's left when the node-depending
    dimension has been eliminated."""

    try:
        if array.dtype.char == "O":
            return array.shape
        else:
            return array.shape[:-1]
    except AttributeError:
        return ()




def with_object_array_or_scalar(f, field, obj_array_only=False):
    if obj_array_only:
        if is_obj_array(field):
            ls = field.shape
        else:
            ls = ()
    else:
        ls = log_shape(field)
    if ls != ():
        from pytools import indices_in_shape
        result = numpy.zeros(ls, dtype=object)
        for i in indices_in_shape(ls):
            result[i] = f(field[i])
        return result
    else:
        return f(field)



as_oarray_func = decorator(with_object_array_or_scalar)




def with_object_array_or_scalar_n_args(f, *args):
    oarray_arg_indices = []
    for i, arg in enumerate(args):
        if is_obj_array(arg):
            oarray_arg_indices.append(i)

    if not oarray_arg_indices:
        return f(*args)

    leading_oa_index = oarray_arg_indices[0]

    ls = log_shape(args[leading_oa_index])
    if ls != ():
        from pytools import indices_in_shape
        result = numpy.zeros(ls, dtype=object)

        new_args = list(args)
        for i in indices_in_shape(ls):
            for arg_i in oarray_arg_indices:
                new_args[arg_i] = args[arg_i][i]

            result[i] = f(*new_args)
        return result
    else:
        return f(*args)



as_oarray_func_n_args = decorator(with_object_array_or_scalar_n_args)



def cast_field(field, dtype):
    return with_object_array_or_scalar(
            lambda f: f.astype(dtype), field)




def oarray_real(ary):
    return with_object_array_or_scalar(lambda x: x.real, ary)

def oarray_imag(ary):
    return with_object_array_or_scalar(lambda x: x.imag, ary)

def oarray_real_copy(ary):
    return with_object_array_or_scalar(lambda x: x.real.copy(), ary)

def oarray_imag_copy(ary):
    return with_object_array_or_scalar(lambda x: x.imag.copy(), ary)
