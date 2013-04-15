from __future__ import division




# timing function -------------------------------------------------------------
def time():
    """Return elapsed CPU time, as a float, in seconds."""
    import os
    time_opt = os.environ.get("PYTOOLS_LOG_TIME") or "wall"
    if time_opt == "wall":
        from time import time
        return time()
    elif time_opt == "rusage":
        from resource import getrusage, RUSAGE_SELF
        return getrusage(RUSAGE_SELF).ru_utime
    else:
        raise RuntimeError, "invalid timing method '%s'" % time_opt




# abstract logging interface --------------------------------------------------
class LogQuantity(object):
    """A source of loggable scalars."""

    sort_weight = 0

    def __init__(self, name, unit=None, description=None):
        self.name = name
        self.unit = unit
        self.description = description

    @property
    def default_aggregator(self): return None

    def tick(self):
        """Perform updates required at every :class:`LogManager` tick."""
        pass

    def __call__(self):
        """Return the current value of the diagnostic represented by this
        L{LogQuantity} or None if no value is available.

        This is only called if the invocation interval calls for it.
        """
        raise NotImplementedError




class PostLogQuantity(LogQuantity):
    """A source of loggable scalars."""

    sort_weight = 0

    def prepare_for_tick(self):
        pass



class MultiLogQuantity(object):
    """A source of multiple loggable scalars."""

    sort_weight = 0

    def __init__(self, names, units=None, descriptions=None):
        self.names = names

        if units is None:
            units = len(names) * [None]
        self.units = units

        if descriptions is None:
            descriptions = len(names) * [None]
        self.descriptions = descriptions

    @property
    def default_aggregators(self):
        return [None] * len(self.names)

    def tick(self):
        """Perform updates required at every :class:`LogManager` tick."""
        pass

    def __call__(self):
        """Return an iterable of the current values of the diagnostic represented
        by this L{MultiLogQuantity}.

        This is only called if the invocation interval calls for it.
        """
        raise NotImplementedError




class MultiPostLogQuantity(MultiLogQuantity, PostLogQuantity):
    pass




class DtConsumer(object):
    def __init__(self, dt):
        self.dt = dt

    def set_dt(self, dt):
        self.dt = dt




class TimeTracker(DtConsumer):
    def __init__(self, dt):
        DtConsumer.__init__(self, dt)
        self.t = 0

    def tick(self):
        self.t += self.dt




class SimulationLogQuantity(PostLogQuantity, DtConsumer):
    """A source of loggable scalars that needs to know the simulation timestep."""

    def __init__(self, dt, name, unit=None, description=None):
        PostLogQuantity.__init__(self, name, unit, description)
        DtConsumer.__init__(self, dt)





class PushLogQuantity(LogQuantity):
    def __init__(self, name, unit=None, description=None):
        LogQuantity.__init__(self, name, unit, description)
        self.value = None

    def push_value(self, value):
        if self.value is not None:
            raise RuntimeError, "can't push two values per cycle"
        self.value = value

    def __call__(self):
        v = self.value
        self.value = None
        return v




class CallableLogQuantityAdapter(LogQuantity):
    """Adapt a 0-ary callable as a L{LogQuantity}."""
    def __init__(self, callable, name, unit=None, description=None):
        self.callable = callable
        LogQuantity.__init__(self, name, unit, description)

    def __call__(self):
        return self.callable()




# manager functionality -------------------------------------------------------
class _GatherDescriptor(object):
    def __init__(self, quantity, interval):
        self.quantity = quantity
        self.interval = interval




class _QuantityData(object):
    def __init__(self, unit, description, default_aggregator):
        self.unit = unit
        self.description = description
        self.default_aggregator = default_aggregator




def _join_by_first_of_tuple(list_of_iterables):
    loi = [i.__iter__() for i in list_of_iterables]
    if not loi:
        return
    key_vals = [iter.next() for iter in loi]
    keys = [kv[0] for kv in key_vals]
    values = [kv[1] for kv in key_vals]
    target_key = max(keys)

    force_advance = False

    i = 0
    while True:
        while keys[i] < target_key or force_advance:
            try:
                new_key, new_value = loi[i].next()
            except StopIteration:
                return
            assert keys[i] < new_key
            keys[i] = new_key
            values[i] = new_value
            if new_key > target_key:
                target_key = new_key

            force_advance = False

        i += 1
        if i >= len(loi):
            i = 0

        if min(keys) == target_key:
            yield target_key, values[:]
            force_advance = True




def _get_unique_id():
    try:
        from uiid import uuid1
    except ImportError:
        try:
            import hashlib
            checksum = hashlib.md5()
        except ImportError:
            # for Python << 2.5
            import md5
            checksum = md5.new()

        from random import Random
        rng = Random()
        rng.seed()
        for i in range(20):
            checksum.update(str(rng.randrange(1<<30)))
        return checksum.hexdigest()
    else:
        return uuid1().hex




def _get_random_suffix(n):
    characters = (
            [chr(65+i) for i in range(26)]
            + [chr(97+i) for i in range(26)]
            + [chr(48+i) for i in range(10)])

    from random import choice
    return "".join(choice(characters) for i in xrange(n))






def _set_up_schema(db_conn):
    # initialize new database
    db_conn.execute("""
      create table quantities (
        name text,
        unit text,
        description text,
        default_aggregator blob)""")
    db_conn.execute("""
      create table constants (
        name text,
        value blob)""")
    db_conn.execute("""
      create table warnings (
        rank integer,
        step integer,
        message text,
        category text,
        filename text,
        lineno integer
        )""")

    schema_version = 2
    return schema_version




class LogManager(object):
    """A parallel-capable diagnostic time-series logging facility.
    It is meant to log data from a computation, with certain log
    quantities available before a cycle, and certain other ones
    afterwards. A timeline of invocations looks as follows::

        tick_before()
        compute...
        tick()
        tick_after()

        tick_before()
        compute...
        tick_after()

        ...

    In a time-dependent simulation, each group of :meth:`tick_before`
    :meth:`tick_after` calls captures data for a single time state,
    namely that in which the data may have been *before* the "compute"
    step. However, some data (such as the length of the timestep taken
    in a time-adpative method) may only be available *after* the completion
    of the "compute..." stage, which is why :meth:`tick_after` exists.

    A :class:`LogManager` logs any number of named time series of floats to
    a file. Non-time-series data, in the form of constants, is also
    supported and saved.

    If MPI parallelism is used, the "head rank" below always refers to
    rank 0.

    Command line tools called :command:`runalyzer` and :command:`logtool`
    (deprecated) are available for looking at the data in a saved log.
    """

    def __init__(self, filename=None, mode="r", mpi_comm=None, capture_warnings=True,
            commit_interval=90):
        """Initialize this log manager instance.

        :param filename: If given, the filename to which this log is bound.
          If this database exists, the current state is loaded from it.
        :param mode: One of "w", "r" for write, read. "w" assumes that the
          database is initially empty. May also be "wu" to indicate that
          a unique filename should be chosen automatically.
        :arg mpi_comm: An C{mpi4py} communicator. If given, logs are periodically
          synchronized to the head node, which then writes them out to disk.
        :param capture_warnings: Tap the Python warnings facility and save warnings
          to the log file.
        :param commit_interval: actually perform a commit only every N times a commit
          is requested.
        """

        assert isinstance(mode, basestring), "mode must be a string"
        assert mode in ["w", "r", "wu"], "invalid mode"

        self.quantity_data = {}
        self.last_values = {}
        self.before_gather_descriptors = []
        self.after_gather_descriptors = []
        self.tick_count = 0

        self.commit_interval = commit_interval
        self.commit_countdown = commit_interval

        self.constants = {}

        self.last_save_time = time()

        # self-timing
        self.start_time = time()
        self.t_log = 0

        # parallel support
        self.head_rank = 0
        self.mpi_comm = mpi_comm
        self.is_parallel = mpi_comm is not None

        if mpi_comm is None:
            self.rank = 0
        else:
            self.rank = mpi_comm.rank
            self.head_rank = 0

        # watch stuff
        self.watches = []
        self.next_watch_tick = 1
        self.have_nonlocal_watches = False

        # database binding
        try:
            import sqlite3 as sqlite
        except ImportError:
            try:
                from pysqlite2 import dbapi2 as sqlite
            except ImportError:
                raise ImportError, "could not find a usable version of sqlite."

        if filename is None:
            filename = ":memory:"
        else:
            if self.is_parallel:
                filename += "-rank%d" % self.rank

        while True:
            suffix = ""

            if mode == "wu":
                suffix = "-"+_get_random_suffix(6)

            self.db_conn = sqlite.connect(filename+suffix, timeout=30)
            self.mode = mode
            try:
                self.db_conn.execute("select * from quantities;")
            except sqlite.OperationalError:
                # we're building a new database
                if mode == "r":
                    raise RuntimeError, "Log database '%s' not found" % filename

                self.schema_version = _set_up_schema(self.db_conn)
                self.set_constant("schema_version", self.schema_version)

                self.set_constant("is_parallel", self.is_parallel)

                # set globally unique run_id
                if self.is_parallel:
                    self.set_constant("unique_run_id",
                            self.mpi_comm.bcast(_get_unique_id(), root=self.head_rank))
                else:
                    self.set_constant("unique_run_id", _get_unique_id())

                if self.is_parallel:
                    self.set_constant("rank_count", self.mpi_comm.Get_size())
                else:
                    self.set_constant("rank_count", 1)

            else:
                # we've opened an existing database
                if mode == "w":
                    raise RuntimeError, "Log database '%s' already exists" % filename
                elif mode == "wu":
                    # try again with a new suffix
                    continue

                self._load()

            break

        self.old_showwarning = None
        if capture_warnings:
            self.capture_warnings(True)

    def capture_warnings(self, enable=True):
        def _showwarning(message, category, filename, lineno, file=None, line=None):
            try:
                self.old_showwarning(message, category, filename, lineno, file, line)
            except TypeError:
                # cater to Python 2.5 and earlier
                self.old_showwarning(message, category, filename, lineno)

            if self.schema_version >= 1 and self.mode == "w":
                if self.schema_version >= 2:
                    self.db_conn.execute("insert into warnings values (?,?,?,?,?,?)",
                            (self.rank, self.tick_count, str(message), str(category),
                                filename, lineno))
                else:
                    self.db_conn.execute("insert into warnings values (?,?,?,?,?)",
                            (self.tick_count, str(message), str(category),
                                filename, lineno))

        import warnings
        if enable:
            if self.old_showwarning is None:
                pass
                self.old_showwarning = warnings.showwarning
                warnings.showwarning = _showwarning
            else:
                raise RuntimeError, "Warnings capture was enabled twice"
        else:
            if self.old_showwarning is None:
                raise RuntimeError, "Warnings capture was disabled, but never enabled"
            else:
                warnings.showwarning = self.old_showwarning
                self.old_showwarning = None

    def _load(self):
        if self.mpi_comm and self.mpi_comm.rank != self.head_rank:
            return

        from pickle import loads
        for name, value in self.db_conn.execute("select name, value from constants"):
            self.constants[name] = loads(value)

        self.schema_version = self.constants.get("schema_version", 0)

        self.is_parallel = self.constants["is_parallel"]

        for name, unit, description, def_agg in self.db_conn.execute(
                "select name, unit, description, default_aggregator from quantities"):
            qdat = self.quantity_data[name] = _QuantityData(
                    unit, description, loads(def_agg))

    def close(self):
        if self.old_showwarning is not None:
            self.capture_warnings(False)

        self.save()
        self.db_conn.close()


    def get_table(self, q_name):
        if q_name not in self.quantity_data:
            raise KeyError, "invalid quantity name '%s'" % q_name

        from pytools.datatable import DataTable
        result = DataTable(["step", "rank", "value"])

        for row in self.db_conn.execute(
                "select step, rank, value from %s" % q_name):
            result.insert_row(row)

        return result

    def get_warnings(self):
        columns = ["step", "message", "category", "filename", "lineno"]
        if self.schema_version >= 2:
            columns.insert(0, "rank")

        from pytools.datatable import DataTable
        result = DataTable(columns)

        for row in self.db_conn.execute(
                "select %s from warnings" % (", ".join(columns))):
            result.insert_row(row)

        return result

    def add_watches(self, watches):
        """Add quantities that are printed after every time step."""

        from pytools import Record
        class WatchInfo(Record): pass

        for watch in watches:
            if isinstance(watch, tuple):
                display, expr = watch
            else:
                display = watch
                expr = watch

            parsed = self._parse_expr(expr)
            parsed, dep_data = self._get_expr_dep_data(parsed)

            from pytools import any
            self.have_nonlocal_watches = self.have_nonlocal_watches or \
                    any(dd.nonlocal_agg for dd in dep_data)

            from pymbolic import compile
            compiled = compile(parsed, [dd.varname for dd in dep_data])

            watch_info = WatchInfo(display=display, parsed=parsed, dep_data=dep_data,
                    compiled=compiled)

            self.watches.append(watch_info)

    def set_constant(self, name, value):
        """Make a named, constant value available in the log."""
        existed = name in self.constants
        self.constants[name] = value

        from pickle import dumps
        value = buffer(dumps(value))

        if existed:
            self.db_conn.execute("update constants set value = ? where name = ?",
                    (value, name))
        else:
            self.db_conn.execute("insert into constants values (?,?)",
                    (name, value))

        self._commit()

    def _insert_datapoint(self, name, value):
        if value is None:
            return

        self.last_values[name] = value

        try:
            self.db_conn.execute("insert into %s values (?,?,?)" % name,
                    (self.tick_count, self.rank, float(value)))
        except:
            print "while adding datapoint for '%s':" % name
            raise

    def _gather_for_descriptor(self, gd):
        if self.tick_count % gd.interval == 0:
            q_value = gd.quantity()
            if isinstance(gd.quantity, MultiLogQuantity):
                for name, value in zip(gd.quantity.names, q_value):
                    self._insert_datapoint(name, value)
            else:
                self._insert_datapoint(gd.quantity.name, q_value)

    def tick(self):
        """Record data points from each added L{LogQuantity}.

        May also checkpoint data to disk, and/or synchronize data points
        to the head rank.
        """
        from warnings import warn
        warn("LogManager.tick() is deprecated. Use LogManager.tick_{before,after}().",
                DeprecationWarning)

        self.tick_before()
        self.tick_after()

    def tick_before(self):
        """Record data points from each added :class:`LogQuantity` that
        is not an instance of :class:`PostLogQuantity`. Also, invoke
        :meth:`PostLogQuantity.prepare_for_tick` on :class:`PostLogQuantity`
        instances.
        """
        tick_start_time = time()

        for gd in self.before_gather_descriptors:
            self._gather_for_descriptor(gd)

        for gd in self.after_gather_descriptors:
            gd.quantity.prepare_for_tick()

        self.t_log = time() - tick_start_time

    def tick_after(self):
        """Record data points from each added :class:`LogQuantity` that
        is an instance of :class:`PostLogQuantity`.

        May also checkpoint data to disk.
        """
        tick_start_time = time()

        for gd_lst in [self.before_gather_descriptors,
                self.after_gather_descriptors]:
            for gd in gd_lst:
                gd.quantity.tick()

        for gd in self.after_gather_descriptors:
            self._gather_for_descriptor(gd)

        self.tick_count += 1

        if tick_start_time - self.start_time > 15*60:
            save_interval = 5*60
        else:
            save_interval = 15

        if tick_start_time > self.last_save_time + save_interval:
            self.save()

        end_time = time()

        # print watches
        if self.tick_count == self.next_watch_tick:
            self._watch_tick()

        self.t_log += time() - tick_start_time

    def _commit(self):
        self.commit_countdown -= 1
        if self.commit_countdown <= 0:
            self.commit_countdown = self.commit_interval
            self.db_conn.commit()

    def save(self):
        from sqlite3 import OperationalError
        try:
            self.db_conn.commit()
        except OperationalError, e:
            from warnings import warn
            warn("encountered sqlite error during commit: %s" % e)

        self.last_save_time = time()

    def add_quantity(self, quantity, interval=1):
        """Add an object derived from L{LogQuantity} to this manager."""
        def add_internal(name, unit, description, def_agg):
            if name in self.quantity_data:
                raise RuntimeError("cannot add the same quantity '%s' twice" % name)
            self.quantity_data[name] = _QuantityData(unit, description, def_agg)

            from pickle import dumps
            self.db_conn.execute("""insert into quantities values (?,?,?,?)""", (
                  name, unit, description,
                  buffer(dumps(def_agg))))
            self.db_conn.execute("""create table %s
              (step integer, rank integer, value real)""" % name)

            self._commit()

        gd = _GatherDescriptor(quantity, interval)
        if isinstance(quantity, PostLogQuantity):
            gd_list = self.after_gather_descriptors
        else:
            gd_list = self.before_gather_descriptors

        gd_list.append(gd)
        gd_list.sort(key=lambda gd: gd.quantity.sort_weight)

        if isinstance(quantity, MultiLogQuantity):
            for name, unit, description, def_agg in zip(
                    quantity.names,
                    quantity.units,
                    quantity.descriptions,
                    quantity.default_aggregators):
                add_internal(name, unit, description, def_agg)
        else:
            add_internal(quantity.name,
                    quantity.unit, quantity.description,
                    quantity.default_aggregator)

    def get_expr_dataset(self, expression, description=None, unit=None):
        """Prepare a time-series dataset for a given expression.

        @arg expression: A C{pymbolic} expression that may involve
          the time-series variables and the constants in this L{LogManager}.
          If there is data from multiple ranks for a quantity occuring in
          this expression, an aggregator may have to be specified.
        @return: C{(description, unit, table)}, where C{table}
          is a list of tuples C{(tick_nbr, value)}.

        Aggregators are specified as follows:
        - C{qty.min}, C{qty.max}, C{qty.avg}, C{qty.sum}, C{qty.norm2}
        - C{qty[rank_nbr]}
        - C{qty.loc}
        """

        parsed = self._parse_expr(expression)
        parsed, dep_data = self._get_expr_dep_data(parsed)

        # aggregate table data
        for dd in dep_data:
            table = self.get_table(dd.name)
            table.sort(["step"])
            dd.table = table.aggregated(["step"], "value", dd.agg_func).data

        # evaluate unit and description, if necessary
        if unit is None:
            from pymbolic import substitute, parse

            unit_dict = dict((dd.varname, dd.qdat.unit) for dd in dep_data)
            from pytools import all
            if all(v is not None for v in unit_dict.itervalues()):
                unit_dict = dict((k, parse(v)) for k, v in unit_dict.iteritems())
                unit = substitute(parsed, unit_dict)
            else:
                unit = None

        if description is None:
            description = expression

        # compile and evaluate
        from pymbolic import compile
        compiled = compile(parsed, [dd.varname for dd in dep_data])

        data = []

        for key, values in _join_by_first_of_tuple(dd.table for dd in dep_data):
            try:
                data.append((key, compiled(*values)))
            except ZeroDivisionError:
                pass

        return (description, unit, data)

    def get_joint_dataset(self, expressions):
        """Return a joint data set for a list of expressions.

        @arg expressions: a list of either strings representing
          expressions directly, or triples (descr, unit, expr).
          In the former case, the description and the unit are
          found automatically, if possible. In the latter case,
          they are used as specified.
        @return: A triple C{(descriptions, units, table)}, where
        C{table} is a a list of C{[(tstep, (val_expr1, val_expr2,...)...]}.
        """

        # dubs is a list of (desc, unit, table) triples as
        # returned by get_expr_dataset
        dubs = []
        for expr in expressions:
            if isinstance(expr, str):
                dub = self.get_expr_dataset(expr)
            else:
                expr_descr, expr_unit, expr_str = expr
                dub = self.get_expr_dataset(
                        expr_str,
                        description=expr_descr,
                        unit=expr_unit)

            dubs.append(dub)

        zipped_dubs = list(zip(*dubs))
        zipped_dubs[2] = list(
                _join_by_first_of_tuple(zipped_dubs[2]))

        return zipped_dubs

    def get_plot_data(self, expr_x, expr_y, min_step=None, max_step=None):
        """Generate plot-ready data.

        @return: C{(data_x, descr_x, unit_x), (data_y, descr_y, unit_y)}
        """
        (descr_x, descr_y), (unit_x, unit_y), data = \
                self.get_joint_dataset([expr_x, expr_y])
        if min_step is not None:
            data = [(step, tup) for step, tup in data if min_step <= step]
        if max_step is not None:
            data = [(step, tup) for step, tup in data if step <= max_step]

        stepless_data = [tup for step, tup in data]

        if stepless_data:
            data_x, data_y = zip(*stepless_data)
        else:
            data_x = []
            data_y = []

        return (data_x, descr_x, unit_x), \
               (data_y, descr_y, unit_y)

    def plot_gnuplot(self, gp, expr_x, expr_y, **kwargs):
        """Plot data to Gnuplot.py.

        @arg gp: a Gnuplot.Gnuplot instance to which the plot is sent.
        @arg expr_x: an allowed argument to L{get_joint_dataset}.
        @arg expr_y: an allowed argument to L{get_joint_dataset}.
        @arg kwargs: keyword arguments that are directly passed on to
          C{Gnuplot.Data}.
        """
        (data_x, descr_x, unit_x), (data_y, descr_y, unit_y) = \
                self.get_plot_data(expr_x, expr_y)

        gp.xlabel("%s [%s]" % (descr_x, unit_x))
        gp.ylabel("%s [%s]" % (descr_y, unit_y))
        from gnuplot_py import Data
        gp.plot(Data(data_x, data_y, **kwargs))

    def write_datafile(self, filename, expr_x, expr_y):
        (data_x, label_x), (data_y, label_y) = self.get_plot_data(
                expr_x, expr_y)

        outf = open(filename, "w")
        outf.write("# %s vs. %s" % (label_x, label_y))
        for dx, dy in zip(data_x, data_y):
            outf.write("%s\t%s\n" % (repr(dx), repr(dy)))
        outf.close()

    def plot_matplotlib(self, expr_x, expr_y):
        from pylab import xlabel, ylabel, plot

        (data_x, descr_x, unit_x), (data_y, descr_y, unit_y) = \
                self.get_plot_data(expr_x, expr_y)

        xlabel("%s [%s]" % (descr_x, unit_x))
        ylabel("%s [%s]" % (descr_y, unit_y))
        plot(data_x, data_y)

    # private functionality ---------------------------------------------------
    def _parse_expr(self, expr):
        from pymbolic import parse, substitute
        parsed = parse(expr)

        # substitute in global constants
        parsed = substitute(parsed, self.constants)

        return parsed

    def _get_expr_dep_data(self, parsed):
        class Nth:
            def __init__(self, n):
                self.n = n

            def __call__(self, lst):
                return lst[self.n]

        from pymbolic.mapper.dependency import DependencyMapper

        deps = DependencyMapper(include_calls=False)(parsed)

        # gather information on aggregation expressions
        dep_data = []
        from pymbolic.primitives import Variable, Lookup, Subscript
        for dep_idx, dep in enumerate(deps):
            nonlocal_agg = True

            if isinstance(dep, Variable):
                name = dep.name

                if name == "math":
                    continue

                agg_func = self.quantity_data[name].default_aggregator
                if agg_func is None:
                    if self.is_parallel:
                        raise ValueError, "must specify explicit aggregator for '%s'" % name
                    else:
                        agg_func = lambda lst: lst[0]
            elif isinstance(dep, Lookup):
                assert isinstance(dep.aggregate, Variable)
                name = dep.aggregate.name
                agg_name = dep.name

                if agg_name == "loc":
                    agg_func = Nth(self.rank)
                    nonlocal_agg = False
                elif agg_name == "min":
                    agg_func = min
                elif agg_name == "max":
                    agg_func = max
                elif agg_name == "avg":
                    from pytools import average
                    agg_func = average
                elif agg_name == "sum":
                    agg_func = sum
                elif agg_name == "norm2":
                    from math import sqrt
                    agg_func = lambda iterable: sqrt(
                            sum(entry**2 for entry in iterable))
                else:
                    raise ValueError, "invalid rank aggregator '%s'" % agg_name
            elif isinstance(dep, Subscript):
                assert isinstance(dep.aggregate, Variable)
                name = dep.aggregate.name

                from pymbolic import evaluate
                agg_func = Nth(evaluate(dep.index))

            qdat = self.quantity_data[name]

            from pytools import Record
            class DependencyData(Record): pass

            this_dep_data = DependencyData(name=name, qdat=qdat, agg_func=agg_func,
                    varname="logvar%d" % dep_idx, expr=dep,
                    nonlocal_agg=nonlocal_agg)
            dep_data.append(this_dep_data)

        # substitute in the "logvar" variable names
        from pymbolic import var, substitute
        parsed = substitute(parsed,
                dict((dd.expr, var(dd.varname)) for dd in dep_data))

        return parsed, dep_data

    def _watch_tick(self):
        if not self.have_nonlocal_watches and self.rank != self.head_rank:
            return

        data_block = dict((qname, self.last_values.get(qname, 0))
                for qname in self.quantity_data.iterkeys())

        if self.mpi_comm is not None and self.have_nonlocal_watches:
            gathered_data = self.mpi_comm.gather(data_block, self.head_rank)
        else:
            gathered_data = [data_block]

        if self.rank == self.head_rank:
            values = {}
            for data_block in gathered_data:
                for name, value in data_block.iteritems():
                    values.setdefault(name, []).append(value)

            def compute_watch_str(watch):
                try:
                    return "%s=%g" % (watch.display, watch.compiled(
                        *[dd.agg_func(values[dd.name])
                            for dd in watch.dep_data]))
                except ZeroDivisionError:
                    return "%s:div0" % watch.display

            if self.watches:
                print " | ".join(
                        compute_watch_str(watch) for watch in self.watches)

        ticks_per_sec = self.tick_count/max(1, time()-self.start_time)
        self.next_watch_tick = self.tick_count + int(max(1, ticks_per_sec))

        if self.mpi_comm is not None and self.have_nonlocal_watches:
            self.next_watch_tick = self.mpi_comm.bcast(
                    self.next_watch_tick, self.head_rank)





# actual data loggers ---------------------------------------------------------
class _SubTimer:
    def __init__(self, itimer):
        self.itimer = itimer
        self.start_time = time()
        self.elapsed = 0

    def stop(self):
        self.elapsed += time() - self.start_time
        del self.start_time
        return self

    def submit(self):
        self.itimer.add_time(self.elapsed)
        del self.elapsed

class IntervalTimer(PostLogQuantity):
    """Records elapsed times."""

    def __init__(self, name, description=None):
        LogQuantity.__init__(self, name, "s", description)
        self.elapsed = 0

    def start_sub_timer(self):
        return _SubTimer(self)

    def add_time(self, t):
        self.start_time = time()
        self.elapsed += t

    def __call__(self):
        result = self.elapsed
        self.elapsed = 0
        return result




class LogUpdateDuration(LogQuantity):
    """Records how long the last :meth:`LogManager.tick` invocation took."""

    # FIXME this is off by one tick

    def __init__(self, mgr, name="t_log"):
        LogQuantity.__init__(self, name, "s", "Time spent updating the log")
        self.log_manager = mgr

    def __call__(self):
        return self.log_manager.t_log



class EventCounter(PostLogQuantity):
    """Counts events signaled by L{add}."""

    def __init__(self, name="interval", description=None):
        PostLogQuantity.__init__(self, name, "1", description)
        self.events = 0

    def add(self, n=1):
        self.events += n

    def transfer(self, counter):
        self.events += counter.pop()

    def prepare_for_tick(self):
        self.events = 0

    def __call__(self):
        result = self.events
        return result





def time_and_count_function(f, timer, counter=None, increment=1):
    def inner_f(*args, **kwargs):
        if counter is not None:
            counter.add(increment)
        sub_timer = timer.start_sub_timer()
        try:
            return f(*args, **kwargs)
        finally:
            sub_timer.stop().submit()

    return inner_f






class TimestepCounter(LogQuantity):
    """Counts the number of times L{LogManager.tick} is called."""

    def __init__(self, name="step"):
        LogQuantity.__init__(self, name, "1", "Timesteps")
        self.steps = 0

    def __call__(self):
        result = self.steps
        self.steps += 1
        return result




class StepToStepDuration(PostLogQuantity):
    """Records the CPU time between invocations of
    :meth:`LogManager.tick_before` and
    :meth:`LogManager.tick_after`.
    """

    def __init__(self, name="t_2step"):
        PostLogQuantity.__init__(self, name, "s", "Step-to-step duration")
        self.last_start_time = None
        self.last2_start_time = None

    def prepare_for_tick(self):
        self.last2_start_time = self.last_start_time
        self.last_start_time = time()

    def __call__(self):
        if self.last2_start_time is None:
            return None
        else:
            return self.last_start_time - self.last2_start_time





class TimestepDuration(PostLogQuantity):
    """Records the CPU time between the starts of time steps.
    :meth:`LogManager.tick_before` and
    :meth:`LogManager.tick_after`.
    """

    # We would like to run last, so that if log gathering takes any
    # significant time, we catch that, too. (CUDA sync-on-time-taking,
    # I'm looking at you.)
    sort_weight = 1000

    def __init__(self, name="t_step"):
        PostLogQuantity.__init__(self, name, "s", "Time step duration")

    def prepare_for_tick(self):
        self.last_start = time()

    def __call__(self):
        now = time()
        result = now - self.last_start
        del self.last_start
        return result





class CPUTime(LogQuantity):
    """Records (monotonically increasing) CPU time."""
    def __init__(self, name="t_cpu"):
        LogQuantity.__init__(self, name, "s", "Wall time")

        self.start = time()

    def __call__(self):
        return time()-self.start




class ETA(LogQuantity):
    """Records an estimate of how long the computation will still take."""
    def __init__(self, total_steps, name="t_eta"):
        LogQuantity.__init__(self, name, "s", "Estimated remaining duration")

        self.steps = 0
        self.total_steps = total_steps
        self.start = time()

    def __call__(self):
        fraction_done = self.steps/self.total_steps
        self.steps += 1
        time_spent = time()-self.start
        if fraction_done > 1e-9:
            return time_spent/fraction_done-time_spent
        else:
            return 0




def add_general_quantities(mgr):
    """Add generally applicable L{LogQuantity} objects to C{mgr}."""

    mgr.add_quantity(TimestepDuration())
    mgr.add_quantity(StepToStepDuration())
    mgr.add_quantity(CPUTime())
    mgr.add_quantity(LogUpdateDuration(mgr))
    mgr.add_quantity(TimestepCounter())




class SimulationTime(TimeTracker, LogQuantity):
    """Record (monotonically increasing) simulation time."""

    def __init__(self, dt, name="t_sim", start=0):
        LogQuantity.__init__(self, name, "s", "Simulation Time")
        TimeTracker.__init__(self, dt)

    def __call__(self):
        return self.t




class Timestep(SimulationLogQuantity):
    """Record the magnitude of the simulated time step."""

    def __init__(self, dt, name="dt", unit="s"):
        SimulationLogQuantity.__init__(self, dt, name, unit, "Simulation Timestep")

    def __call__(self):
        return self.dt



def set_dt(mgr, dt):
    """Set the simulation timestep on L{LogManager} C{mgr} to C{dt}."""

    for gd_lst in [mgr.before_gather_descriptors,
            mgr.after_gather_descriptors]:
        for gd in gd_lst:
            if isinstance(gd.quantity, DtConsumer):
                gd.quantity.set_dt(dt)




def add_simulation_quantities(mgr, dt=None):
    """Add L{LogQuantity} objects relating to simulation time."""
    if dt is not None:
        from warnings import warn
        warn("Specifying dt ahead of time is a deprecated practice. "
                "Use pytools.log.set_dt() instead.")

    mgr.add_quantity(SimulationTime(dt))
    mgr.add_quantity(Timestep(dt))




def add_run_info(mgr):
    """Add generic run metadata, such as command line, host, and time."""

    import sys
    mgr.set_constant("cmdline", " ".join(sys.argv))
    from socket import gethostname
    mgr.set_constant("machine", gethostname())
    from time import localtime, strftime, time
    mgr.set_constant("date", strftime("%a, %d %b %Y %H:%M:%S %Z", localtime()))
    mgr.set_constant("unixtime", time())
