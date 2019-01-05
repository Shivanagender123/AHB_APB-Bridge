interface ahb_if (input bit clock);
logic hclk;
logic hresetn;
logic [1:0]htrans;
logic hwrite;
logic hreadyin;
logic [2:0]hburst;
logic hreadyout;
logic [1:0]hresp;
logic [31:0]hwdata;
logic [31:0]hrdata;
logic [31:0]haddr;
logic [2:0]hsize;

clocking dr_cb@(posedge clock);
	default input #1 output #1;
	output htrans;
	output hwrite;
	output hresetn;
	output hreadyin;
	output hburst;
	input hreadyout;
	input hresp;
	output hwdata;
	input hrdata;
	output haddr;
	output hsize;
endclocking

clocking mon_cb@(posedge clock);
	input htrans;
	input hwrite;
	input hreadyin;
	input hburst;
	input hreadyout;
	input hresp;
	input hwdata;
	input hrdata;
	input haddr;
	input hsize;
endclocking

modport DR_MP (clocking dr_cb);
modport MON_MP(clocking mon_cb);

endinterface

