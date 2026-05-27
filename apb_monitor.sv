import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  virtual apb_if vif;
  uvm_analysis_port #(apb_txn)mon_ap;
  function new(string name="apb_monitor",uvm_component parent);
    super.new(name ,parent);
    mon_ap=new("mon_ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal(get_type_name(),"No interface")
  endfunction
      
  task run_phase(uvm_phase phase);
    apb_txn txn;
    forever begin
      @(posedge vif.PCLK );
        if (vif.PSELx && vif.PENABLE && vif.PREADY)
      	begin
          txn=apb_txn::type_id::create("txn",this);
          txn.PWDATA=vif.PWDATA;
          txn.PADDR=vif.PADDR;
          txn.PWRITE=vif.PWRITE;
          txn.PRDATA=vif.PRDATA;
          txn.PSLVERR=vif.PSLVERR;


          mon_ap.write(txn);
          `uvm_info(get_type_name(),
          $sformatf("MONITOR: %s", txn.convert2string()),
          UVM_LOW)
      end
    end
  endtask
endclass
