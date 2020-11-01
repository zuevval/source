from Bio import SeqIO


def main():
    for infile, outfile, comment in [("seq.aln", "seq-aln.fasta", "DNA"), ("trans.aln", "trans-aln.fasta", "protein")]:
        records = SeqIO.parse(infile, "clustal")
        count = SeqIO.write(records, outfile, "fasta")
        print("converted {} {} records".format(count, comment))


if __name__ == "__main__":
    main()
