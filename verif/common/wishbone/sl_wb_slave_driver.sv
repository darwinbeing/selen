// ----------------------------------------------------------------------------
// FILE NAME      : sl_wb_slave_driver.sv
// PROJECT        : Selen
// AUTHOR         : Maksim Kobzar
// AUTHOR'S EMAIL :
// ----------------------------------------------------------------------------
// DESCRIPTION    :
// ----------------------------------------------------------------------------
`ifndef INC_SL_WB_SLAVE_DRIVER
`define INC_SL_WB_SLAVE_DRIVER

class wb_slave_driver extends uvm_driver#(wb_bus_item);

	`uvm_component_utils(wb_slave_driver)

  typedef virtual wb_if vif_t;
  vif_t vif;

  bit           m_random;
  int           m_delay;
  wb_agent_cfg  cfg;
  wb_bus_item   ack_q[$];

  function new (string name = "wb_slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
    assert(uvm_config_db#(virtual wb_if)::get(this, "" ,"vif", vif))
    else `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(),".vif"});
    uvm_config_db#(bit)::get(this, "", "m_random", m_random);
    if(uvm_config_db#(int)::get(this, "", "m_delay", m_delay)) begin
      if(m_random) `uvm_info("KNOBS", $sformatf("Max Delay (%0d) was set for: %0s", m_delay, get_full_name()), UVM_MEDIUM)
      else`uvm_info("KNOBS", $sformatf("Delay (%0d) was set for: %0s", m_delay, get_full_name()), UVM_MEDIUM)
    end
		if(!uvm_config_db#(wb_agent_cfg)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG", {"Configuration must be set for ", get_full_name(), "cfg"})
  endfunction

  function int rand_delay();
    int delay;
    if(cfg.drv_fixed_delay) begin
      delay = cfg.drv_delay_max;
    end
    else begin
      std::randomize(delay) with {
        delay dist {0 :/ 90, [1:cfg.drv_delay_max] :/ 10};
      };
    end
    return(delay);
  endfunction

  task run_phase(uvm_phase phase);
    fork
      process_req();
      process_ack();
    join
  endtask

  task process_req();
    forever begin
      @(vif.drv_s);
      if(!vif.rst) begin
        wb_bus_item ret_item;
        if(vif.mon.cyc && vif.mon.stb && !vif.mon.stall) begin
          seq_item_port.try_next_item(req);
          if(req != null) begin
            assert($cast(ret_item, req.clone()));
            ret_item.set_id_info(req);
            ret_item.accept_tr();
            void'(begin_tr(ret_item, "wb_slave_driver"));
            ack_q.push_back(ret_item);
            seq_item_port.item_done();
            end_tr(ret_item);
            seq_item_port.put_response(ret_item);
          end
        end
      end
    end
  endtask

  task process_ack();
    forever begin
      @(vif.drv_s);
      if(!vif.rst) begin
        wb_bus_item ack_item;
        if(ack_q.size() > 0) begin
          ack_item = ack_q.pop_front();
          ack_item.accept_tr();
          if(ack_item.stall) begin
            stall_bus(ack_item);
          end
          else begin
            repeat(rand_delay()) begin
              clear_interface();
              @(vif.drv_s);
              if(vif.rst) break;
            end
          end
          void'(begin_tr(ack_item, "wb_slave_driver"));
          drive_item(ack_item);
        end
        else
          clear_interface();
      end
      else
        reset_interface();
    end
  endtask

  // --------------------------------------------
  // TASK: reset_interface
  // --------------------------------------------
  task reset_interface();
    vif.drv_s.ack   <= 0;
    vif.drv_s.dat_i <= 0;
    vif.drv_s.err   <= 0;
    vif.drv_s.rty   <= 0;
  endtask

  // --------------------------------------------
  // TASK: clear_interface
  // --------------------------------------------
  task clear_interface();
    bit [31:0] data;
    std::randomize(data);
    vif.drv_s.ack   <= 0;
    vif.drv_s.dat_i <= data;
    vif.drv_s.stall <= 0;
    vif.drv_s.err   <= 0;
    vif.drv_s.rty   <= 0;
  endtask

  // --------------------------------------------
  // TASK: drive_item
  // --------------------------------------------
  task drive_item(wb_bus_item item);
    vif.drv_s.dat_i <= item.data.pop_front();
    vif.drv_s.err   <= item.err;
    vif.drv_s.stall <= 1'b0;
    vif.drv_s.rty   <= item.rty;
    vif.drv_s.ack   <= !item.err;
  endtask

  // --------------------------------------------
  // TASK: stall_bus
  // --------------------------------------------
  task stall_bus(wb_bus_item item);
    repeat(item.stall_clk_num) begin
      vif.drv_s.err   <= 1'b0;
      vif.drv_s.stall <= 1'b1;
      vif.drv_s.rty   <= 1'b0;
      vif.drv_s.ack   <= 1'b0;
      @(vif.drv_s);
    end
  endtask

endclass

`endif
