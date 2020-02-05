'timescale 1ns/1ps
/* expand the i_pulse to o_pulse , which will last for Nxpd-clks 
*     at the rising-edge of i_pulse */

module 	xpulseexpd #(
    parameter Nxpd  = 16
) (
    input      clk, rst,
    input      i_pulse,
    output reg o_pulse
);
    //  The following function calculates the address width based on specified RAM depth
    function integer clogb2;
      input integer depth;
        for (clogb2=0; depth>0; clogb2=clogb2+1)
          depth = depth >> 1;
    endfunction

    reg    [clogb2(Nxpd-1)-1:0]  cnt;
    always@(posedge clk)
        if( rst ) begin
            o_pulse <= 0;
            cnt <= 0;
        end else begin       
            if( i_pulse ) begin
                o_pulse <= 1;
                cnt <= 0;
            end else if ( o_pulse ) begin
                 if( cnt == Nxpd-1 )
                    o_pulse <= 0;
                 else
                    cnt <= cnt + 1;
            end
        end
endmodule 	
