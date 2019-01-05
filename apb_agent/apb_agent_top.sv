class apb_agent_top extends uvm_env;
 
`uvm_component_utils(apb_agent_top)

	apb_agent agent[];
	env_config m_cfg;


extern function new(string name="apb_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass


function apb_agent_top::new(string name="apb_agent_top",uvm_component parent);
super.new(name,parent);
endfunction



function  void apb_agent_top::build_phase(uvm_phase phase);
if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 

super.build_phase(phase);
  if(m_cfg.has_apb_agent)
     agent=new[m_cfg.no_of_apb_agents];
      foreach(agent[i])
	begin
           uvm_config_db #(apb_agent_config)::set(this,$sformatf("agent[%0d]*",i), "apb_agent_config", m_cfg.m_apb_agent_cfg[i]);
 agent[i]=apb_agent::type_id::create($sformatf("agent[%0d]",i),this);
end
        endfunction

task apb_agent_top::run_phase(uvm_phase phase);
            uvm_top.print_topology;
endtask



