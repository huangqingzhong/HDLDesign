`timescale 1ns/1ps

/* addtion or subtraction */

// latency = 1 clks
//
module xaddsubt # (
	parameter BWID    = 16,
    parameter LATENCY = 1
) (
	input wire            clk,
	input wire [BWID-1:0] iv_a,
	input wire [BWID-1:0] iv_b,
	input wire            i_nd,
	output     [BWID-1:0] ov_sum,
	output     [BWID-1:0] ov_diff,
	output                o_dv
);

    reg [BWID-1:0] rC [LATENCY:0];
    reg [BWID-1:0] rD [LATENCY:0];
    reg [BWID-1:0] rND;
    
	always@* rC[0] = iv_a + iv_b ;
	always@* rD[0] = iv_a - iv_b ;
	always@* rND[0] = i_nd ;

    integer i= 0;
	always@(posedge clk)
		for(i=0; i<LATENCY; i=i+1) begin
			rC[i+1] <= rC[i];
			rD[i+1] <= rD[i];
			rND[i+1] <= rND[i];
		end
    
    assign ov_sum  = rC[LATENCY];
    assign ov_diff = rD[LATENCY];
    assign o_dv    = rND[LATENCY];
    
endmodule
