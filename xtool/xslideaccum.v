`timescale 1ns/1ps

/* slide-window accumulation */

// latency = 2clk
//
module xslideaccum # (
	parameter BWID          = 16,   // input data bit-width, the output bit-width = BWID + clog2(NWINDOWS)
	parameter NWINDOWS      = 64    // slide sum window
) (
	input wire clk, rst,
	input wire [BWID-1:0] iDin,
	input wire iND,
	output reg [clog2(NWINDOWS)+BWID-1:0] oDout,
	output reg oDV
);
	function integer clog2;
		input integer x;
		begin
			clog2=0;
			while( x > 1 ) begin
				clog2 = clog2+1;
				x = x >> 1;
			end
		end
	endfunction
    
    localparam BWIDOUT = clog2(NWINDOWS)+BWID;
    integer i=0;
    reg [BWID-1:0] rRegs [NWINDOWS:1];
    reg [BWID:0] diff=0;
    always@(posedge clk)
    if( rst ) begin
        for( i=1; i<=NWINDOWS; i=i+1)
            rRegs[i] <= 0;
        diff <= 0;
    end else if( iND ) begin
        rRegs[1] <= iDin;
        for( i=2; i<=NWINDOWS; i=i+1)
            rRegs[i] <= rRegs[i-1];
        diff <= {iDin[BWID-1],iDin} - {rRegs[NWINDOWS][BWID-1],rRegs[NWINDOWS]};
        rSum <= rSum + diff;
    end
    
    reg iND_d1=0;
    always@(posedge clk)
    if( rst )
        iND_d1 <= 0;
    else
        iND_d1 <= iND;
    
    always@(posedge clk)
    if( rst )begin
        oDout <= 0;
        oDV <= 0;
    end else if (iND_d1) begin
        oDout <= oDout + { {BWIDOUT-BWID-1{diff[BWID]}},diff}};
        oDV <= 1;
    end else
        oDV <= 0;
        
endmodule
