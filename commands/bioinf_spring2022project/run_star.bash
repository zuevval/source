#!/bin/bash
# to run on cluster

export star_cmd="/home/nilmbb/share/plants/STAR"
export gen_dir="/home/nilmbb/share/plants/Genomes/flax/Lusitatissimum/v2.0/flax_pseudomolecules_v2.0_2020/STAR"
export fastq_dir="/home/nilmbb/vzuev/LusGen"

mkdir -p $out_dir

echo "STAR command:"
echo $star_cmd
echo "Genome dir:"
echo $gen_dir
echo "FASTQ dir:"
echo $fastq_dir

for i in {55..62}; do
  export out_dir="${fastq_dir}/SRR81777${i}/"
  echo "Output dir:"
  echo $out_dir
done


$star_cmd --runThreadN 40 --genomeDir $gen_dir --readFilesIn \
	"${fastq_dir}/SRR8177762_1_paired.fastq" \
	"${fastq_dir}/SRR8177762_2_paired.fastq" \
	--outFileNamePrefix $out_dir \
	--quantMode GeneCounts

# srun -N 1 ./run_star.bash
