// ----------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------
// FILE NAME      : sl_cache_line.sv
// PROJECT        : Selen
// AUTHOR         : Grigoriy Zhikharev
// AUTHOR'S EMAIL : gregory.zhiharev@gmail.com
// ----------------------------------------------------------------------------
// DESCRIPTION    :
// ----------------------------------------------------------------------------
`ifndef INC_SL_CACHE_LINE
`define INC_SL_CACHE_LINE

class sl_cache_line #(int LINE_WIDTH = 128) extends uvm_object;

	cache_addr_t 					addr;
	bit [LINE_WIDTH-1:0] 	data;
	cache_line_state_t 		state;

	`uvm_object_param_utils(sl_cache_line)

	function new(string name = "sl_cache_line");
		super.new(name);
		state = INV;
	endfunction

endclass
`endif