class tb extends uvm_env;
`uvm_component_utils(tb);
ahb_agent_top ahb_top;
apb_agent_top apb_top;
env_config m_cfg;
virtual_sequencer vseqrh;
scoreboard sb;

extern function new(string name="tb",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern function void start_of_simulation_phase(uvm_phase phase);

endclass
//////////////////////////////////NEW_PHASE//////////////////////////////////////////////////////////////////

function tb::new(string name="tb",uvm_component parent);
  super.new(name,parent);
endfunction

//////////////////////////////////BUILD_PHASE//////////////////////////////////////////////////////////
function void tb::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 

if(m_cfg.has_ahb_agent)
      
     ahb_top=ahb_agent_top::type_id::create("ahb_top",this);

if(m_cfg.has_apb_agent)
      
     apb_top=apb_agent_top::type_id::create("apb_top",this);



if(m_cfg.has_virtual_sequencer)
vseqrh=virtual_sequencer::type_id::create("vseqrh",this);



if(m_cfg.has_scoreboard)
sb=scoreboard::type_id::create("sb",this);
        endfunction


/////////////////////////////connect_phase/////////////////////////////////////




function void tb::connect_phase(uvm_phase phase);
          if(m_cfg.has_virtual_sequencer) begin
               if(m_cfg.has_ahb_agent)
			begin
           		
                          	for(int i=0; i<m_cfg.no_of_ahb_agents;i++)

		                       vseqrh.ahb_seqrh[i] = ahb_top.agent[i].m_sequencer;
				for(int i=0; i<m_cfg.no_of_apb_agents;i++)

		                       vseqrh.apb_seqrh[i] = apb_top.agent[i].m_sequencer;
			end
                                            end


              /*    if(m_cfg.has_scoreboard) begin
    		 if(m_cfg.has_ahb_agent)
			begin
                                 	for(int i=0; i<m_cfg.no_of_ahb_agents;i++)

		                     ahb_top.agent[i].monh.monitor_port.connect(sb.fifo_mh[i].analysis_export);
				for(int i=0; i<m_cfg.no_of_apb_agents;i++)

		                     apb_top.agent[i].monh.monitor_port.connect(sb.fifo_sh[i].analysis_export);
			end
                      			end
                                 
*/

					      
endfunction

///////////////////////////START_OF_SIMULATION_PHASE//////////////////////////////////////////////////////////

function void tb::start_of_simulation_phase(uvm_phase phase);
       uvm_top.print_topology;
endfunction

