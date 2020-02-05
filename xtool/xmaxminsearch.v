`timescale 1ns/1ps

module xmaxminsearch # (
	parameter BWID        = 16,
	parameter BWID_INDEX  = 10,
	parameter ISSIGNED    =  1
) (
	input wire                   clk,      
	input wire [BWID-1:0]        iv_data,     // serial data input 
	input wire                   i_nd,        // flaging input data valid
	input wire                   i_head,      // flaging start of serial data input, must sync. to i_nd
	input wire                   i_tail,      // flaging end   of serial data input, must sync. to i_nd          
	output reg [BWID-1:0]        ov_max,       // the max value 
	output reg [BWID_INDEX-1:0]  ov_maxindex,  // the index of max value 
	output reg [BWID-1:0]        ov_min,       // the min value 
	output reg [BWID_INDEX-1:0]  ov_minindex,  // the index of min value 
	output reg [BWID_INDEX-1:0]  ov_total,     // total number of data proceeded
	output reg                   o_dv          // o_dv is 1clk after i_tail
);
    reg [BWID-1:0]          tMax=0,tMin=0;
    reg                     isLarge=0,isSmall=0;
    reg [BWID_INDEX-1:0]    tMaxId=0,tMinId=0,tId=0;
    reg [BWID:0]            tSubt1=0,tSubt2=0;
   
	generate
       always@* begin
            if ( ISSIGNED ) tSubt1 = {tMax[BWID-1],tMax} - {iv_data[BWID-1],iv_data};
            else            tSubt1 = {1'b0,tMax} - {1'b0,iv_data} ;
            isLarge = tSubt1[BWID];
            if ( ISSIGNED ) tSubt2 = {iv_data[BWID-1],iv_data} - {tMin[BWID-1],tMin};
            else            tSubt2 = {1'b0,iv_data} - {1'b0,tMin} ;
            isSmall = tSubt2[BWID];
       end
    endgenerate
    
   always@(posedge clk) begin
       o_dv <= 0;
       if ( i_head & i_nd ) begin
            tMax <= iv_data;
            tMaxId <= 0;
            tMin <= iv_data;
            tMaxId <= 0;
            tId <= 0;
       end else if( i_tail & i_nd ) begin
            ov_max <= isLarge ? iv_data : tMax;
            ov_maxindex <= isLarge ? tId + 1 : tMaxId;
            ov_min <= isSmall ? iv_data : tMin;
            ov_minindex <= isSmall ?tId + 1 : tMinId;
            ov_total <= tId + 2;
            o_dv <= 1;
       end else if( i_nd ) begin
            tId <= tId + 1;
            tMax <= isLarge? iv_data : tMax;
            tMaxId <= isLarge? tId + 1 : tMaxId;
            tMin <= isSmall ? iv_data : tMin;
            tMinId <= isSmall ? tId + 1 : tMinId;
        end
   end

endmodule // xmaxminsearch
