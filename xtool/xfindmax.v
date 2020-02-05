`timescale 1ns/1ps

module xfindmax #(
	parameter integer NEl = 8,
	parameter integer BWID = 16,
) (
	input wire                      clk, rst,
	input wire [BWID*NEl-1      :0] iv_data,
	input wire [clog2(NEl)*NEl-1:0] iv_index,
	input wire                      i_nd,
	output     [BWID-1:0]           o_max,
	output     [clog2(NEl)-1:0]     o_index,
	output                          o_dv
);

function integer clog2;
	input integer x;
begin
	clog2 = 0;
	while( x  != 0 ) begin
		clog2 = clog2 + 1;
		x = x >> 1;
	end
endfunction


if NEl == 2 generate : _leaf_

	reg [BWID-1      :0] c0, c1;
	reg [clog2(NEl)-1:0] i0, i1;
	reg                  dv0,dv1;
	always@(posedge clk)begin 
		{c0,i0} <= iv_data[BWID*2-1:0] > iv_data[BWID*1-1:0] ? 
			{iv_data[BWID*2-1:0],iv_index[clog2(NEl)*2-1:0]} : 
			{iv_data[BWID*1-1:0],iv_index[clog2(NEl)*1-1:0]};
		dv0 <= i_nd; 
	end
	assign {o_dv,o_max,o_index} = {dv0,c0,i0};
	
end else begin : _recur_

	wire [BWID-1      :0] c0, c1;
	wire [clog2(NEl)-1:0] i0, i1;
	wire                  dv0,dv1;
	xfindmax m0 #(NEl/2)( clk, rst, iv_data[BWID*NEl/2-1:         0],iv_index[clog2(NEl)*NEl/2-1:         0],i_nd,c0,i0,dv0);
	xfindmax m1 #(NEl/2)( clk, rst, iv_data[BWID*NEl  -1:BWID*NEl/2],iv_index[clog2(NEl)*NEl  -1:BWID*NEl/2],i_nd,c1,i1,dv1);
	xfindmax m2 #(2    )( clk, rst, {c0,c1},{i0,i1}, dv0&dv1, o_max, o_index, o_dv);

end

endmodule
