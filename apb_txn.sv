import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_txn extends uvm_sequence_item;
  `uvm_object_utils(apb_txn)
  
  rand bit [7:0]PADDR;
  rand bit PWRITE;
  rand bit [7:0] PWDATA;
  bit [7:0] PRDATA;
  bit PSLVERR;
  
  constraint addr{
    PADDR inside {[0:7]};
  }
  function new(string name="apb_txn");   //constructor
    super.new(name);
  endfunction
 
  function string convert2string();
    return $sformatf(
      "PWRITE=%0b PADDR=0x%0h PWDATA=0x%0h PRDATA=0x%0h PSLVERR=%0b",PWRITE,PADDR, PWDATA,PRDATA,PSLVERR
    );

  endfunction
endclass 
