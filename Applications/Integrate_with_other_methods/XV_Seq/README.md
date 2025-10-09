## Application to XV_seq data
### run scMutrace
Example: https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart

#### Step1. run scMutrace (same to GoT_seq)
> [GoT_seq](https://github.com/QunATCG/scMutrace-tutorial/tree/main/Applications/Integrate_with_other_methods/GoT_Seq)

> **Note:** The following script is intended to be run on a SLURM-managed cluster environment. Save the script to a file (e.g., `run_scMutrace.slurm`) and submit it using the `sbatch` command: `sbatch run_scMutrace.slurm`

> scMutrace can be found [here](https://github.com/QunATCG/scMutrace)

#### Step2. run gCSM for downstream anaysis (same to GoT_seq)
> [GoT_seq](https://github.com/QunATCG/scMutrace-tutorial/tree/main/Applications/Integrate_with_other_methods/GoT_Seq)

> **Note:** The following script is intended to be run on a SLURM-managed cluster environment. Save the script to a file (e.g., `run_gCSM.slurm`) and submit it using the `sbatch` command: `sbatch run_gCSM.slurm`

### Downstream anaysis
#### run with R codes