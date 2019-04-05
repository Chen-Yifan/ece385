from sys import argv

if len(argv) > 1:
	# An argument was passed. Assume it's the file to load.
	filename = argv[1]
else:
	filename = 'in.txt'

# These are the colors outputted by Matlab.
# It comes from either the sprite sheet I got online or
# from the screenshots I take in VirtualBoyAdvance.
# Some hand massaging is involved to turn the Black color from 0 to 1.
MATLAB_BLACK = 0
MATLAB_DARK_GRAY = 168
MATLAB_LIGHT_GRAY = 96
MATLAB_WHITE = 255
MATLAB_WHITE2 = 248

# The color mapping from the Matlab text document output
# to the constant colors defined in the VHDL code for ColorTable.
# ColorTable uses two bits per color.
color_mapping = {
MATLAB_BLACK:0,
MATLAB_LIGHT_GRAY:1,
MATLAB_DARK_GRAY:2,
MATLAB_WHITE:3,
MATLAB_WHITE2:2}

all_hex = []
reading = True
with open(filename, 'r') as infile:
    while reading:
        numbers = infile.readline().split(',')
        if len(numbers) > 1:
            # The very last number has a newline stuck to it.
            numbers[-1] = numbers[-1].strip()
            if not(numbers[-1]):
                # We stripped all whitespace and got an empty array. All done.
                reading = False
        else:
            # No more numbers to read from the file.
            reading = False

        if reading and len(numbers):
            # Convert all numbers from strings to integers.
            numbers = [int(i) for i in numbers]
            hexlist = []
            # Jump across every other number and merge them into single numbers.
            # Simple C code would look like the following (char = 4 bits):
            # char a, b, out;  out = (a << 2) | b;
            # Where "a" and "b" are two bits wide and "out" is four bits wide.
            for i in range(len(numbers)/2):
                hexlist.append(
                    color_mapping[numbers[i*2]] << 2 | \
                    color_mapping[numbers[i*2+1]])
            all_hex.append(hexlist)

# Print all numbers into a format that VHDL understands.
# All of the numbers are already composed of two color patterns since
# one hex number stores 4 bits, so force the hex to display in two digits.
# The string[2:] removes the "0x" from hex numbers like "0xFF".
# See SpriteTable.vhd for sample output.
for hexvals in all_hex:
    print('x"' + ''.join(['{:#x}'.format(int(h))[2:] for h in hexvals]) + '",')
