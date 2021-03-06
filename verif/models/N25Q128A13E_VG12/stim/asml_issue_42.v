//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//
//  N25Q128A13E
//
//  Verilog Behavioral Model
//  Version 1.2
//
//  Copyright (c) 2013 Micron Inc.
//
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-



`timescale 1ns / 1ns

//`include "top/StimGen_interface.h"
// the port list of current module is contained in "StimGen_interface.h" file 
module Stimuli2 (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
//module Stimuli (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
    `include "include/DevParam.h"
   
   
    output S;
    output [`VoltageRange] Vcc;

    inout DQ0, DQ1; 

    inout Vpp_W_DQ2;

    `ifdef HOLD_pin
        inout HOLD_DQ3; 
    `endif
    

    `ifdef RESET_pin
       inout RESET_DQ3;
    `endif

      defparam Testbench.DUT2.memory_file = "mem_Q128_bottom.vmf";

    reg [addrDim-1:0] A0='h0, A1, A2='h08;


    initial begin
        
            A1='hFFFFFA;

        //tasks2.init;
        tasks2.asml_init;
//        tasks21.asml_init;
//        tasks22.asml_init;
//        tasks23.asml_init;
         // read flag status register 
        $display("\n--- Read flag status register"); 
        tasks2.send_command_asml('h70);
        tasks2.read(1); 
        tasks2.close_comm;
        #100;

        tasks2.send_power_loss_rescue_sequence_part1_quad(); //let's give one less clock cycle
        tasks2.close_comm;
        #10;
        tasks2.send_power_loss_rescue_sequence_part1_dual();
        tasks2.close_comm;
        #50;
        tasks2.send_power_loss_rescue_sequence_part1_extended();
        tasks2.close_comm;
        #50;
        tasks2.send_power_loss_rescue_sequence_part2();
        tasks2.close_comm;
        #2500;

         // read flag status register 
        $display("\n--- Read flag status register"); 
        tasks2.send_command_asml('h70);
        tasks2.read(1); 
        tasks2.close_comm;
        #2000;

         // read flag status register 
        $display("\n--- Read flag status register"); 
        tasks2.send_command_asml('h70);
        tasks2.read(1); 
        tasks2.close_comm;
        #100;


    end


endmodule    

