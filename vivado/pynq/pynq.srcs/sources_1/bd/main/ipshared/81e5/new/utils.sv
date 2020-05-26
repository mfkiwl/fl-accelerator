`ifndef UTILS
`define UTILS
function integer log2 (input integer bit_depth);
    begin
        for(log2 = 0; bit_depth>0; log2 = log2+1)
            bit_depth = bit_depth >> 1;
    end
endfunction
`endif
