`timescale 1ns / 1ps
     
module 	xcrossclock #(
    parameter         BWID   = 1,
    parameter         NStage = 3,
	parameter         IS_ENABLE_RESET = 0
) (
    input             dclk, drst,  // destiny clk and rst
    input  [BWID-1:0] x,
    output [BWID-1:0] y
);
    (* ASYNC_REG="true" *)reg    [BWID-1:0] xDs [NStage:0];
    assign            y = xDs[NStage];
    
    always@(*)  xDs[0] <= x;
        
    integer           ii=0;
    always@(posedge dclk )
        if( IS_ENABLE_RESET && drst )
            for( ii=1; ii<=NStage; ii=ii+1) xDs[ii] <= 0 ;
        else
            for( ii=1; ii<=NStage; ii=ii+1) xDs[ii] <= xDs[ii-1] ;
endmodule
