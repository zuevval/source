#count average of numbers in each string in a file
with open('dataset.txt', 'r') as file:
    average = 0
    count = 0
    for line in file:
        if not len(line):
            continue
        count += 1
        lst = line.split()
        #lst = list(map(float, lst))
        average += len(lst)
    average /= count
    print(average)
        
