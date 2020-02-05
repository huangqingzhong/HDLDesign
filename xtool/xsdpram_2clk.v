`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/15 14:13:47
// Design Name: 
// Module Name: xsdpram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  //  Xilinx Simple Dual Port 2 Clock RAM
  //  This code implements a parameterizable SDP dual clock memory.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  
module xsdpram_2clk # (
  parameter RAM_WIDTH              = 64,                       // Specify RAM data width
  parameter RAM_DEPTH              = 1024,                     // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE        = "LOW_LATENCY",          // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE              = ""                       // Specify name/location of RAM initialization file if using one (leave blank if not)
) (
      input                            clka        ,    // input wire clka
	  input                            wea         ,    // Write enable
	  input [clogb2(RAM_DEPTH-1)-1:0]  addra       ,    // Write address bus, width determined from RAM_DEPTH
	  input [RAM_WIDTH-1:0]            dina        ,    // RAM input data
	  input                            clkb        ,    // input wire clkb
      input                            rstb        ,    // Output reset (does not affect memory contents)
	  input                            enb         ,    // Read Enable, for additional power savings, disable when not in use
      input                            regceb      ,    // Output register enable
	  input [clogb2(RAM_DEPTH-1)-1:0]  addrb       ,    // Read address bus, width determined from RAM_DEPTH
	  output [RAM_WIDTH-1:0]           doutb             // RAM output data
);
  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

  reg [RAM_WIDTH-1:0] xRam [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] RamData = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, xRam, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          xRam[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge clka)
    if (wea)
      xRam[addra] <= dina;

  always @(posedge clkb)
    if (enb)
      RamData <= xRam[addrb];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "HIGH_PERFORMANCE") begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing
      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};
      always @(posedge clkb)
        if (rstb)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= RamData;

      assign doutb = doutb_reg;

    end else begin: no_output_register
    
      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign doutb = RamData;

    end
  endgenerate
	
endmodule