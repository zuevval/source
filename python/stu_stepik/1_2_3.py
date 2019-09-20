# introduction to bioinformatics - Stepik. Ex. 1.2.5
dna = input().upper()
nuclei = {'A':0, 'G':0, 'T':0, 'C':0}
for gene in dna:
    if nuclei.get(gene) is None:
        print('err:unexpected symbol. Expected symbols in AGTC')
        continue
    nuclei[gene] += 1

dna_len = len(dna)
for gene in 'AGCT':
    gene_fraction = nuclei[gene] / dna_len
    if gene_fraction % 1 < 0.05:
        print(gene + ' ' + str(round(gene_fraction)))
        continue
    ans = gene + ' ' + "%.2f" % gene_fraction
    if (ans[len(ans) - 1]) == '0':
        ans = ans[:-1]
    print(ans)

