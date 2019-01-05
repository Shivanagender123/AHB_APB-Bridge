class ahb_driver extends uvm_driver #(ahb_xtn);

`uvm_component_utils(ahb_driver)
virtual ahb_if.DR_MP vif;
ahb_agent_config m_cfg;
extern function new(string name="ahb_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
 extern task send_to_dut(ahb_xtn xtn);
 extern task run_phase(uvm_phase phase);

endclass
//////////////////////////////////////CONSTUCTOR/////////////////////////////////////////////////
function ahb_driver::new(string name="ahb_driver",uvm_component parent);
  super.new(name,parent);
endfunction

///////////////////////////BUILD_PHASE////////////////////////////////////////////////////
function void ahb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(ahb_agent_config)::get(this,"","ahb_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
   super.build();
        super.build_phase(phase);
        endfunction


////// ///////////////////////CONNECT_PHASE////////////////////////////////////////////////////////
function void ahb_driver::connect_phase(uvm_phase phase);
 vif=m_cfg.vif;
endfunction

//////////////////////////////RUN PHASE//////////////////////////////////////////////
task ahb_driver::run_phase (uvm_phase phase);
	@(vif.dr_cb)
	vif.dr_cb.hresetn <= 1'b0;
	@(vif.dr_cb)
	vif.dr_cb.hresetn <= 1'b1;

	forever 
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end

endtask

///////////////////////////////////SENT TO DUT//////////////////////////////////////

task ahb_driver::send_to_dut(ahb_xtn xtn);
int s;
			vif.dr_cb.hburst<=xtn.hburst;
			vif.dr_cb.hsize<=xtn.hsize;
			@(vif.dr_cb)
			vif.dr_cb.haddr    <= xtn.haddr[0];
			vif.dr_cb.hwrite   <= xtn.hwrite;
			vif.dr_cb.htrans   <= 2'b10;
			vif.dr_cb.hreadyin <= 1'b1;

			@(vif.dr_cb)
						
			for(int i = 1; i< (xtn.haddr.size ); i= i+1 )
			begin

				wait(vif.dr_cb.hreadyout)
				@(vif.dr_cb)
				vif.dr_cb.haddr    <= xtn.haddr[i];
				vif.dr_cb.hwdata   <= xtn.hwdata[i-1];
				vif.dr_cb.htrans   <= 2'b11;
				vif.dr_cb.hreadyin <= 1'b1;
			end

			@(vif.dr_cb)
			wait(vif.dr_cb.hreadyout)
			vif.dr_cb.hreadyin <= 1'b1;
			vif.dr_cb.htrans   <= 2'b00;
			s = xtn.hwdata.size();
			vif.dr_cb.hwdata   <= xtn.hwdata[s-1];
endtask
