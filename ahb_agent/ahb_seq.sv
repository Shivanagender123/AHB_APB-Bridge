class ahb_seq extends uvm_sequence #(ahb_xtn);

`uvm_object_utils(ahb_seq); 



extern function new(string name="ahb_seq");
endclass

function ahb_seq::new(string name="ahb_Seq");
super.new(name);
endfunction

class ahb_seq1 extends ahb_seq;

`uvm_object_utils(ahb_seq1)
env_config cfg;
extern function new(string name="ahb_seq1");
extern task body;

endclass

function ahb_seq1::new(string name="ahb_seq1");
super.new(name);
if(!uvm_config_db #(env_config)::get(null,get_full_name,"e",cfg))
	`uvm_fatal("SEQUENCE","cannot get config file")
$display("%p",cfg);
endfunction

task ahb_seq1::body;
req=ahb_xtn::type_id::create("AHB_XTN");
start_item(req);
assert(req.randomize with {hburst==cfg.hburs;hsize==cfg.hsiz;});
req.print;
finish_item(req);

endtask
