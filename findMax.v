`timescale 1ns/1ps

module findMax #(
	parameter integer NEl = 8,
	parameter integer BWID = 16,
) (
	input wire                      clk, rst,
	input wire [BWID*NEl-1      :0] iVData,
	input wire [clog2(NEl)*NEl-1:0] iVIndx,
	input wire                      iND,
	output     [BWID-1:0]           oC,
	output     [clog2(NEl)-1:0]     oIndx,
	output                          oDV
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
		{c0,i0} <= iVData[BWID*2-1:0] > iVData[BWID*1-1:0] ? 
			{iVData[BWID*2-1:0],iVIndx[clog2(NEl)*2-1:0]} : 
			{iVData[BWID*1-1:0],iVIndx[clog2(NEl)*1-1:0]};
		dv0 <= iND; 
	end
	assign {oDV,oC,oIndx} = {dv0,c0,i0};
	
end else begin : _recur_

	wire [BWID-1      :0] c0, c1;
	wire [clog2(NEl)-1:0] i0, i1;
	wire                  dv0,dv1;
	findMax m0 #(NEl/2)( clk, rst, iVData[BWID*NEl/2-1:         0],iVIndx[clog2(NEl)*NEl/2-1:         0],iND,c0,i0,dv0);
	findMax m1 #(NEl/2)( clk, rst, iVData[BWID*NEl  -1:BWID*NEl/2],iVIndx[clog2(NEl)*NEl  -1:BWID*NEl/2],iND,c1,i1,dv1);
	findMax m2 #(2    )( clk, rst, {c0,c1},{i0,i1}, dv0&dv1, oC, oIndx, oDV);

end

endmodule