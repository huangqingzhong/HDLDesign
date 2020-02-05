`timescale 1ns/1ps

// latency = LATENCY clks
//
module xmult_unsigned # (
	parameter BWID_A    = 16,
	parameter BWID_B    = 16,
	parameter MSB_C     = 32,
	parameter LSB_C     =  0,
	parameter LATENCY   =  3 // at least 3
) (
	input wire              	clk,
	input wire [BWID_A-1:0] 	iA,
	input wire [BWID_B-1:0] 	iB,
	output     [MSB_C-LSB_C:0] 	oC
);

	localparam  BWID_C = BWID_A + BWID_B + 1;
  
    reg [BWID_A-1:0] rA;
    reg [BWID_B-1:0] rB;
    reg [BWID_C-1:0] rC [LATENCY :2];    

    integer i=0;
	always@(posedge clk) begin
        rA <= iA; 
        rB <= iB;
        rC[2] <= rA * rB;
        for(i=2; i<LATENCY; i=i+1)
			rC[i+1] <= rC[i];
    end
    
    assign oC = rC[LATENCY][MSB_C:LSB_C];
    
endmodule
