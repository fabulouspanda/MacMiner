def in_mpi_relaunch():
    import os
    return "PYTOOLS_RUN_WITHIN_MPI" in os.environ

def run_with_mpi_ranks(py_script, ranks, callable, *args, **kwargs):
    if in_mpi_relaunch():
        callable(*args, **kwargs)
    else:
        import sys, os
        newenv = os.environ.copy()
        newenv["PYTOOLS_RUN_WITHIN_MPI"] = "1"

        from subprocess import check_call
        check_call(["mpirun", "-np", str(ranks), 
            sys.executable, py_script], env=newenv)

