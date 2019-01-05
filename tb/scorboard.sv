class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

uvm_tlm_analysis_fifo #(ahb_xtn)fifo_ahb[];
uvm_tlm_analysis_fifo #(apb_xtn)fifo_apb[];
ahb_xtn ahb_data;
apb_xtn apb_data;
env_config m_cfg;
extern function new(string name="scoreboard",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);

endclass

function scoreboard::new(string name="scoreboard",uvm_component parent);
 super.new(name,parent);

endfunction


function void scoreboard::build_phase(uvm_phase phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
				fifo_ahb=new[m_cfg.no_of_ahb_agents];
				fifo_apb=new[m_cfg.no_of_apb_agents];
					
	foreach(fifo_ahb[i])
        	    begin
       		 fifo_ahb[i]=new($sformatf("fifo_ahb[%0d]",i),this);  end 
	foreach(fifo_apb[i])
        	    begin
        	fifo_apb[i]=new($sformatf("fifo_apb[%0d]",i),this);  end 
          
endfunction



