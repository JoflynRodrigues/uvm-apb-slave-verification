import uvm_pkg::*;
`include "uvm_macros.svh"


class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)     //factory registration
  apb_driver drvh;
  apb_monitor monh;
  apb_sequencer seqrh;
  virtual apb_if vif;
  function new(string name="apb_agent",uvm_component parent);   //constructor
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),"No interface")
      
  //instance creation of driver,monitor and sequencer
    drvh=apb_driver::type_id::create("drvh",this);
    monh=apb_monitor::type_id::create("monh",this);
    seqrh=apb_sequencer::type_id::create("seqrh",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drvh.seq_item_port.connect(seqrh.seq_item_export);
    drvh.vif=vif;
    monh.vif=vif;
  endfunction
endclass
