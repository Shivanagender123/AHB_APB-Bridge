
class apb_xtn extends uvm_sequence_item;
`uvm_object_utils(apb_xtn)

bit pselx;
bit penable;
bit pwrite;
bit [31:0]prdata[];
bit [31:0]pwdata[];
bit [31:0]paddr[];
rand int f;
function void do_print(uvm_printer printer);
	foreach(paddr[i])
	printer.print_field($sformatf("paddr[%0d]",i),paddr[i],32,UVM_HEX);
	
	foreach(pwdata[i])
	printer.print_field($sformatf("pwdata[%0d]",i),pwdata[i],32,UVM_DEC); 
	foreach(prdata[i])
	printer.print_field($sformatf("prdata[%0d]",i),prdata[i],32,UVM_DEC); 

endfunction
endclass
