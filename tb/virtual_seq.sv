
class vbase_seq extends uvm_sequence #(uvm_sequence_item);

	
  // Factory registration
	`uvm_object_utils(vbase_seq) 

///////////handles 
         ahb_sequencer ahb_seqrh[];
	 apb_sequencer apb_seqrh[];
   	         virtual_sequencer vsqrh;
		env_config m_cfg;


  // Declare dynamic array of Handles for all the sequences
	//ahb_seq1  wseq;
         //ahb_seq2 wseq1;
     	extern function new(string name ="vbase_seq");
	extern task body();
	endclass 
//-----------------  constructor new method  -------------------//

 
	function vbase_seq::new(string name ="vbase_seq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//
 


task vbase_seq::body();
// get the config object env_config from database using uvm_config_db 
	  if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

// initialize the dynamic arrays for write & read sequencers 
  ahb_seqrh = new[m_cfg.no_of_ahb_agents];
 apb_seqrh = new[m_cfg.no_of_apb_agents];
  
  
  assert($cast(vsqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end

 foreach(ahb_seqrh[i])
  ahb_seqrh[i] = vsqrh.ahb_seqrh[i];
foreach(apb_seqrh[i])
  apb_seqrh[i] = vsqrh.apb_seqrh[i];
endtask: body

class vseq1 extends vbase_seq;

	`uvm_object_utils(vseq1) 
	ahb_seq1 seq1;
	apb_seq1 seq_1;
     //ahb_seq2 wseq1;
     	extern function new(string name ="vseq1");
	extern task body();
	endclass 
//-----------------  constructor new method  -------------------//

 
	function vseq1::new(string name ="vseq1");
		super.new(name);
	endfunction

	task vseq1::body;
		super.body;
		uvm_config_db #(env_config)::set(null,"ahb_seq1","e",m_cfg);
		seq1=ahb_seq1::type_id::create("AHB_SEQ");
		seq_1=apb_seq1::type_id::create("APB_SEQ");
		fork
		seq1.start(ahb_seqrh[0]);
		seq_1.start(apb_seqrh[0]);
		join
	endtask

