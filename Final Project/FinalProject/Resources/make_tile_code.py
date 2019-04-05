from sys import exit
import pprint

# Do not create row 8. It is all blocks.
all = [[(row, 4 * i + 3, 4 * i) for i in range(11)] for row in range(8)]

# Ignore row 0. It is all blocks.
all = all[1:]

# Remove the first and last tiles of all rows. They are blocks.
for i in range(len(all)):
	all[i] = all[i][1:-1]

"""
# Remove even numbered blocks from even numbered rows.
for i in range(len(all)):
	if i % 2 != 0:
		all[i] = [all[i][j] for j in range(len(all)) if j % 2 == 0]
"""

q = all[1]
all[1] = [q[0], q[2], q[4], q[6], q[8]]
q = all[3]
all[3] = [q[0], q[2], q[4], q[6], q[8]]
q = all[5]
all[5] = [q[0], q[2], q[4], q[6], q[8]]

#pprint.pprint(all)
#exit(0)

# "data" stores (row_number, bit_higher_end, bit_lower_end).
varnum = -1
for tilerow in all:
	for data in tilerow:
		varnum += 1
		varname = 'n' + str(varnum)
		row_num, high_bit, low_bit = data
		#            NewTiles1(7 downto 4) <= NewTiles(7) & "00" & (not NewTiles(6) and not NewTiles(5) and NewTiles(4));
		print(('            NewTiles{0}({4} downto {1}) <= ' + \
			'NewTiles{0}({4}) & "00" & (not NewTiles{0}({3}) ' + \
			'and not NewTiles{0}({2}) and NewTiles{0}({1}));').format(
			row_num, low_bit, str(int(low_bit)+1), str(int(low_bit)+2), high_bit))
		
		continue
		print('            ' + varname + \
			' := Tiles{}({} downto {});'.format(data[0], data[1], data[2]))
		print('            if {0} = TILE_BRICK_BROKEN or {0} = TILE_EXP_CENTER or {0} = TILE_EXP_UP or {0} = TILE_EXP_DOWN or {0} = TILE_EXP_LEFT or {0} = TILE_EXP_RIGHT then'.format(varname))
		print('                NewTiles{}({} downto {}) <= TILE_EMPTY;'.format(*data))
		print('            end if;')

