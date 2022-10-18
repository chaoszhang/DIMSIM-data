import sys
import numpy as np
from sets import Set
from heapq import *

names = []
seqs = []
used = Set()
with open(sys.argv[1], "r") as ins:
	isTag = True
	for line in ins:
		text = line.split()[0]
		if isTag:
			names.append(text[1:])
		else:
			seqs.append(text)
		isTag = not isTag

def dist(i, j):
	return len([k for k in range(len(seqs[i])) if seqs[i][k] != seqs[j][k]])

n = len(seqs)	
used.add(0)
h = []
path = []
for i in range(1, n):
	heappush(h, (dist(0, i), 0, i))
	
for r in range(1, n):
	i = heappop(h)
	while i[2] in used:
		i = heappop(h)
	path.append((i[1], i[2]))
	used.add(i[2])
	for j in [k for k in range(n) if k not in used]:
		heappush(h, (dist(i[2], j), i[2], j))

print n
print n - 1
print 0
for i in range(n):
	print names[i], i
for i in path:
	print i[0], i[1]