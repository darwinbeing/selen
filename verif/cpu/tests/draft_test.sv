// ----------------------------------------------------------------------------
// 
// ----------------------------------------------------------------------------
// FILE NAME      : draft_test.sv
// PROJECT        : Selen
// AUTHOR         : 
// AUTHOR'S EMAIL : 
// ----------------------------------------------------------------------------
// DESCRIPTION    : 
// ----------------------------------------------------------------------------

`ifndef INC_DRAFT_TEST
`define INC_DRAFT_TEST

class draft_test extends base_test; 

  cpu_draft_seq draft_seq;

  `test_utils(`if_type)

  function void build_phase();
    $display("[%0t][TEST][BUILD] Phase started", $time);
    repeat(2) begin
      draft_seq = new();
      env.seq_q.push_back(draft_seq);
    end
    env.build_phase();
    $display ("[%0t][TEST][BUILD] Phase ended", $time);   
  endfunction

  task run_phase();
    $display("[%0t][TEST][RUN] Phase started", $time);
    super.run_phase();
    $display ("[%0t][TEST][RUN] Phase ended", $time);    
  endtask

  function void report_phase();
    $display("[%0t][REPORT] Phase started", $time);
    $display ("[%0t][REPORT] Phase ended", $time);   
  endfunction

endclass

`endif