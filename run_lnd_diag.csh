#! /bin/tcsh -f
#SBATCH --job-name=b.e11.BRCP85BCRD.f09_g16.iESM_coupled.001
#SBATCH --time=4:00:00
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mail-type=END
#SBATCH --mail-user=shix@ornl.gov
#SBATCH --output=lnd_diag%jodid.out
#SBATCH --error=lnd_diag%jodid.err
#SBATCH -p regular
#SBATCH -C haswell

./lnd_diag_test.csh >&! lnd_diag.log
