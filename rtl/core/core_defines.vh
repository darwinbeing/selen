`define PS_START 32'b0
/// mux bus bellow 
`define R_MUX 6'b0xx000
`define I_R_MUX 6'b0xx010
`define LUI_MUX 6'bxxxxxx
`define AUIPC_MUX 6'b0xx010
`define SB_MUX	6'bx0x000
`define UJ_MUX 6'bx10xx1
`define LD_MUX 6'b111xx0
`define ST_MUX 6'bx11xx0
`define JALR_MUX 6'bx11xx1

`define CNTR_TRNS_MUX		0
`define SRC1_IMM_MUX 		1
`define SRC2_PC_MUX			2
`define PC_4_SRC1_MUX		3
`define PC_MUX3_MUX			4
`define ALU_MEM_MUX			5
// forwarding bus bellow 
`define M2E_SRC1_BP 4'bxxx0
`define W2E_SRC1_BP 4'bxx01
`define M2E_SRC2_BP 4'bx0xx
`define W2E_SRC2_BP 4'b01xx
`define W2M_BP 1'b1
`define BP_INIT 4'b1111

`define M2E_SRC1_MUX 0
`define W2E_SRC1_MUX 1
`define M2E_SRC2_MUX 2
`define W2E_SRC2_MUX 3
//regiser file 
`define ORDER_ON  	1'b1 // change order of source opperands
`define ORDER_OFF 	1'b0 // don't change order of source opperands
`define WE_ON   		1'b1
`define WE_OFF 			1'b0
//ALU controll signals 
`define ADD_ALU  4'b0000
`define SLL_ALU  4'b0001
`define SLT_ALU  4'b0010
`define SLTU_ALU 4'b0011
`define XOR_ALU  4'b0100
`define SRL_ALU  4'b0101
`define OR_ALU   4'b0110
`define AND_ALU	 4'b0111
`define SUB_ALU	 4'b1000
`define SRA_ALU  4'b1101
`define AM_ALU	 4'b1010

`define ALU_BEQ 2'b00
`define ALU_BNE 2'b01
`define ALU_BLT 2'b01
`define ALU_BLTU 2'b11
/// level one case for data descrirtion of buss
`define DL1_VAL_ON 		1'b1
`define DL1_VAL_OFF 	1'b0
`define DL1_READ 		1'b0
`define DL1_WRT			1'b1
`define DL1_CASH_ON 	1'b1
`define DL1_CASH_OFF 	1'b0
`define DL1_SIZE_BYTE	3'b000
`define DL1_SIZE_HALF	3'b001
`define DL1_SIZE_WORD	3'b010

`define LW_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_READ,DL1_SIZE_WORD}
`define LH_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_READ,DL1_SIZE_HALF}
`define LB_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_READ,DL1_SIZE_BYTE}
`define SW_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_WRT,DL1_SIZE_WORD}
`define SH_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_WRT,DL1_SIZE_HALF}
`define SB_L1D 			{DL1_VAL_ON,1'b0,1'bx,DL1_WRT,DL1_SIZE_BYTE}
`define NOT_REQ			{DL1_VAL_OFF,6'bx}

// the write back sign extebcion controll
`define SX_UH	3'b101
`define SX_H	3'b001
`define SX_UB	3'b100
`define SX_B 3'b000
`define SX_PC	3'b111
`define SX_BP	1'b010
//sx input
`define SX_AUIPC_LUI		3'b000
`define SX_LD_I_R_JALR 	3'b001
`define SX_SB 					3'b010
`define SX_UJ_JAL				3'b011
`define SX_ST						3'b010