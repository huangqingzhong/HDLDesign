`timescale 1ns/1ps

/* slide-window accumulation */

// latency = 2clk
//
module xslideaccum # (
	parameter BWID          = 16,   // input data bit-width, the output bit-width = BWID + clog2(NWINDOWS)
	parameter NWINDOWS      = 64    // slide sum window
) (
	input wire                            clk,
	input wire                            rst,
	input wire [BWID-1:0]                 iv_data,
	input wire                            i_nd,
	output reg [clog2(NWINDOWS)+BWID-1:0] ov_data,
	output reg                            o_dv
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
    end else if( i_nd ) begin
        rRegs[1] <= iv_data;
        for( i=2; i<=NWINDOWS; i=i+1)
            rRegs[i] <= rRegs[i-1];
        diff <= {iv_data[BWID-1],iv_data} - {rRegs[NWINDOWS][BWID-1],rRegs[NWINDOWS]};
        rSum <= rSum + diff;
    end
    
    reg iND_d1=0;
    always@(posedge clk)
    if( rst )
        iND_d1 <= 0;
    else
        iND_d1 <= i_nd;
    
    always@(posedge clk)
    if( rst )begin
        ov_data <= 0;
        o_dv <= 0;
    end else if (iND_d1) begin
        ov_data <= ov_data + { {BWIDOUT-BWID-1{diff[BWID]}},diff}};
        o_dv <= 1;
    end else
        o_dv <= 0;
        
endmodule
