`timescale 1ns/1ps

/* coarsly calculate abs(iv_re + 1j*iv_im), 
    ~= max(abs(iv_re),abs(iv_im)) + min(abs(iv_re),abs(iv_im)) / 4 */

// latency = 3 clks
//
module xabs_coarse # (
	parameter BWID    	= 16,   // input bit-width, output bit-width = BWID + 1
) (
	input wire            clk,
	input wire [BWID-1:0] iv_re,
	input wire [BWID-1:0] iv_im,
    input wire            i_nd,
	output reg [BWID-1:0] ov_abs,
	output reg            o_dv
);
    reg [2:1]      nd_ds=0;
    reg [BWID-1:0] absA, absB ;
    reg [BWID-1:0] xMin, xMax ;

    wire [BWID-1:0] BsubtA = absB - absA;
    
	always@(posedge clk) begin
        absA <= iv_re[BWID-1] ? ~iv_re : iv_re ;
        absB <= iv_im[BWID-1] ? ~iv_im : iv_im ;
        if( BsubtA[BWID-1] ) begin  // A larger then B
            xMin <= absB; xMax <= absA;
        end else begin
            xMin <= absA; xMax <= absB;
        end
        nd_ds <= {nd_ds[1:1],i_nd};
        
        ov_abs  <= xMax + {{2{xMin[BWID-1]}},xMin[BWID-1:2]};
        o_dv <= nd_ds[2];
    end
   
endmodule


