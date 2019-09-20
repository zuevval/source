
t = int(input())
lst = list(map(int, input().split()))
dic = {}
dummy = 0
for i in lst:
    dic[i] = dummy
n = len(lst)
for i in range(n):
    sibling = t - lst[i]
    if dic.get(sibling) != None:
        j = lst.index(sibling)
        if i == j:
            continue
        if j > i:
            print (str(i) + ' ' + str(j))
        else:
            print(str(j) + ' ' + str(i))
        break
    
    
