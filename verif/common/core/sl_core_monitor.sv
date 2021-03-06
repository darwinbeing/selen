// ----------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------
// FILE NAME      : sl_core_monitor.sv
// PROJECT        : Selen
// AUTHOR         : Grigoriy Zhikharev
// AUTHOR'S EMAIL : gregory.zhiharev@gmail.com
// ----------------------------------------------------------------------------
// DESCRIPTION    :
// ----------------------------------------------------------------------------

`ifndef INC_SL_CORE_MONITOR
`define INC_SL_CORE_MONITOR

class sl_core_monitor extends uvm_monitor;

  virtual core_if vif;
  sl_core_agent_cfg cfg;

  uvm_analysis_port#(sl_core_bus_item) item_collected_port;
  uvm_analysis_port#(sl_core_bus_item) item_request_port;

  `uvm_component_utils(sl_core_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    item_request_port   = new("item_request_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual core_if)::get(this, "" ,"vif", vif))
    else `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(),".vif"});
    assert(uvm_config_db#(sl_core_agent_cfg)::get(this, "" ,"cfg", cfg))
    else `uvm_fatal("NOCFG", {"CFG must be set for: ", get_full_name(),".cfg"});
  endfunction

  task run_phase(uvm_phase phase);
    monitor_transaction();
  endtask

  task monitor_transaction();
    forever begin
      if (!vif.rst) begin
        if(vif.mon.req_val) begin
          sl_core_bus_item item;
          item = sl_core_bus_item::type_id::create("item");
          item.cop  = core_cop_t'(vif.mon.req_cop);
          item.size = vif.mon.req_size;
          item.addr = vif.mon.req_addr;
          if(item.is_wr()) begin
            item.data = vif.mon.req_wdata;
          end
          bus_check(item);
          item_request_port.write(item);
          do @(vif.mon);
          while(!vif.mon.req_ack);
          if(!item.is_wr())item.data = vif.mon.req_ack_data;
          item_collected_port.write(item);
          `uvm_info($sformatf("MON %0s",cfg.port.name()), item.sprint(uvm_default_line_printer), UVM_MEDIUM)
        end
        else begin
          @(vif.mon);
        end
      end
      else begin
        @(vif.mon);
      end
    end
  endtask

  function void bus_check(sl_core_bus_item item);
    if(cfg.port == INSTR) begin
      assert(item.cop == RD)
      else `uvm_fatal("WRONG COP", "For INSTR port cop expected to be only RD")
      assert(item.size == 4)
      else `uvm_error("WRONG SIZE", "For INSTR port size expected to be only 4 bytes")
    end
  endfunction

endclass

`endif