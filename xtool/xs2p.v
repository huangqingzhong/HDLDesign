`timescale 1ns/1ps

module xs2p # (
    parameter BWID  = 8,
    parameter Npar  = 4
) (
    input wire              clk,
    input wire              rst,
    input wire [BWID-1:0]   iv_data,
    input wire              i_nd,
    input wire              i_trig,
    output [BWID*Npar-1:0]  ov_data,
    output                  o_dv,
    output                  o_tirg
);
    function integer clog2;
        input integer x;
        begin
            clog2=0;
            while( x > 0 ) begin
                clog2 = clog2+1;
                x = x >> 1;
            end
        end
    endfunction

    localparam B  = BWID;
    localparam NP = Npar;
    
    reg [B*NP-1:0]          r1;
    reg [NP    :1]          trig_ds;
    reg [clog2(BWID)-1:0]   cnt;
    reg                     nd_d1, dv;
    reg                     trig_d1;
    
    assign ov_data  = r1;
    assign o_dv     = dv;
    assign o_tirg   = trig_d1;
    
    integer ii;
    always@(posedge clk) // dly = 1 clk
	if( rst ) begin
		r1 <= 0;
		trig_ds <= 0;
		cnt <= 0;
		dv <= 0;
		trig_d1 <= 0;
	end else begin
		if( i_nd ) begin
            r1 <= {iv_data,r1[B*NP-1:B]};
            trig_ds <= {i_trig,trig_ds[NP:2]};
            if( i_trig || cnt == NP-1 ) cnt <= 0;
            else cnt <= cnt + 1;
        end
        nd_d1 <= i_nd;
        dv <=  nd_d1 && ( cnt == NP-1 );
        trig_d1 <= nd_d1 & trig_ds[1];
    end
    
endmodule
    
    
    