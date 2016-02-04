// ----------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------
// FILE NAME            : core_if_s.sv
// PROJECT                : Selen
// AUTHOR                 : Alexsandr Bolotnokov
// AUTHOR'S EMAIL 				:	AlexBolotnikov@gmail.com 			
// ----------------------------------------------------------------------------
// DESCRIPTION        : memory phase of pipline 
// ----------------------------------------------------------------------------
module core_mem (
	input 					clk,
	input 					rst_n,
	input					mem_enb,
	input					mem_kill,

	input[6:0]				mem_ld1_bus_in,
	input[31:0]				mem_cahs_reg_in,//casheble or uncashble 
	input					mem_mux_in,
	input					mem_we_reg_file_in,
	input					mem_alu_result_in,
	input					mem_brnch_takenn_in,
	input[31:0]				mem_wrt_data_in,
	input[31:0]				mem_sx_imm_in,
	input[31:0]				mem_pc_4_in,
	input[31:0]				mem_addr_in,
	input[2:0]				mem_wb_sx_in,

	input[14:0]				mem_hazrd_bus_in,
	input					mem_bp_mux_in,

	output[6:0]				mem_ld1_bus_out,
	output 					mem_wrt_data_mem_out,

	output[31:0]	reg 	mem_alu_result_reg_out,
	output[31:0]	reg 	mem_sx_imm_reg_out,
	output[31:0]	reg 	mem_pc_4_reg_out,
	output 			reg 	mem_we_reg_file_out_reg,
	output 			reg 	mem_mux_out_reg,
	output[2:0]		reg 	mem_wb_sx_type_out_reg
);
wire cash_ucash;
always @(posedge clk) begin 
	if(mem_enb) begin
		mem_alu_result_reg_out <= 	mem_alu_result_in;
		mem_sx_imm_reg_out <= 		mem_sx_imm_in;
		mem_pc_4_reg_out <= 		mem_pc_4_in;
		mem_we_reg_file_out_reg <= 	mem_we_reg_file_in;
		mem_mux_out_reg <=			mem_mux_in;
		mem_wb_sx_type_out_reg <=	mem_wb_sx_in;
	end
	if(mem_kill) begin
		mem_alu_result_reg_out <= 	0;
		mem_sx_imm_reg_out <= 		0;
		mem_pc_4_reg_out <= 		0;
		mem_we_reg_file_out_reg <= 	0;
		mem_mux_out_reg <=			0;
		mem_wb_sx_type_out_reg <=	0;
	end	
end
assign mem_wrt_data_in = (mem_bp_mux_in)?mem_bp_from_wb_data_in:mem_wrt_data_in;
assign cash_ucash = (mem_alu_result_in > mem_cahs_reg_in) CASHBLE:UNCASHEBLE;
assign mem_ld1_bus_out[CASH_BIT] = cash_ucash;

endmodule // core_mem