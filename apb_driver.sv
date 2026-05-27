import uvm_pkg::*;
`include "uvm_macros.svh"


class apb_driver extends uvm_driver #(apb_txn);
  `uvm_component_utils(apb_driver)
  virtual apb_if vif;
  
  function new(string name="apb_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_fatal("NO INFO","virtual interface is not received");
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_txn txn;
    forever begin
      seq_item_port.get_next_item(txn);
      @(posedge vif.PCLK);
      
      //RESET
      if(!vif.PRESETn)begin
        vif.PSELx<=0;
        vif.PENABLE<=0;
        vif.PADDR<=0;
        vif.PWRITE<=0;
        vif.PWDATA<=0;
        seq_item_port.item_done();
        continue;
      end
        
       @(posedge vif.PCLK);

      vif.PSELx   <= 1;
      vif.PENABLE <= 0;
      vif.PADDR   <= txn.PADDR;
      vif.PWRITE  <= txn.PWRITE;
      vif.PWDATA  <= txn.PWDATA;
        
       @(posedge vif.PCLK);

      vif.PENABLE <= 1;
      do begin
      	@(posedge vif.PCLK);
      end
      while(!vif.PREADY);

      // READ
      if(!txn.PWRITE)
        txn.PRDATA = vif.PRDATA;
        
       @(posedge vif.PCLK);

      vif.PSELx   <= 0;
      vif.PENABLE <= 0;
     

      seq_item_port.item_done();
      
    end 
  endtask
endclass
