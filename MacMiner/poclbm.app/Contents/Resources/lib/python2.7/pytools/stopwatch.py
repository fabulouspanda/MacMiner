from __future__ import division
import time
import pytools




class StopWatch:
    def __init__(self):
        self.Elapsed = 0.
        self.LastStart = None

    def start(self):
        assert self.LastStart is None
        self.LastStart = time.time()
        return self

    def stop(self):
        assert self.LastStart is not None
        self.Elapsed += time.time() - self.LastStart
        self.LastStart = None
        return self

    def elapsed(self):
        if self.LastStart:
            return time.time() - self.LastStart + self.Elapsed
        else:
            return self.Elapsed


class Job:
    def __init__(self, name):
        self.Name = name
        self.StopWatch = StopWatch().start()
        if self.is_visible():
            print "%s..." % name

    def done(self):
        elapsed = self.StopWatch.elapsed()
        JOB_TIMES[self.Name] += elapsed
        if self.is_visible():
            print " " * (len(self.Name) + 2), elapsed, "seconds"
  
    def is_visible(self):
        if PRINT_JOBS.get():
            return not self.Name in HIDDEN_JOBS
        else:
            return self.Name in VISIBLE_JOBS




class EtaEstimator:
    def __init__(self, total_steps):
        self.stopwatch = StopWatch().start()
        self.total_steps = total_steps
        assert total_steps > 0

    def estimate(self, done):
        fraction_done = done/self.total_steps
        time_spent = self.stopwatch.elapsed()
        if fraction_done > 1e-5:
            return time_spent/fraction_done-time_spent
        else:
            return None




def print_job_summary():
    for key in JOB_TIMES:
        print key, " " * (50-len(key)), JOB_TIMES[key]






HIDDEN_JOBS = []
VISIBLE_JOBS = []
JOB_TIMES = pytools.DictionaryWithDefault(lambda x: 0)
PRINT_JOBS = pytools.Reference(True)
