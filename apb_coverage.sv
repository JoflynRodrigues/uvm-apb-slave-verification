import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_coverage extends uvm_subscriber #(apb_txn);
  `uvm_component_utils(apb_coverage)
  apb_txn txn;
  covergroup apb_cg;
    option.per_instance = 1;
    // READ / WRITE coverage
    WRITE_CP : coverpoint txn.PWRITE {
      bins READ  = {0};
      bins WRITE = {1};
    }

    // Address coverage
    ADDR_CP : coverpoint txn.PADDR {
      bins LOW_ADDR  = {[0:3]};
      bins HIGH_ADDR = {[4:7]};
      bins ALL_ADDR[] = {[0:7]};
    }

    // Data coverage
    DATA_CP : coverpoint txn.PWDATA {
      bins ZERO     = {8'h00};
      bins LOW      = {[8'h01:8'h3F]};
      bins MID      = {[8'h40:8'h7F]};
      bins HIGH     = {[8'h80:8'hFF]};
    }
    // Error coverage
    ERR_CP : coverpoint txn.PSLVERR {
      bins NO_ERROR = {0};
      bins ERROR    = {1};
    }
    // Cross coverage
    RW_X_ADDR : cross WRITE_CP, ADDR_CP;
    ADDR_TRANS : coverpoint txn.PADDR {
  		bins incr[] = (0=>1=>2=>3);
	}
  endgroup

  function new(string name="apb_coverage",uvm_component parent);  //constructor
    super.new(name,parent);
    apb_cg = new();
  endfunction

  //sample transactions
  function void write(apb_txn t);
    txn = t;
    apb_cg.sample();
    `uvm_info(get_type_name(),
      $sformatf("Coverage Sampled: ADDR=%0d WRITE=%0b DATA=%0h",txn.PADDR,txn.PWRITE,txn.PWDATA),UVM_LOW)
  endfunction
  
  // REPORT COVERAGE
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("\nAPB Functional Coverage = %0.2f%%",apb_cg.get_coverage()),UVM_NONE)
  endfunction

endclass
