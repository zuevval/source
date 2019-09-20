n = int(input())
lines = [input () for _ in range(n)]
maxlen = max(map(len, lines))

for length in range(maxlen, 0, -1):
    maxlines = list(filter (lambda str : len(str) >= length, lines)))
    checked_substrs = {}
    for line in maxlines:
        pass
