`timescale 1ns/1ps

module xdelay # (
	parameter BWID  = 8,
	parameter N_Clk =  32,
	parameter N_ND  = 0,
	parameter IsReset = 0
) (
	input wire             clk,
	input wire             rst,
	input wire [BWID-1:0]  iv_data,
	input wire             i_nd,
	output wire [BWID-1:0] ov_data,
	output wire            o_dv
);

	reg [BWID-1:0] r0 [N_ND   :1];
	reg [BWID-1:0] r1 [N_Clk  :1];
	reg [N_Clk:1] nd_ds;
	
	assign ov_data = r1[N_Clk];
	assign o_dv   = nd_ds[N_Clk];
	
	integer ii=0;
	generate
		always@(posedge clk) 
		if ( IsReset & rst )
			for( ii=1; ii<=N_ND; ii=ii+1)
				r0[ii] <= 0;
		else if( i_nd )begin
			r0[1] <= iv_data;
			for( ii=1; ii<N_ND; ii=ii+1)
				r0[ii+1] <= r0[ii];
		end 
		always@(posedge clk) 
		if ( IsReset & rst)
			for( ii=1; ii<=N_Clk; ii=ii+1)
				r1[ii] <= 0;		
		else begin
			r1[1] <= N_ND > 0 ? r0[N_ND] : iv_data;
			nd_ds[1] <= i_nd;
			for( ii=1; ii<N_Clk; ii=ii+1)begin
				r1[ii+1] <= r1[ii];
				nd_ds[ii+1] <= nd_ds[ii];
			end
		end
   endgenerate

endmodule
	
	
	
