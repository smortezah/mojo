# ===----------------------------------------------------------------------=== #
# Copyright (c) 2024, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #
# RUN: %mojo %s

from collections.list import List

from testing import assert_equal

from utils import InlineArray, Span


def test_span_list_int():
    var l = List[Int](1, 2, 3, 4, 5, 6, 7)
    var s = Span(list=l)
    assert_equal(len(s), len(l))
    for i in range(len(s)):
        assert_equal(l[i], s[i])
    # subslice
    var s2 = s[2:]
    assert_equal(s2[0], l[2])
    assert_equal(s2[1], l[3])
    assert_equal(s2[2], l[4])
    assert_equal(s2[3], l[5])
    assert_equal(s[-1], l[-1])

    # Test mutation
    s[0] = 9
    assert_equal(s[0], 9)
    assert_equal(l[0], 9)

    s[-1] = 0
    assert_equal(s[-1], 0)
    assert_equal(l[-1], 0)


def test_span_list_str():
    var l = List[String]("a", "b", "c", "d", "e", "f", "g")
    var s = Span(l)
    assert_equal(len(s), len(l))
    for i in range(len(s)):
        assert_equal(l[i], s[i])
    # subslice
    var s2 = s[2:]
    assert_equal(s2[0], l[2])
    assert_equal(s2[1], l[3])
    assert_equal(s2[2], l[4])
    assert_equal(s2[3], l[5])

    # Test mutation
    s[0] = "h"
    assert_equal(s[0], "h")
    assert_equal(l[0], "h")

    s[-1] = "i"
    assert_equal(s[-1], "i")
    assert_equal(l[-1], "i")


def test_span_array_int():
    var l = InlineArray[Int, 7](1, 2, 3, 4, 5, 6, 7)
    var s = Span[Int](array=l)
    assert_equal(len(s), len(l))
    for i in range(len(s)):
        assert_equal(l[i], s[i])
    # subslice
    var s2 = s[2:]
    assert_equal(s2[0], l[2])
    assert_equal(s2[1], l[3])
    assert_equal(s2[2], l[4])
    assert_equal(s2[3], l[5])

    # Test mutation
    s[0] = 9
    assert_equal(s[0], 9)
    assert_equal(l[0], 9)

    s[-1] = 0
    assert_equal(s[-1], 0)
    assert_equal(l[-1], 0)


def test_span_array_str():
    var l = InlineArray[String, 7]("a", "b", "c", "d", "e", "f", "g")
    var s = Span[String](array=l)
    assert_equal(len(s), len(l))
    for i in range(len(s)):
        assert_equal(l[i], s[i])
    # subslice
    var s2 = s[2:]
    assert_equal(s2[0], l[2])
    assert_equal(s2[1], l[3])
    assert_equal(s2[2], l[4])
    assert_equal(s2[3], l[5])

    # Test mutation
    s[0] = "h"
    assert_equal(s[0], "h")
    assert_equal(l[0], "h")

    s[-1] = "i"
    assert_equal(s[-1], "i")
    assert_equal(l[-1], "i")


def test_indexing():
    var l = InlineArray[Int, 7](1, 2, 3, 4, 5, 6, 7)
    var s = Span[Int](array=l)
    assert_equal(s[True], 2)
    assert_equal(s[int(0)], 1)
    assert_equal(s[3], 4)


def test_span_slice():
    var l = List(1, 2, 3, 4, 5)
    var s = Span(l)
    var res = s[Slice(1, 2)]
    assert_equal(res[0], 2)

    res = s[Slice(1, -1, 1)]
    assert_equal(res[0], 2)
    assert_equal(res[1], 3)
    assert_equal(res[2], 4)

    res = s[1::-1]
    assert_equal(res[0], 2)
    assert_equal(res[1], 1)

    res = s[1:6:2]
    assert_equal(len(res), 2)
    assert_equal(res[0], 2)
    assert_equal(res[1], 4)

    res = s[-1:-4:-1]
    assert_equal(len(res), 3)
    assert_equal(res[0], 5)
    assert_equal(res[1], 4)
    assert_equal(res[2], 3)

    res = s[1:-1]
    assert_equal(len(res), 3)
    assert_equal(res[0], 2)
    assert_equal(res[1], 3)
    assert_equal(res[2], 4)

    res = s[3:2]
    assert_equal(len(res), 0)

    var str_l = String("[1,2,3,4]")
    var str_span = str_l.as_bytes_slice()
    var sliced = str_span[1:-1]
    assert_equal(len(sliced), 7)
    assert_equal(chr(int(sliced[0])), "1")
    assert_equal(chr(int(sliced[1])), ",")
    assert_equal(chr(int(sliced[2])), "2")
    assert_equal(chr(int(sliced[3])), ",")
    assert_equal(chr(int(sliced[4])), "3")
    assert_equal(chr(int(sliced[5])), ",")
    assert_equal(chr(int(sliced[6])), "4")


def test_span_iter():
    var l = List(1, 2, 3, 4, 5)
    var s = Span(l)
    var it = s[1:6:2].__iter__()
    assert_equal(len(it), 2)
    var first = it.__next__()
    assert_equal(first[], 2)
    var second = it.__next__()
    assert_equal(second[], 4)


def main():
    test_span_list_int()
    test_span_list_str()
    test_span_array_int()
    test_span_array_str()
    test_indexing()
    test_span_slice()
    test_span_iter()
