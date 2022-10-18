#!/usr/bin/env Rscript
require(ape)
args = commandArgs(trailingOnly=TRUE)
tree = read.nexus(args[1])
write.tree(tree, args[2])
