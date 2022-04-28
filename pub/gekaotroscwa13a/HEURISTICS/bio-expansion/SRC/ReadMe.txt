
REQUIRED/RECOMMENDED PROGRAMS
=============================

- gringo:
  version 2.0.2 (or later) available at
  http://sourceforge.net/project/showfiles.php?group_id=238741

- clasp:
  version 1.2.0 (or later) available at
  http://potassco.svn.sourceforge.net/viewvc/potassco/branches/projection/


RESOURCES
=========

- The directory ecoli-draftnetworks contains the draft-networks created by removing reactions from the original E.coli network.

- The directory metacyc-networks contains the complete metacyc network as well as subnets with only 5000 to 9000 reaction.

- The directory ecoli-seeds-and-target contains the logic program representation of the seeds and targets described in our paper "Metabolic Network Expansion with Answer Set Programming".


USAGE
=====

   1. to compute the minimal number of reactions that need to be added to produce target metabolite 24 with the draft network 0268 type:
  
gringo card_min_extensions_all_targets.lp ecoli-networks/ecoliDraft_0268.lp ecoli-seeds-and-targets/ecoli_seeds.lp ecoli-seeds-and-targets/ecoli_target24.lp metacyc-networks/metacyc_complete.lp draftnetwork_id.lp | clasp --restart-on-model --stats

  2. to compute the all optimal solutions type:

gringo card_min_extensions_all_targets.lp ecoli-networks/ecoliDraft_0268.lp ecoli-seeds-and-targets/ecoli_seeds.lp ecoli-seeds-and-targets/ecoli_target24.lp metacyc-networks/metacyc_complete.lp draftnetwork_id.lp | clasp --opt-all --opt-val=3 --stat

  Note, the otimal value stands for the Optimization value obtained in the first step.

  3. to compute the minimal number of reactions (from metacyc-7000_0) that need to be added to produce all target metabolites type:
  
  gringo card_min_extensions_all_targets.lp ecoli-networks/ecoliDraft_0444.lp ecoli-seeds-and-targets/ecoli_seeds.lp ecoli-seeds-and-targets/ecoli_targets_all.lp metacyc-networks/metacyc_7000_0.lp draftnetwork_id.lp | clasp --restart-on-model --stats


  4. to compute the minimal number of seeds that the ecoli network needs to  produce all targets type:
  
  gringo card_min_seeds_all_producible_targets.lp ecoli-networks/ecoli_draftnetwork.lp ecoli-seeds-and-targets/ecoli_targets_all.lp | clasp --restart-on-model --heu=vsids --save-progress --stats