`ifndef UTILS
`define UTILS
// Calculates the number of bits for an unsigned integer
function integer nbits (input integer num);
	begin
		num = num - 1;
		for(nbits = 0; num > 0; nbits = nbits + 1)
			num = num >> 1;
	end
endfunction

// Calculates the square of an integer
function integer sq (input integer dim);
	begin
		sq = dim ** 2;
	end
endfunction

// Calculates the 
function integer sqbits (input integer dim);
	begin
		sqbits = nbits(dim ** 2);
	end
endfunction
`endif
