# -*- coding: utf-8 -*-
import sys
import numpy as np
import random

halflife_of_memory_cell_no_infection = 402
cell_cycle_of_germinal_center_cell_under_infection = 4 / 24
capacity_of_memory_cell_no_infection = 100000
capacity_of_germinal_center_cell_under_infection = 10000
proportion_of_germinal_center_cell_becoming_plasma_cell_per_cell_cycle = 0.25
proportion_of_germinal_center_cell_becoming_memory_cell_per_cell_cycle = 0.01

birth_rate_no_infection = 0
death_rate_with_nonsense_muatation = 1000
death_rate_of_germinal_center_cell_no_infection = 1000
death_rate_of_memory_cell_no_infection = 1.0 / halflife_of_memory_cell_no_infection
occupancy_factor_on_death_rate_no_infection = 0
birth_rate_of_germinal_center_cell_under_infection = 1 / cell_cycle_of_germinal_center_cell_under_infection
rate_of_germinal_center_cell_becoming_plasma_cell = birth_rate_of_germinal_center_cell_under_infection * proportion_of_germinal_center_cell_becoming_plasma_cell_per_cell_cycle
affinity_factor_on_death_rate_of_germinal_center_cell_under_infection = (1 - proportion_of_germinal_center_cell_becoming_plasma_cell_per_cell_cycle - proportion_of_germinal_center_cell_becoming_memory_cell_per_cell_cycle) * birth_rate_of_germinal_center_cell_under_infection / capacity_of_germinal_center_cell_under_infection
blosum_score_factor_on_log_affinity_for_selection = 0.1
blosum_score_factor_on_log_affinity_for_activation = 0.5 * blosum_score_factor_on_log_affinity_for_selection
total_affinity_threshold_for_cure_over_capacity = np.exp(20 * -15 * blosum_score_factor_on_log_affinity_for_selection)
regular_mutation_rate_per_basepair_per_generation = 2.7e-9
hypermutation_rate_per_basepair_per_generation = 1e-3
rate_germinal_center_cell_becoming_memory_cell = birth_rate_of_germinal_center_cell_under_infection * proportion_of_germinal_center_cell_becoming_memory_cell_per_cell_cycle
cdr1_start = 29
cdr1_end = 34
cdr2_start = 57
cdr2_end = 67
cdr3_start = 98
cdr3_end = 110
non_cdr_region_affinity_factor_modifier = 1 / 3
affinity_factor_on_rate_memory_cell_becoming_germinal_center_cell = 0.01 * np.exp(6 * 15 * blosum_score_factor_on_log_affinity_for_activation)
total_affinity_threshold_for_cure = capacity_of_germinal_center_cell_under_infection * total_affinity_threshold_for_cure_over_capacity
starting_dna_sequence = "CAAATGCAGCTGGTGCAGTCTGGGCCTGAGGTGAAGAAGCCTGGGACCTCAGTGAAGGTCTCCTGCAAGGCTTCTGGATTCACCTTTACTAGCTCTGCTGTGCAGTGGGTGCGACAGGCTCGTGGACAACGCCTTGAGTGGATAGGATGGATCGTCGTTGGCAGTGGTAACACAAACTACGCACAGAAGTTCCAGGAAAGAGTCACCATTACCAGGGACATGTCCACAAGCACAGCCTACATGGAGCTGAGCAGCCTGAGATCCGAGGACACGGCCGTGTATTACTGTGCGGCACCGCACTGCAGCGGCGGCAGCTGCCTCGATGCTTTTGATATCTGGGGCCAAGGGACAATGGTCACCGTCTCTTCA"
starting_aa_sequence = "QVQLVQSGPEVKKPGTSVKVSCKASGFTFTSSAVQWVRQARGQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAPHCSGGSCLDAFDIWGQGTMVTVSS"
target_aa_sequences = [
"QMQLVQSGPEVKKPGTSVKVSCKTSGFTFTSSAIQWVRQARGQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAPHCNRTSCYDAFDLWGQGTMVTVSS",
"QMQLVQSGPEVKKPGTSVKVSCKASGFTFSSSAVQWVRQARGQHLEWIGWIVVGSGNTNYAQKFQERVTLTRDMSTRTAYMELSSLRSEDTAVYYCAAPNCNSTTCHDGFDIWGQGTVVTVSS",
"QVQLVQSGPEVKKPGTSVRVSCKASGFTFTSSAVQWVRQARGQRLEWVGWIVVGSGNTNYAQKFHERVTITRDMSTSTAYMELSSLRSEDTAVYYCASPYCSGGSCSDGFDIWGQGTMVTVSS",
"QMQLVQSGPEVKKPGTSVKVSCKASGFTFTSSAVQWVRQARGQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAPYCSGGSCFDGFDIWGQGTMVTVSS",
"QVQLVQSGPEVKKPGTSVKVSCKASGFTFTTSAVQWVRQARGQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTTTAYMELSSLRSEDTAVYFCAAPHCNSTSCYDAFDIWGQGTMVTVSS",
"QVQLVQSGPEVKKPGTSVKVSCKASGFTFTNSAVQWVRQSRRQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAVDCNSTSCYDAFDIWGQGTMVTVSS",
"QMQLVQSGPEVKKPGTSVKVSCKASGFTFMSSAVQWVRQARGQRLEWIGWIVIGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAPYCSSISCNDGFDIWGQGTMVTVSS",
"QVQLVQSGPEVKKPGTSVKVSCKASGFTFPSSAVQWVRQARGQRLEWIGWIVVGSGNTNYAQKFQERVTITRDMSTSTAYMELSSLRSEDTAVYYCAAPHCGGGSCYDGFDIWGQGTMVTVSS",
"QVQLVESGPEMKKPGTSVKVSCKASGFTFITSAVQWVRQARGQRLEWMGWIAVGSGNTNYAQKFQDRVTINRDMSTSTAYMELSSLRSEDTAVYYCAAPHCNRTSCHDGFDIWGQGTMVTVSS",
"QMQLVQSGPEVKKPGTSVKVSCKASGFTFTNSAMQWVRQARGQRLEWVGWIVVASGNANSARRFHDRVTITSDMSTSTAYLELSSLRSEDTAVYYCALNHCSNTTCLDGFDIWGQGTMVSVSS",
"QMHLVQSGPEVKKPGTSVKVSCKASGFTFSSSAVQWVRQARGQHLEWIGWIVVGSGNTNYGQKFQERVTITRDLSTSTVYMELISLRSEDTAVYFCAAPYCTGGSCFDAFDIWGQGTMVTVSS",
"EVQLVESGPEVKKPGTSVKVSCKASGFSFSMSAMQWVRRARGQRLEWIGWIVPGSGNANYAQKFQERVTITRDESTNTGYMELSSLRSEDTAVYYCAAPHCNKTNCYDAFDIWGQGTMVTVSS",
"QMQLVQSGPEVKKPGTSAKVACQASGFTFYSSAIQWVRQARGQRLEWIGWIVVGSGNTNYAEEFQERVTITRDMSTSTAYMELSSLRSGDTAVYYCAAPHCNRTSCYDGFDIWGQGTMVTVSS"]
time = [41, 98, 163, 272, 283, 430, 458, 504, 575, 609, 641, 743, 785]
selected = sorted(random.sample([i for i in range(len(time))] , 5))
target_sequences = [target_aa_sequences[selected[0]]]
condition_switch_time = [time[selected[0]]]
for i in range(1, 5):
    j = selected[i]
    if time[j] > time[selected[i-1]] + 50:
        target_sequences.append(target_aa_sequences[j])
        condition_switch_time.append(time[j])
time_interval_for_logging_with_infection = 0.1
time_interval_for_logging_no_infection = 20
phylogenetic_tree_taxon_sample_size = 200
number_of_infection_targets = len(target_sequences)
print("%.6e" % birth_rate_no_infection)
print("%.6e" % death_rate_with_nonsense_muatation)
print("%.6e" % death_rate_of_germinal_center_cell_no_infection)
print("%.6e" % death_rate_of_memory_cell_no_infection)
print("%.6e" % occupancy_factor_on_death_rate_no_infection)
print("%.6e" % birth_rate_of_germinal_center_cell_under_infection)
print("%.6e" % rate_of_germinal_center_cell_becoming_plasma_cell)
print("%.6e" % affinity_factor_on_death_rate_of_germinal_center_cell_under_infection)
print("%.6e" % blosum_score_factor_on_log_affinity_for_selection)
print("%.6e" % blosum_score_factor_on_log_affinity_for_activation)
print("%.6e" % regular_mutation_rate_per_basepair_per_generation)
print("%.6e" % hypermutation_rate_per_basepair_per_generation)
print("%.6e" % rate_germinal_center_cell_becoming_memory_cell)
print("%.6e" % affinity_factor_on_rate_memory_cell_becoming_germinal_center_cell)
print("%.6e" % total_affinity_threshold_for_cure)
print(starting_dna_sequence)
print("%.6e" % time_interval_for_logging_with_infection)
print("%.6e" % time_interval_for_logging_no_infection)
print(cdr1_start)
print(cdr1_end)
print(cdr2_start)
print(cdr2_end)
print(cdr3_start)
print(cdr3_end)
print("%.6e" % non_cdr_region_affinity_factor_modifier)
print(phylogenetic_tree_taxon_sample_size)
print(number_of_infection_targets)
for i in range(number_of_infection_targets):
    print(target_sequences[i])
    print(condition_switch_time[i])
