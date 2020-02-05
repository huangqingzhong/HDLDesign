`timescale 1ns/1ps

/* pad the serial input iv_data , maybe less than N_FRAME_LENGTH data,
   to a whole frame of total N_FRAME_LENGTH data */
 
// latency = 1 clks
//
module xframepad# (
    parameter BWID              = 16,     // input bit-width, output bit-width = BWID + 1
    parameter N_FRAME_LENGTH    = 1024,   // total length after padded
    parameter N_MAX_BEFORE_PAD  = 256,    // number before padding, 
    parameter PAD_VALUE         = 0       // padded value
) (
    input wire                  clk,
    input wire                  rst,
    input wire [BWID-1:0]       iv_data,
    input wire                  i_nd,
    input wire                  i_head,   // frame-head flag, must sync to i_nd
    input wire                  i_tail,   // frame-tail flag, must sync to i_nd
    output reg [BWID-1:0]       ov_data,
    output reg                  o_dv,
    output reg                  o_head,
    output reg                  o_tail
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
    
   localparam IDLE        = 0;
   localparam GOT_FRAME_HEAD    = 1;
   localparam PADDING     = 2;

   reg [1:0] stt=IDLE;
   reg [clog2(N_FRAME_LENGTH):0] cnt=0;
   
    always@(posedge clk)
    if( rst )begin
        stt <= IDLE;
        cnt <= 0;
        o_dv <= 0;
        o_head <= 0;
        o_tail <= 0;
    end else begin
        o_dv    <= 0;
        o_head <= 0;
        o_tail <= 0;
        case( stt )
            IDLE : begin
                if ( i_nd & i_head ) begin
                    ov_data <= iv_data;
                    o_dv   <= 1;
                    o_head <= 1;
                    cnt   <= 0;
                    stt   <= GOT_FRAME_HEAD;
                end
            end
            GOT_FRAME_HEAD : begin
                if ( i_nd ) begin
                    ov_data <= iv_data;
                    o_dv   <= 1;
                    cnt   <= cnt + 1;
                    if( i_tail || cnt==N_MAX_BEFORE_PAD-1 )begin
                        stt   <= PADDING;
                    end
                end
            end 
            PADDING : begin
                if ( i_nd ) begin
                    ov_data <= PAD_VALUE;
                    o_dv   <= 1;
                    cnt   <= cnt + 1;
                    if( cnt== N_FRAME_LENGTH-2 )begin
                        o_tail <= 1 ;
                        stt   <= IDLE;
                    end
                end
            end
            default : stt   <= IDLE;
        endcase
    end
    
endmodule
