#!/usr/bin/env python
# coding: utf-8

from os import listdir
from os.path import splitext
from sys import argv

format_str_with_part = r'\Figure[caption={{Block Diagram of {0} Part {1}}}]{{Block/{2}.png}}'
format_str_without_part = r'\Figure[caption={{Block Diagram of {0}}}]{{Block/{2}.png}}'

def remove_extension(filename):
	return splitext(filename)[0]

def main(input_path='.'):
	all_files = listdir(input_path)
	if argv[0] in all_files:
		# Remove this script file from the list of files.
		all_files.remove(argv[0])
	if 'out.txt' in all_files:
		# Remove the output file.
		# Normally I'd use python split_img_to_figures.py > out.py
		all_files.remove('out.txt')
	for filename in all_files:
		filename = remove_extension(filename)
		entity = filename[:-2]
		entity_number = filename[-2:]
		# Crop off any starting zeroes from the filename.
		entity_number = str(int(entity_number))
		if entity_number == '0':
			# Check if the image was split.
			# If so, we need to display what part of each image we are showing.
			# If not, do not state that the image is a "part" of a full image.
			next_entity = entity + '01.png'
			# For LaTeX's sake, we must delimit all underscores in non-filenames.
			entity = entity.replace('_', '\\_')
			if next_entity in all_files:
				# Another subimage exists. This is image 00 of multiple images.
				print(format_str_with_part.format(entity, entity_number, filename))
			else:
				# No other subimages exist.
				print(format_str_without_part.format(entity, entity_number, filename))
		else:
			# We are on a filename that is clearly a subimage.
			# For LaTeX's sake, we must delimit all underscores in non-filenames.
			entity = entity.replace('_', '\\_')
			print(format_str_with_part.format(entity, entity_number, filename))

if __name__ == '__main__':
	if len(argv) <= 1:
		main()
	else:
		main(argv[1])
