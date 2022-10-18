import sys

names = {}
parent = {}
root = 0

with open(sys.argv[1], "r") as ins:
    for line in ins:
        text = line.split()
        if text[1][0] != '0':
            names[text[2]] = text[2]
        if text[2] != text[0]:
            parent[text[2]] = text[0]
        root = text[0]
print len(names)
print len(parent)
print root
for i in names:
    print names[i], i
for i in parent:
    print parent[i], i

