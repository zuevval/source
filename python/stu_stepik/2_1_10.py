'''
finds the longest string in a sequence
which is not a substring of any other in that sequence.
substring is any subsequence of symbols in an order as in original string
e. g. 'abc' is a substring of 'aabbcc', 'acb' - not
'''

def if_contains(line, sub):
    sub_i = 0
    line_i = 0
    sub_len = len(sub)
    line_len = len(line)
    while sub_i < sub_len and line_i < line_len:
        if sub[sub_i] == line[line_i]:
            sub_i += 1
        line_i += 1
    if sub_i < sub_len:
        return False
    return True

def process(lines):
    n = len(lines)
    for i in range(n):
        substr = lines[i]
        for j in range(n):
            if i == j:
                continue
            line = lines[j]
            if len(substr) > len(line):
                # lines are reverse-sorted by length, so if 'substr' is longer
                # then it can't be a substring of any of next strings
                return(len(substr))
            if if_contains(line, substr):
                break
        else: # 'substr' isn't a substring of any of other strings 
            return(len(substr))
    else: # every line is a substring of some other line
        return(-1)

n = int(input()) # number of strings
lines = list(input () for _ in range(n))
lines.sort(key=len, reverse=True)

print(process(lines))

