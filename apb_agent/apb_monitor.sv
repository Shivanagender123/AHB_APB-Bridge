class apb_monitor extends uvm_monitor;

`uvm_component_utils(apb_monitor)

uvm_analysis_port #(apb_xtn) monitor_port;
 apb_agent_config m_cfg;
   apb_xtn xtn;
   int len;
env_config cfg; 

virtual apb_if.MON_MP vif;

extern function new(string name = "apb_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern function void report_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task collect_data();
extern task run_phase(uvm_phase phase);
 
endclass
///////////////////////////////////////////////NEW_CONSTRUCTOR///////////////////////////////////////////////////////////////////////////

function apb_monitor:: new(string name = "apb_monitor",uvm_component parent);
     super.new(name,parent);
		monitor_port=new("monitor_port",this);
endfunction

/////////////////////////////////////////////BUILD_PHASE//////////////////////////////////////////////////////////////////////////////////
function void apb_monitor::build_phase(uvm_phase phase);
                if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
	`uvm_fatal("CONFIG","cannot get() cfg from uvm_config_db. Have you set() it?") 
 super.build();
        endfunction

//////////////////////////////////CONNECT_PHASE////////////////////////////////////////////////////////////
function void apb_monitor::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction         
////////////////////////////////////RUN PHASE////////////////////////////////////////////////////////////

task apb_monitor::run_phase(uvm_phase phase);
	forever collect_data;
endtask

///////////////////////////////////////SEND TO DUT//////////////////////////////////////////////////

task apb_monitor::collect_data();
		
	if(cfg.hburs==0||cfg.hburs==1)
		len=1;
	if(cfg.hburs==2||cfg.hburs==3)
		len=4;
	if(cfg.hburs==4||cfg.hburs==5)
		len=8;
	if(cfg.hburs==6||cfg.hburs==7)
		len=16;
	xtn=apb_xtn::type_id::create("RD_MONITOR");
	xtn.paddr=new[len];
	xtn.pwdata=new[len];
	xtn.prdata=new[len];

	for(int i=0;i<len;i++)
	begin
	@(posedge vif.mon_cb.penable);
	wait(vif.mon_cb.pselx == 1'b1)
	xtn.pwrite=vif.mon_cb.pwrite;
	xtn.paddr[i]=vif.mon_cb.paddr;
	@(vif.mon_cb);
	@(vif.mon_cb);
	xtn.pwdata[i]=vif.mon_cb.pwdata;
	xtn.prdata[i]=vif.mon_cb.prdata;
	end
	xtn.print;
endtask
