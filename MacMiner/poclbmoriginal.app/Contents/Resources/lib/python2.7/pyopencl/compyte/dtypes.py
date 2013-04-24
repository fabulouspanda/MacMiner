"""Type mapping helpers."""

from __future__ import division

__copyright__ = "Copyright (C) 2011 Andreas Kloeckner"

__license__ = """
Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"""

import numpy as np




# {{{ registry

DTYPE_TO_NAME = {}
NAME_TO_DTYPE = {}

def register_dtype(dtype, c_names, alias_ok=False):
    if isinstance(c_names, str):
        c_names = [c_names]

    dtype = np.dtype(dtype)

    # check if pre-existing

    if not alias_ok and dtype in DTYPE_TO_NAME:
        raise RuntimeError("dtype '%s' already registered (as '%s', new names '%s')" 
                % (dtype, DTYPE_TO_NAME[dtype], ", ".join(c_names)))
    for nm in c_names:
        if nm in NAME_TO_DTYPE and NAME_TO_DTYPE[nm] != dtype:
            raise RuntimeError("name '%s' already registered" % nm)

    for nm in c_names:
        NAME_TO_DTYPE[nm] = dtype

    if not dtype in DTYPE_TO_NAME:
        DTYPE_TO_NAME[dtype] = c_names[0]

    if not str(dtype) in DTYPE_TO_NAME:
        DTYPE_TO_NAME[str(dtype)] = c_names[0]

def _fill_dtype_registry(respect_windows):
    from sys import platform

    register_dtype(np.bool, "bool")
    register_dtype(np.int8, "char")
    register_dtype(np.uint8, "unsigned char")
    register_dtype(np.int16, ["short", "signed short", "signed short int", "short signed int"])
    register_dtype(np.uint16, ["unsigned short", "unsigned short int", "short unsigned int"])
    register_dtype(np.int32, ["int", "signed int"])
    register_dtype(np.uint32, ["unsigned", "unsigned int"])

    is_64_bit = tuple.__itemsize__ * 8 == 64
    if is_64_bit:
        if 'win32' in platform and respect_windows:
            i64_name = "long long"
        else:
            i64_name = "long"

        register_dtype(np.int64, [i64_name, "%s int" % i64_name, "signed %s int" % i64_name,
            "%s signed int" % i64_name])
        register_dtype(np.uint64, ["unsigned %s" % i64_name, "unsigned %s int" % i64_name,
            "%s unsigned int" % i64_name])

    # http://projects.scipy.org/numpy/ticket/2017
    if is_64_bit:
        register_dtype(np.uintp, ["unsigned %s" % i64_name], alias_ok=True)
    else:
        register_dtype(np.uintp, ["unsigned"], alias_ok=True)

    register_dtype(np.float32, "float")
    register_dtype(np.float64, "double")

# }}}

# {{{ dtype -> ctype

def dtype_to_ctype(dtype, with_fp_tex_hack=False):
    if dtype is None:
        raise ValueError("dtype may not be None")

    dtype = np.dtype(dtype)
    if with_fp_tex_hack:
        if dtype == np.float32:
            return "fp_tex_float"
        elif dtype == np.float64:
            return "fp_tex_double"

    try:
        return DTYPE_TO_NAME[dtype]
    except KeyError:
        raise ValueError, "unable to map dtype '%s'" % dtype

# }}}

# {{{ c declarator parsing

def parse_c_arg_backend(c_arg, scalar_arg_class, vec_arg_class):
    c_arg = c_arg.replace("const", "").replace("volatile", "")

    # process and remove declarator
    import re
    decl_re = re.compile(r"(\**)\s*([_a-zA-Z0-9]+)(\s*\[[ 0-9]*\])*\s*$")
    decl_match = decl_re.search(c_arg)

    if decl_match is None:
        raise ValueError("couldn't parse C declarator '%s'" % c_arg)

    name = decl_match.group(2)

    if decl_match.group(1) or decl_match.group(3) is not None:
        arg_class = vec_arg_class
    else:
        arg_class = scalar_arg_class

    tp = c_arg[:decl_match.start()]
    tp = " ".join(tp.split())

    try:
        dtype = NAME_TO_DTYPE[tp]
    except KeyError:
        raise ValueError("unknown type '%s'" % tp)

    return arg_class(dtype, name)

# }}}




# vim: foldmethod=marker
