# upload FASTQ files (processed by TrimmoMatic) from PowerHouse to cluster

scc-scp-lus(){ # securely copy file to cluster
    scp -i ~/.ssh/zuev_id_ecdsa $1 vzuev@login1.hpc.spbstu.ru:/home/nilmbb/vzuev/LusGen/
}

for i in 55 56 57 58 59 60; do
    scc-scp-lus "SRR81777${i}_1_paired.fastq.gz"
    scc-scp-lus "SRR81777${i}_2_paired.fastq.gz"
done
