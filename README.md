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

## COVID/tree/real/*.sh

Shell scripts to run reconstruction methods.

## COVID/tree/real/[replicate]/[samplesize]/*

Reconstructed trees in raw format

dnapars: `RAxML_MajorityRuleExtendedConsensusTree.dnapars_greedy` and `RAxML_MajorityRuleConsensusTree.dnapars_consensus`

beast: `beast.nexus`

raxml: `RAxML_bestTree.raxml-with-root`

igphyml: `seq_with_root.fasta_igphyml_tree_igphyml.txt`

gctree: `gctree.nw`

immunitree: `immunitree.txt`

mst: `mst.result`

# Flu experiments

Full data files for Flu simulations are available at https://drive.google.com/file/d/1NQo4lggUeCvmlA1PTox-j_fqutL1F22L/view?usp=sharing.
