`timescale 1ns/1ps

/* common bit-width convertor */

module xbwidconvert # (
    parameter IBWID  = 5,
    parameter OBWID  = 32
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

	function unsigned cal_quotient;
		input unsigned divided;
		input unsigned divisor;
	begin
		cal_quotient = 1;
		while divisor * cal_quotient < divided
			divisor = divisor + 1;
	endfunction
	
	generate
	if ( IBWID*cal_quotient(OBWID,IBWID) == OBWID )
	begin : exact_division
		xs2p # (
			.BWID( IBWID ),
			.Npar( cal_quotient(OBWID,IBWID) )
		) (
			.clk( clk ),
			.rst( rst ),
			.iv_data( iv_data ),
			.i_nd( i_nd ),
			.i_trig( i_trig ),
			.ov_data( ov_data ),
			.o_dv( o_dv ),
			.o_tirg( o_tirg )
		);
	end else
	begin : NON_exact_division
		// TODO 
		// inplement the NON-exact_division branch
	end
	endgenerate
    
endmodule
    
    
    