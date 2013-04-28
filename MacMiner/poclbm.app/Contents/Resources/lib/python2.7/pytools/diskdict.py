# see end of file for sqlite import




class DiskDict(object):
    """Provides a disk-backed dictionary. Unlike L{shelve}, this class allows
    arbitrary values for keys, at a slight performance penalty.

    Note that this is a dangerous game: The C{hash()} of many objects changes
    between runs. In particular, C{hash(None)} changes between runs.
    C{str}, C{unicode}, C{int}, C{tuple} and C{long} seem to be constant
    for a given Python executable, but they may change for a new version.

    So don't use this class for data that you absolutely *have* to be able
    to retrieve. It's fine for caches and the like, though.
    """
    def __init__(self, dbfilename, version_base=(), dep_modules=[],
            commit_interval=1):
        self.db_conn = sqlite.connect(dbfilename, timeout=30)

        try:
            self.db_conn.execute("select * from data;")
        except sqlite.OperationalError:
            self.db_conn.execute("""
                  create table data (
                    id integer primary key autoincrement,
                    key_hash integer,
                    key_pickle blob,
                    version_hash integer,
                    version_pickle blob,
                    when_inserted timestamp default current_timestamp,
                    result_pickle blob)""")

        def mtime(file):
            if not isinstance(file, basestring):
                # assume file names a module
                file = file.__file__

            import os
            return os.stat(file).st_mtime

        from cPickle import dumps
        self.version = (version_base,) + tuple(
            mtime(dm) for dm in dep_modules)
        self.version_pickle = dumps(self.version)
        self.version_hash = hash(self.version)

        self.cache = {}

        self.commit_interval = commit_interval
        self.commit_countdown = self.commit_interval

    def __contains__(self, key):
        if key in self.cache:
            return True
        else:
            from cPickle import loads
            for key_pickle, version_pickle, result_pickle in self.db_conn.execute(
                    "select key_pickle, version_pickle, result_pickle from data"
                    " where key_hash = ? and version_hash = ?",
                    (hash(key), self.version_hash)):
                if loads(str(key_pickle)) == key and loads(str(version_pickle)) == self.version:
                    result = loads(str(result_pickle))
                    self.cache[key] = result
                    return True

            return False

    def __getitem__(self, key):
        try:
            return self.cache[key]
        except KeyError:
            from cPickle import loads
            for key_pickle, version_pickle, result_pickle in self.db_conn.execute(
                    "select key_pickle, version_pickle, result_pickle from data"
                    " where key_hash = ? and version_hash = ?",
                    (hash(key), self.version_hash)):
                if loads(str(key_pickle)) == key and loads(str(version_pickle)) == self.version:
                    result = loads(str(result_pickle))
                    self.cache[key] = result
                    return result

            raise KeyError(key)

    def __delitem__(self, key):
        if key in self.cache:
            del self.cache[key]

        from cPickle import loads
        for item_id, key_pickle, version_pickle in self.db_conn.execute(
                "select id, key_pickle, version_pickle from data"
                " where key_hash = ? and version_hash = ?",
                (hash(key), self.version_hash)):
            if loads(key_pickle) == key and loads(version_pickle) == self.version:
                self.db_conn.execute("delete from data where id = ?", (item_id,))

        self.commit_countdown -= 1
        if self.commit_countdown <= 0:
            self.commit_countdown = self.commit_interval
            self.db_conn.commit()

    def __setitem__(self, key, value):
        del self[key]

        self.cache[key] = value

        from cPickle import dumps
        self.db_conn.execute("insert into data"
                " (key_hash, key_pickle, version_hash, version_pickle, result_pickle)"
                " values (?,?,?,?,?)",
                (hash(key), sqlite.Binary(dumps(key)),
                    self.version_hash, self.version_pickle,
                    sqlite.Binary(dumps(value))))

        self.commit_countdown -= 1
        if self.commit_countdown <= 0:
            self.commit_countdown = self.commit_interval
            self.db_conn.commit()




try:
    import sqlite3 as sqlite
except ImportError:
    try:
        from pysqlite2 import dbapi2 as sqlite
    except ImportError:
        import warnings
        warnings.warn("DiskDict will be memory-only: "
                "a usable version of sqlite was not found.")
        DiskDict = dict
