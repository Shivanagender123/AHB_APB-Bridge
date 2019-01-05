class apb_driver extends uvm_driver #(apb_xtn);

`uvm_component_utils(apb_driver)
virtual apb_if.DR_MP vif;
apb_agent_config m_cfg;
env_config cfg;
int len;
extern function new(string name="apb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
 extern task send_to_dut(apb_xtn xtn);
 extern task run_phase(uvm_phase phase);

endclass
//////////////////////////////////////CONSTUCTOR/////////////////////////////////////////////////
function apb_driver::new(string name="apb_driver",uvm_component parent);
  super.new(name,parent);
endfunction

///////////////////////////BUILD_pHASE////////////////////////////////////////////////////
function void apb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
 if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
   super.build();
        super.build_phase(phase);
        endfunction


////// ///////////////////////CONNECT_pHASE////////////////////////////////////////////////////////
function void apb_driver::connect_phase(uvm_phase phase);
 vif=m_cfg.vif;
endfunction

//////////////////////////////RUN pHASE//////////////////////////////////////////////
task apb_driver::run_phase(uvm_phase phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
endtask
//////////////////////////////////SENT TO DUT/////////////////////////////////////////////////
task apb_driver::send_to_dut(apb_xtn xtn);
		
	if(cfg.hburs==0||cfg.hburs==1)
		len=1;
	if(cfg.hburs==2||cfg.hburs==3)
		len=4;
	if(cfg.hburs==4||cfg.hburs==5)
		len=8;
	if(cfg.hburs==6||cfg.hburs==7)
		len=16;
	xtn.prdata=new[len];
	for(int i=0;i<len;i++)
	begin
	@(posedge vif.dr_cb.penable)
	wait(vif.dr_cb.pselx == 1'b1)
	if(vif.dr_cb.pwrite == 1'b0)
	vif.dr_cb.prdata <= $random;	
	end
endtask



