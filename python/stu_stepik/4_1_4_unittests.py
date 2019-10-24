import unittest
import s414

class TestGetLocations(unittest.TestCase):

    def test_sample_stepik(self):
        ref = [23.11, 2.82, 28.85, 3.16, 7.65, 6.45, 2.05, 6.86, 1.33, 8.58, 11.67, 23.22, 2.98, 28.9, 3.12, 7.41, 6.65, 2.06, 6.87, 1.32, 8.58, 11.65, 23.22, 2.88, 28.84, 3.52, 7.48, 6.84, 2.05, 6.88, 1.34, 8.57, 11.67, 23.15, 2.86, 1.32, 30.49, 7.42, 6.37]
        query = [2.027, 6.845, 1.305, 8.56, 11.63]
        expected = [(6, 5), (17, 5), (28, 5)]
        self.assertEqual(s414.get_locations(ref, query), expected)


    def test_equal(self):
        ref = [1, 1, 1, 1]
        query = [1, 1, 1, 1]
        expected = [(0, 4)]
        self.assertEqual(s414.get_locations(ref, query), expected)

    def test_simple(self):
        ref = [1, 1, 1, 1, 1]
        query = [1, 1, 1, 1]
        expected = [(0, 4), (1, 4)]
        self.assertEqual(s414.get_locations(ref, query), expected)

    def test1(self):
        query = [1, 2.001, 3.5]
        qty = 50
        ref = query * qty
        expected = [(i*3, len(query)) for i in range(qty)]
        self.assertEqual(s414.get_locations(ref, query), expected)


unittest.main()
