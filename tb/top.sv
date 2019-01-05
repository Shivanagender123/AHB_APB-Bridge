//////////////////////////////////////////////////////////
module top;
       import test_pkg::*;
   	import uvm_pkg::*;
//	import master_defines.v::*;


/////////////////////////CLOCK_GENERATION////////////////////////////////
			bit clock;
                   bit clock1;    
  always
     #10 clock=~clock;
        

ahb_xtn xtn;
//////////////////////////////////////INSTANTIATE THE TOP OF THE UART//////////////////////////////////////////////////////////////////////////

rtl_top DUV(    .Hclk(clock),
		 .Hresetn(in0.hresetn),
                  .Htrans(in0.htrans),
		   .Hsize(in0.hsize), 
		    .Hreadyin(in0.hreadyin),
		     .Hwdata(in0.hwdata), 
		      .Haddr(in0.haddr),
		       .Hwrite(in0.hwrite),
                   	.Prdata(in1.prdata),
		   	 .Hrdata(in0.hrdata),
		    //	  .Hresp(in0.hresp),
		   	   .Hreadyout(in0.hreadyout),
		  	    .Pwrite(in1.pwrite),
		 	     .Penable(in1.penable), 
		              .Paddr(in1.paddr),
		               .Pwdata(in1.pwdata),
				.Pselx(in1.pselx)
            );	



///////////////////CLOCK_FOR_INTERFACE/////////////////////////////////////////////

     ahb_if in0(clock);
     apb_if in1(clock);



///////////////////////////////////////////RUN_TEST//////////////////////////////////////////////////////////////////////////////////////////
initial
begin
	uvm_config_db #(virtual ahb_if)::set(null,"*","vif_0",in0);
	uvm_config_db #(virtual apb_if)::set(null,"*","vif[0]",in1);
	run_test();
     end
  
endmodule

