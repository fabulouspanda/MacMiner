from __future__ import division


def do_boxes_intersect((bl1,tr1), (bl2,tr2)):
    (dimension,) = bl1.shape
    for i in range(0, dimension):
        if max(bl1[i], bl2[i]) > min(tr1[i], tr2[i]):
            return False
    return True




def _get_elements_bounding_box(elements):
    import numpy

    if len(elements) == 0:
        raise RuntimeError, "Cannot get the bounding box of no elements."

    bboxes = [box for el,box in elements]
    bottom_lefts = [bl for bl,tr in bboxes]
    top_rights = [tr for bl,tr in bboxes]
    return numpy.minimum.reduce(bottom_lefts), numpy.minimum.reduce(top_rights)



def make_buckets(bottom_left, top_right, allbuckets):
    import numpy

    (dimensions,) = bottom_left.shape

    half = (top_right - bottom_left) / 2.
    def do(dimension, pos):
        if dimension == dimensions:
            origin = bottom_left + pos*half
            bucket = SpatialBinaryTreeBucket(origin, origin + half)
            allbuckets.append(bucket)
            return bucket
        else:
            pos[dimension] = 0
            first = do(dimension + 1, pos)
            pos[dimension] = 1
            second = do(dimension + 1, pos)
            return [first, second]

    return do(0, numpy.zeros((dimensions,), numpy.float64))




class SpatialBinaryTreeBucket:
    """This class represents one bucket in a spatial binary tree.
    It automatically decides whether it needs to create more subdivisions
    beneath itself or not.

    :ivar elements: a list of tuples *(element, bbox)* where bbox is again
      a tuple *(lower_left, upper_right)* of :class:`numpy.ndarray` instances
      satisfying *(lower_right <= upper_right).all()*.
    """

    def __init__(self, bottom_left, top_right):
        """:param bottom_left: A :mod: 'numpy' array of the minimal coordinates
        of the box being partitioned.
        :param top_right: A :mod: 'numpy' array of the maximal coordinates of
        the box being partitioned."""

        self.elements = []

        self.bottom_left = bottom_left
        self.top_right = top_right
        self.center = (bottom_left + top_right) / 2

        # As long as buckets is None, there are no subdivisions
        self.buckets = None
        self.elements = []

    def insert(self, element, bbox):
        """Insert an element into the spatial tree.

        :param element: the element to be stored in the retrieval data
        structure.  It is treated as opaque and no assumptions are made on it.

        :param bbox: A bounding box supplied as a tuple *lower_left,
        upper_right* of :mod:`numpy` vectors, such that *(lower_right <=
        upper_right).all()*.

        Despite these names, the bounding box (and this entire data structure)
        may be of any dimension.
        """

        def insert_into_subdivision(element, bbox):
            for bucket in self.all_buckets:
                if do_boxes_intersect((bucket.bottom_left, bucket.top_right), bbox):
                    bucket.insert(element, bbox)

        (dimensions,) = self.bottom_left.shape
        if self.buckets is None:
            # No subdivisions yet.
            if len(self.elements) > 4 * 2**dimensions:
                # Too many elements. Need to subdivide.
                self.all_buckets = []
                self.buckets = make_buckets(self.bottom_left, self.top_right,
                                            self.all_buckets)

                # Move all elements from the full bucket into the new finer ones
                for el, el_bbox in self.elements:
                    insert_into_subdivision(el, el_bbox)

                # Free up some memory. Elements are now stored in the
                # subdivision, so we don't need them here any more.
                del self.elements

                insert_into_subdivision(element, bbox)
            else:
                # Simple:
                self.elements.append((element, bbox))
        else:
            # Go find which sudivision to place element
            insert_into_subdivision(element, bbox)


    def generate_matches(self, point):
        if self.buckets:
            # We have subdivisions. Use them.
            (dimensions,) = point.shape
            bucket = self.buckets
            for dim in range(dimensions):
                if point[dim] < self.center[dim]:
                    bucket = bucket[0]
                else:
                    bucket = bucket[1]

            for result in bucket.generate_matches(point):
                yield result
        else:
            # We don't. Perform linear search.
            for el, bbox in self.elements:
                yield el

    def visualize(self, file):
        file.write("%f %f\n" % (self.bottom_left[0], self.bottom_left[1]));
        file.write("%f %f\n" % (self.top_right[0], self.bottom_left[1]));
        file.write("%f %f\n" % (self.top_right[0], self.top_right[1]));
        file.write("%f %f\n" % (self.bottom_left[0], self.top_right[1]));
        file.write("%f %f\n\n" % (self.bottom_left[0], self.bottom_left[1]));
        if self.buckets:
            for i in self.all_buckets:
                i.visualize(file)





