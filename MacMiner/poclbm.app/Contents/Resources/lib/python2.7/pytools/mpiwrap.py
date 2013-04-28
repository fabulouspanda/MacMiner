"""See pytools.prefork for this module's reason for being."""

import mpi4py.rc

mpi4py.rc.initialize = False

import pytools.prefork
pytools.prefork.enable_prefork()

from mpi4py.MPI import *

if Is_initialized():
    raise RuntimeError("MPI already initialized before MPI wrapper import")

def InitWithAutoFinalize(*args, **kwargs):
    result = Init(*args, **kwargs)
    import atexit
    atexit.register(Finalize)
    return result

