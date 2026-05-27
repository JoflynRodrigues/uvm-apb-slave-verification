import uvm_pkg::*;
`include "uvm_macros.svh"


class apb_sequencer extends uvm_sequencer #(apb_txn);  //connects the driver and sequence

  `uvm_component_utils(apb_sequencer)

  function new(string name="apb_sequencer",    //constructor
               uvm_component parent);

    super.new(name,parent);

  endfunction

endclass
