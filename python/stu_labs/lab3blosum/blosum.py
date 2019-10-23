"""
BLOSUM matrix - multiple DNA sequences alignment
"""
import os

def mylog(msg):
	print(msg)

def parse_alignments(filename):
	word_idx = 1  # index of word in each string to be included in result
	res = []
	with open(filename) as fin:
		for line in fin:
			line.strip()
			words = line.split()
			if len(words) < word_idx + 1:
				mylog('can\'t parse short line: ' + line + '\n in file' + filename)
				continue
			res.append(words[word_idx])
	return res


def extract_alignments(filepath, extension):
	dir_separator = '/'
	file_separator = '.'
	res = []
	for root, dirs,  files in os.walk(filepath):
		for filename in files:
			if filename.split(file_separator)[-1] != extension:
				continue
			# if 'filename' ends with '.<extension>'...
			filepath = root + dir_separator +  filename
			res.extend(parse_alignments(filepath))
	return res

def align_alignments(alignments):
	'''
	'alignments': list of strings of different length
	Makes strings of the same length (=maxlen of initial strings) by
	completing inputs with proper number of <gap_symbol>'s
	'''
	gap_symbol = '-'
	lengths = tuple(map(len,alignments))
	maxlen = max(lengths)
	for idx, strlen in enumerate(lengths):
		diff = maxlen - strlen
		if diff > 0:
			alignments[idx] += (gap_symbol * diff)


if __name__ == '__main__':
	alignments = extract_alignments('./alignments/', 'txt')
	align_alignments(alignments)
	for line in alignments:
		print(line)

