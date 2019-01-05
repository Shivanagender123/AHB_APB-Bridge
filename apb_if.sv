interface apb_if (input bit clock);
logic pselx;
logic penable;
logic pwrite;
logic [31:0]prdata;
logic [31:0]pwdata;
logic [31:0]paddr;

clocking dr_cb @(posedge clock);
	input penable;
	input pwrite;
	input paddr;
	input pwdata;
	output prdata;
	input pselx;
endclocking

clocking mon_cb @(posedge clock);
	input penable;
	input pwrite;
	input paddr;
	input pwdata;
	input pselx;
	input prdata;
endclocking

modport DR_MP(clocking dr_cb);
modport MON_MP(clocking mon_cb);

endinterface
