package apb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "apb_txn.sv"
  `include "apb_sequence.sv"
  `include "apb_sequencer.sv"
  `include "apb_driver.sv"
  `include "apb_monitor.sv"
  `include "apb_agent.sv"
  `include "apb_scoreboard.sv"
  `include "apb_coverage.sv"
  `include "apb_env.sv"
  `include "apb_test.sv"
endpackage

interface apb_if (input logic PCLK);
  logic PRESETn;
  logic PSELx;
  logic [7:0] PADDR;
  logic PWRITE;
  logic PENABLE;
  logic[7:0] PWDATA;
  logic [7:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  // PENABLE must follow PSELx
  property psel_to_penable;
    @(posedge PCLK)
    disable iff (!PRESETn)
    (PSELx && !PENABLE) |=> (PSELx && PENABLE);
  endproperty
  assert property (psel_to_penable)
   else $error("APB violation: PENABLE did not follow SETUP phase");
    
  //PENABLE must not be high without PSELx
  property penable_requires_psel;
    @(posedge PCLK)
    disable iff (!PRESETn)
    PENABLE |-> PSELx;
  endproperty
  assert property (penable_requires_psel)
   else $error("APB violation: PENABLE without PSELx");
    
  // Address to be stable during access phase
  property addr_stable;
    @(posedge PCLK)
    (PSELx && !PENABLE) |=> $stable(PADDR);
  endproperty
  assert property (addr_stable)
    else $error("APB violation: PADDR changed during transfer");

  // Control signals stable during ENABLE phase
  property control_stable;
    @(posedge PCLK)
    (PSELx && PENABLE) |-> $stable(PWRITE);
  endproperty
  assert property (control_stable)
    else $error("APB violation: PWRITE changed during ENABLE");

  // READ data valid only when PREADY=1
  property read_data_valid;
    @(posedge PCLK)
    (PSELx && PENABLE && !PWRITE && PREADY)
      |-> !$isunknown(PRDATA);
  endproperty
  assert property (read_data_valid)
   else $error("APB violation: invalid PRDATA during READ");
  
endinterface :apb_if

import apb_pkg::*;

module top;
  import uvm_pkg::*;
  bit PCLK;
  bit PRESETn;
  initial PCLK = 0;
  always #5 PCLK = ~PCLK;

  // interface
  apb_if vif(PCLK);
  assign vif.PRESETn = PRESETn;
  // DUT
  apb_slave dut(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSELx(vif.PSELx),
    .PADDR(vif.PADDR),
    .PWRITE(vif.PWRITE),
    .PENABLE(vif.PENABLE),
    .PWDATA(vif.PWDATA),
    .PRDATA(vif.PRDATA),
    .PREADY(vif.PREADY),
    .PSLVERR(vif.PSLVERR)
  );
  // reset
  initial begin
    PRESETn = 0;
    #20;
    PRESETn = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end

  // config_db
  initial begin
    uvm_config_db#(virtual apb_if)::set(null,"*","vif", vif);
    run_test("apb_test");
  end

endmodule
