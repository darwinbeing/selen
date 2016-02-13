// ----------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------
// FILE NAME      : sl_core_env.sv
// PROJECT        : Selen
// AUTHOR         : Grigoriy Zhikharev
// AUTHOR'S EMAIL : gregory.zhiharev@gmail.com
// ----------------------------------------------------------------------------
// DESCRIPTION    :
// ----------------------------------------------------------------------------
`ifndef INC_SL_CORE_ENV
`define INC_SL_CORE_ENV

class sl_core_env extends uvm_env;

  sl_core_slave_agent core_instr_agent;
  sl_core_slave_agent core_data_agent;

  sl_rv32_layer_sequencer virtual_seqr;

  int model_status;
  core_model::s_model_params model_params;

  `uvm_component_utils(sl_core_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    core_instr_agent = sl_core_slave_agent::type_id::create("core_instr_agent", this);
    core_data_agent  = sl_core_slave_agent::type_id::create("core_data_agent", this);

    virtual_seqr = sl_rv32_layer_sequencer::type_id::create("virtual_seqr", this);

    `uvm_info(get_full_name(), "Creating model...", UVM_LOW)
    model_params.pc_start   = 32'h0000_0123;
    model_params.mem_size   = 1024;
    model_params.verbose    = 1;
    model_params.mem_resize = 0;
    model_params.endiannes  = 1;
    core_model::init(model_params);

  endfunction

  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
    virtual_seqr.core_sequencer = core_instr_agent.sequencer;
  endfunction

endclass

`endif