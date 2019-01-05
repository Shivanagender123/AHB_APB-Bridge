class apb_seq extends uvm_sequence #(apb_xtn);

`uvm_object_utils(apb_seq); 



extern function new(string name="apb_seq");
endclass

function apb_seq::new(string name="apb_Seq");
super.new(name);
endfunction

class apb_seq1 extends apb_seq;

`uvm_object_utils(apb_seq1)
env_config cfg;
extern function new(string name="apb_seq1");
extern task body;

endclass

function apb_seq1::new(string name="apb_seq1");
super.new(name);
endfunction

task apb_seq1::body;
req=apb_xtn::type_id::create("APB_XTN");
start_item(req);
assert(req.randomize );
finish_item(req);

endtask
