import uvm_pkg::*;
`include "uvm_macros.svh"


class apb_sequence extends uvm_sequence #(apb_txn);
  `uvm_object_utils(apb_sequence)
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  task body();
    apb_txn txn;
    `uvm_info(get_type_name(),"starting apb sequence",UVM_LOW)
    repeat(100)begin
      txn=apb_txn::type_id::create("txn");//instance creation
      start_item(txn);
      assert(txn.randomize());
      finish_item(txn);

      `uvm_info(get_type_name(),$sformatf("generated txn %s",txn.convert2string()),UVM_LOW)
    end
    endtask
endclass
