
class ahb_xtn extends uvm_sequence_item;
`uvm_object_utils(ahb_xtn)

bit hclk;
bit hresetn;
bit [1:0]htrans;
bit hwrite;
bit hreadyin;
rand bit [2:0]hburst;
bit hreadyout;
bit [1:0]hresp;
rand bit [31:0]hwdata[];
bit [31:0]hrdata[];
rand bit [31:0]haddr[];
rand bit [2:0]hsize;
rand int g;
/////////////////////////////////CONSTRAINTS//////////////

constraint  G  {if(hburst==0||hburst==1) g==1; else if(hburst==2||hburst==3) g==4; else if(hburst==4||hburst==5) g==8;else if(hburst==6||hburst==7) g==16;}
constraint SIZE{hwdata.size==g;haddr.size==g;}

constraint ADR {foreach(haddr[i])  haddr[i]>=32'h8000_0000&& haddr[i]<=32'h8000_03ff; }

constraint DF  {if(hsize==1) foreach(haddr[i]) haddr[i]%2==0;}

function void do_print (uvm_printer printer);
	printer.print_field("hburst",hburst,3,UVM_BIN);
	printer.print_field("hsize",hsize,3,UVM_BIN);
	printer.print_field("hRESP",hresp,2,UVM_BIN);
	foreach(haddr[i])
	printer.print_field($sformatf("haddr[%0d]",i),haddr[i],32,UVM_HEX);
	
	foreach(hwdata[i])
	printer.print_field($sformatf("hwdata[%0d]",i),hwdata[i],32,UVM_DEC); 
	foreach(hrdata[i])
	printer.print_field($sformatf("hrdata[%0d]",i),hrdata[i],32,UVM_DEC); 
endfunction 

function void post_randomize;
	
	if(hburst!=0 && hburst!=1)
		begin
			if(hburst%2==1)
				begin
					foreach(haddr[i])
						begin
							if(i>0)
								haddr[i]=haddr[i-1]+2**hsize;
						end
				end
			else
				begin	
						if(hburst == 3'b010 )     //   WRAP 4 of  hsize = 8 bit 
						begin
						bit [1:0]a=2**hsize;
							foreach(haddr[i])
								begin
							haddr[i+1] = {haddr[i][31:2],haddr[i][1:0]+a};
								end
						end
						if(hburst == 3'b100)    // WRAP 8 of hsize = 8 bit
						begin
						bit [2:0]a=2**hsize;
							foreach(haddr[i])
								begin
						haddr[i+1] = {haddr[i][31:3],haddr[i][2:0] + a};		
								end
						end
						if(hburst == 3'b110)    // WRAP 16 of hsize = 8 bit
						begin
						bit [3:0]a=2**hsize;	
							foreach(haddr[i])
								begin
							haddr[i+1] = {haddr[i][31:4],haddr[i][3:0] + a};		
								end
						end
				end
		end
endfunction
endclass
