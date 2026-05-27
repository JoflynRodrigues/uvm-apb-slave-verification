import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  apb_agent agt;
  apb_scoreboard sb;
  apb_coverage cov;

  function new(string name="apb_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //instance creation
    agt = apb_agent::type_id::create("agt",this);
    sb  = apb_scoreboard::type_id::create("sb",this);
    cov  = apb_coverage::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agt.monh.mon_ap.connect(sb.sb_imp);
    agt.monh.mon_ap.connect(cov.analysis_export);
  endfunction
endclass
