`timescale 1ns/1ps

module xrom # (
   parameter BWID = 32,
   parameter BWID_ADDR = 32,
   parameter INIT_FILE = "./ROM_hex.txt"
) (
	input wire clk,
    input wire [BWID_ADDR-1:0] addr,
	input wire nd,
	output reg [BWID-1:0] dout
);

   (* rom_style="{distributed | block}" *)
   reg [BWID-1:0] XXROM [(2**BWID_ADDR)-1:0];

   initial
      $readmemh( INIT_FILE, XXROM, 0, (2**BWID_ADDR)-1 );

   always @(posedge clk)
      if ( nd )
         dout <= XXROM[ addr ];

endmodule
	
	
	