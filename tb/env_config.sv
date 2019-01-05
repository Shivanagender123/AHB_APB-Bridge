class env_config extends uvm_object;

`uvm_object_utils(env_config)

// Whether env analysis components are used:
bit has_functional_coverage = 0;
bit has_wagent_functional_coverage = 0;
bit has_scoreboard = 1;
// Whether the various agents are used:
bit has_ahb_agent = 1;
bit has_apb_agent=1;
// Whether the virtual sequencer is used:
bit has_virtual_sequencer = 1;

int no_of_apb_agents=1;
int no_of_ahb_agents=1;
//dynamicc configh files
                 ahb_agent_config m_ahb_agent_cfg[];
		apb_agent_config m_apb_agent_cfg[];
int hburs;
int hsiz;



// Standard UVM Methods:
extern function new(string name = "env_config");

endclass
//-----------------  constructor new method  -------------------//

function env_config::new(string name = "env_config");
  super.new(name);
endfunction
