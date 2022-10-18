import sys
import numpy as np

names = {}
parent = {}
root = 0
nodecnt = 1
text = ""
index = 1

idt = {root:root}

def identity(i):
    global idt
    if idt[i] == i:
        return i
    else:
        return identity(idt[i])
    
def build(p):
    global names
    global parent
    global nodecnt
    global text
    global index
    global idt
    
    cur = nodecnt
    nodecnt += 1
    parent[cur] = p
    if text[index] == '(':
        while text[index] != ')':
            index += 1
            build(cur)
        index += 1
    else:
        s = ""
        while text[index] not in ":,)":
            s += text[index]
            index += 1
        names[cur] = s
    while text[index] not in ":,)":
        index += 1
    if text[index] == ":":
        index += 1
        s = ""
        while text[index] not in ",)":
            s += text[index]
            index += 1
        if float(s) < 0.001:
            idt[cur] = p
        else:
            idt[cur] = cur
    

with open(sys.argv[1], "r") as ins:
	for line in ins:
		text += line.split()[0]

if text[index] != "(":
    while text[index] != ",":
        index += 1
    index += 1        
build(root)

print len(names)
print len([i for i in parent if idt[i] == i])
print root
for i in names:
	print names[i], identity(i)
for i in parent:
    if idt[i] == i:
        print identity(parent[i]), i
