try:
    from py.test import mark as mark_test
except ImportError:
    class _Mark:
        def __getattr__(self, name):
            def dec(f):
                return f
            return dec
    mark_test = _Mark()
