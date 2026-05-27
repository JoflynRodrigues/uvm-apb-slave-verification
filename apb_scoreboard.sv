import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  int total_txns;
  int pass_count;
  int fail_count;

  // reference model memory
  bit [7:0] ref_mem [0:7];

  // analysis implementation port
  uvm_analysis_imp #(apb_txn, apb_scoreboard) sb_imp;

  function new(string name="apb_scoreboard",uvm_component parent);   //constructor
    super.new(name,parent);
    sb_imp = new("sb_imp",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(ref_mem[i])             // initialize reference memory
      ref_mem[i] = 8'h00;
  endfunction

  // receives transactions from monitor
  function void write(apb_txn txn);
    total_txns++;
    //invalid address
    if(txn.PADDR > 7) begin
      if(txn.PSLVERR) begin
        `uvm_info(get_type_name(),"Correct PSLVERR detected",UVM_LOW)
        pass_count++;
      end

      else begin
        `uvm_error(get_type_name(),"Expected PSLVERR but not asserted")
        fail_count++;
      end
      return;
    end
    
    // write
    if(txn.PWRITE) begin
      ref_mem[txn.PADDR] = txn.PWDATA;
      `uvm_info(get_type_name(),$sformatf("WRITE ADDR=%0d DATA=%0h",txn.PADDR,txn.PWDATA), UVM_LOW)
      pass_count++;
    end
    
    // read
    else begin
      if(txn.PRDATA == ref_mem[txn.PADDR]) begin
        `uvm_info(get_type_name(), $sformatf("READ PASS ADDR=%0d DATA=%0h",txn.PADDR,txn.PRDATA),UVM_LOW)
        pass_count++;
      end

      else begin
        `uvm_error(get_type_name(),$sformatf("READ FAIL ADDR=%0d EXPECTED=%0h ACTUAL=%0h",txn.PADDR,ref_mem[txn.PADDR],txn.PRDATA))
        fail_count++;
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf( "\nTOTAL=%0d PASS=%0d FAIL=%0d",total_txns, pass_count,fail_count),UVM_NONE)
  endfunction

endclass
