# DIMSIM-data

# SARS-Cov2 experiments

## COVID/setup/*

Python script to generate parameters (arguments.txt) for each replicate of COVID simulations

## COVID/simulator/*

### arguments.txt

One example of input parameters for the simulator

### kemrFreq.txt

Our 5-mer model; Yaari's 5-mer model is kmerFreq_yaari.txt

### simulator.hpp

Our evolution model

### main.cpp

Our driver code defining the flu simulation

### simulator

Binary compiled with command `g++ -std=c++11 -O3 main.cpp -o simulator`

## COVID/reconstruction_tools/*

Reconstruction tools and helper scripts we implemented

## COVID/tree/real/*.sh

Shell scripts to run reconstruction methods

## COVID/tree/real/[replicate]/[samplesize]/*

Reconstructed trees in raw format

dnapars: `RAxML_MajorityRuleExtendedConsensusTree.dnapars_greedy` and `RAxML_MajorityRuleConsensusTree.dnapars_consensus`

beast: `beast.nexus`

raxml: `RAxML_bestTree.raxml-with-root`

igphyml: `seq_with_root.fasta_igphyml_tree_igphyml.txt`

gctree: `gctree.nw`

immunitree: `immunitree.txt`

mst: `mst.result`


## COVID/output/[replicate]/[samplesize]/*

Simulated and reconstructed trees in the following format:

```
[#labels]
[#branches]
[root]
[label_1 node_1]
[label_2 node_2]
...
[parent_1 child_1]
[parent_2 child_2]
...
```

## COVID/metric/*

Evaluation metrics and scripts to help formating trees to the format above

## COVID/stat/*

Figures in the paper along with scripts and data to reproduce those figures

# Flu experiments

## stat/*

Figures in the paper along with scripts and data to reproduce those figures

## other data

Full data files for Flu simulations are available at https://drive.google.com/file/d/1NQo4lggUeCvmlA1PTox-j_fqutL1F22L/view?usp=sharing.
