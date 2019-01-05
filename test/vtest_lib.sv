class base_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(base_test)

  
         // Handles 
    		 tb envh;
        	 env_config m_tb_cfg;
        	ahb_agent_config m_ahb_cfg[];
        	apb_agent_config m_apb_cfg[];
		           
       		  int has_apb_agent = 1;
       		  int has_ahb_agent = 1;
	         int no_of_ahb_agents=1;
	         int no_of_apb_agents=1;
//////////////////////////////////  Standard UVM Methods: /////////////////////////////////////////////////////////////////

	extern function new(string name = "base_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_brid();
        
        endclass
        
////////////////////////////////////// constructor new method  //////////////////////////////////////////////////////

   	function base_test::new(string name = "base_test", uvm_component parent);
		super.new(name,parent);
	 endfunction
//----------------- function config_ram()  -------------------//

	function void base_test::config_brid();
 	   if (has_ahb_agent) begin
            m_ahb_cfg=new[no_of_ahb_agents];
		foreach(m_ahb_cfg[i])
		begin
                      m_ahb_cfg[i]=ahb_agent_config::type_id::create($sformatf("m_ahb_cfg[%0d]",i));


         	 if(!uvm_config_db #(virtual ahb_if)::get(this,"",$sformatf("vif_%0d",i),m_ahb_cfg[i].vif))
		`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
             m_ahb_cfg[i].is_active = UVM_ACTIVE;

	                m_tb_cfg.m_ahb_agent_cfg[i] = m_ahb_cfg[i];
                
                end 
end
	 if (has_apb_agent) begin
            m_apb_cfg=new[no_of_apb_agents];
		foreach(m_apb_cfg[i])
		begin
                      m_apb_cfg[i]=apb_agent_config::type_id::create($sformatf("m_apb_cfg[%0d]",i));


         	 if(!uvm_config_db #(virtual apb_if)::get(this,"",$sformatf("vif[%0d]",i),m_apb_cfg[i].vif))
		`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
             m_apb_cfg[i].is_active = UVM_ACTIVE;

	                m_tb_cfg.m_apb_agent_cfg[i] = m_apb_cfg[i];
                
                end 

             end
//----------------------------------------------------------------------------------------------------------//
		
			                  m_tb_cfg.has_ahb_agent = has_ahb_agent;
					  m_tb_cfg.has_apb_agent = has_apb_agent;
                     	endfunction

	function void base_test::build_phase(uvm_phase phase);
                // create the config object using uvm_config_db 
	        m_tb_cfg=env_config::type_id::create("m_tb_cfg");
              if(has_ahb_agent)
     m_tb_cfg.m_ahb_agent_cfg=new[no_of_ahb_agents];
  if(has_apb_agent)
     m_tb_cfg.m_apb_agent_cfg=new[no_of_apb_agents];
                     // Call function 
                config_brid(); 
		// call super.build()
     		super.build();
		// create the instance for ram_envh handle
		envh=tb::type_id::create("envh", this);
			endfunction

class test1 extends base_test;

   // Factory Registration
	`uvm_component_utils(test1)
	vseq1 v1;
	extern function new(string name = "test1",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
        extern task run_phase (uvm_phase phase);
        endclass
        
////////////////////////////////////// constructor new method  //////////////////////////////////////////////////////

   	function test1::new(string name = "test1", uvm_component parent);
		super.new(name,parent);
	 endfunction

	function void test1::build_phase(uvm_phase phase);
	super.build_phase(phase);
	m_tb_cfg.hburs=3;
	m_tb_cfg.hsiz=0;
	uvm_config_db #(env_config)::set(this,"*","env_config",m_tb_cfg);
	endfunction

	task test1::run_phase (uvm_phase phase);
		phase.raise_objection(this);
		v1=vseq1::type_id::create("V_SEQ");
		v1.start(envh.vseqrh);
		#100;
		phase.drop_objection(this);
	endtask




