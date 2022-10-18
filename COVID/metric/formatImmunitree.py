import sys
import numpy as np

names = {}
parent = {}
root = 1

revNames = {}
       
with open(sys.argv[1], "r") as ins:
    lineNum = 0
    for line in ins:
        lineNum += 1
        if lineNum > 2:
            text = line.split(",")
            parent[int(text[0])] = int(text[1])
            revNames[text[5].split()[0]] = int(text[0])

with open(sys.argv[2], "r") as ins:
    isTag = True
    for line in ins:
        text = line.split()[0]
        if isTag:
            name = text[1:]
        elif name != "root":
            element = min([(len([k for k in range(len(seq)) if seq[k] != text[k]]), revNames[seq]) for seq in revNames])
            if element[0] == 0:
                names[element[1]] = name
            else:
                v = max([i for i in parent]) + 1
                parent[v] = element[1]
                names[v] = name
        isTag = not isTag

print len(names)
print len(parent)
print root
for i in names:
    print names[i], i
for i in parent:
    print parent[i], i