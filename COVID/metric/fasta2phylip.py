import sys
import numpy as np

names = []
seqs = []
with open(sys.argv[1], "r") as ins:
	isTag = True
	for line in ins:
		text = line.split()[0]
		if isTag:
			names.append(text[1:] + "".join([' '] * (10 - len(text[1:]))))
		else:
			seqs.append(text)
		isTag = not isTag

print len(seqs), len(seqs[0])
for i in range(len(seqs)):
    print names[i] + seqs[i]