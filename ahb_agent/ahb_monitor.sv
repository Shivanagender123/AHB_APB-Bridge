class ahb_monitor extends uvm_monitor;

`uvm_component_utils(ahb_monitor)

uvm_analysis_port #(ahb_xtn) monitor_port;
 ahb_agent_config m_cfg;
   ahb_xtn xtn;
   int len; 
env_config cfg;
virtual ahb_if.MON_MP vif;

extern function new(string name = "ahb_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern function void report_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task collect_data();
extern task run_phase(uvm_phase phase);
 
endclass
///////////////////////////////////////////////NEW_CONSTRUCTOR///////////////////////////////////////////////////////////////////////////
 function ahb_monitor::new(string name = "ahb_monitor",uvm_component parent);
     super.new(name,parent);
		monitor_port=new("monitor_port",this);
endfunction

/////////////////////////////////////////////BUILD_PHASE//////////////////////////////////////////////////////////////////////////////////
function void ahb_monitor::build_phase(uvm_phase phase);
                if(!uvm_config_db #(ahb_agent_config)::get(this,"","ahb_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
 super.build();
if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
	`uvm_fatal("CONFIG","cannot get() cfg from uvm_config_db. Have you set() it?") 
        endfunction

//////////////////////////////////CONNECT_PHASE////////////////////////////////////////////////////////////
function void ahb_monitor::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction         
////////////////////////////////////RUN PHASE////////////////////////////////////////////////////////////
task ahb_monitor::run_phase(uvm_phase phase);
	forever collect_data;
endtask

///////////////////////////////////////COLLECT DATA/////////////////////////////////////////////////

task ahb_monitor::collect_data;
	if(cfg.hburs==0||cfg.hburs==1)
		len=1;
	if(cfg.hburs==2||cfg.hburs==3)
		len=4;
	if(cfg.hburs==4||cfg.hburs==5)
		len=8;
	if(cfg.hburs==6||cfg.hburs==7)
		len=16;
	xtn=ahb_xtn::type_id::create("WR_MONITOR");
	xtn.haddr=new[len];
	xtn.hwdata=new[len];
	xtn.hrdata=new[len];
	wait(vif.mon_cb.hreadyout)
	wait(vif.mon_cb.htrans==2)
	xtn.haddr[0]  = vif.mon_cb.haddr;
	xtn.htrans    = vif.mon_cb.htrans;
	xtn.hwrite    = vif.mon_cb.hwrite;
	xtn.hreadyin  = vif.mon_cb.hreadyin;
	xtn.hsize     = vif.mon_cb.hsize;
	for(int i=0;i<len-1;i++)
	begin
	@(vif.mon_cb);
	wait(vif.mon_cb.hreadyout)
	wait(vif.mon_cb.htrans == 2'b11);
	xtn.haddr[i+1]   =  vif.mon_cb.haddr;
	xtn.hwdata[i]    =  vif.mon_cb.hwdata;
	xtn.htrans       =  vif.mon_cb.htrans;
	xtn.hreadyin     =  vif.mon_cb.hreadyin;
	xtn.hrdata[i]	 =  vif.mon_cb.hrdata;	
	end
	@(vif.mon_cb);
	wait(vif.mon_cb.hreadyout)
	wait(vif.mon_cb.htrans == 2'b00);
	xtn.hwdata[len-1]=  vif.mon_cb.hwdata;
	xtn.htrans       =  vif.mon_cb.htrans;
	xtn.hreadyin     =  vif.mon_cb.hreadyin;
	xtn.hrdata[len-1]=  vif.mon_cb.hrdata;	
	
endtask
