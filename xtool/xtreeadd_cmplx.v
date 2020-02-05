`timescale 1ns/1ps

/* tree-adder of complex with operate-ctrl */

// latency = 4*( log2(Nops) + 1 ) clks
//
module xtreeadd_cmplx # (
    parameter Nops  = 4,        /* number of data to to process                                   */
    parameter IBWID = 16,       /* input data bit-width, the output bit-width = clog2(Nops)+IBWID */
    parameter IS_CMPLX = 0  /* indicating the OP is a complex, not real                       */
) (
    input wire                          iClk, 
    /* vector of data to process, each data contains IBWID bits               */
    input wire [Nops*IBWID-1:0]         iVecDI,
    input wire [Nops*IBWID-1:0]         iVecDQ,
    /* vector of complex operater, each operater consists real and imag part, */
    /*   2'b01 mean "ADD", 2'b11 mean "SUBTRACT", else mean "NO-operation"    */
    /* if IS_CMPLX = 0, operater[3:2] (imag part) is omitted !!!          */
    input wire [Nops*2-1:0]             iVecOpI,
    input wire [Nops*2-1:0]             iVecOpQ,
    input wire                          iND,
    output     [clog2(Nops)+IBWID-1:0]  oSumI, 
    output     [clog2(Nops)+IBWID-1:0]  oSumQ, 
    output                              oDV
);  

    function integer clog2;
        input integer x;
        begin
            clog2=0;
            // while( x > 1 ) begin
            while( x > 0 ) begin
                clog2 = clog2+1;
                x = x >> 1;
            end
        end
    endfunction
    
    function [IBWID+1-1:0] myMult;
        input [IBWID-1:0] xD;
        input [2-1:0] op;
        begin
           if ( op == 2'b01 ) myMult = {xD[IBWID-1],xD};
           else if ( op == 2'b11 ) myMult = ~{xD[IBWID-1],xD} + 1;
           else myMult = 0;
        end
    endfunction 
    
    reg  iNDd1;
    always@(posedge iClk) iNDd1 <= iND;
    
    wire [clog2(Nops/2)+IBWID:0] sumAllI, sumAllQ;
    reg                          dvSum;

    genvar jj;
    generate
      if ( Nops == 1) begin : gen_leaf /////////////////////
      
        reg [IBWID+1-1:0] OpI_a,OpQ_b,OpI_b,OpQ_a, tmpI, tmpQ;
        always@(posedge iClk) begin // dly = 2
           OpI_a <= myMult(iVecDI,iVecOpI);
           OpQ_b <= myMult(iVecDQ,iVecOpQ);
           OpI_b <= myMult(iVecDQ,iVecOpI);
           OpQ_a <= myMult(iVecDI,iVecOpQ);
           tmpI <= IS_CMPLX ? OpI_a - OpQ_b : OpI_a;
           tmpQ <= IS_CMPLX ? OpI_b + OpQ_a : OpI_b;
           dvSum <= iNDd1;
        end
        assign sumAllI = tmpI;
        assign sumAllQ = tmpQ;
        
      end else begin : gen_recur //////////////////////////
      
        reg [Nops/2*IBWID-1:0] vOddI, vOddQ, vEvenI, vEvenQ; 
        reg [Nops/2*2    -1:0] OpEvenI, OpEvenQ, OpOddI, OpOddQ; 
        for ( jj=0; jj < Nops/2; jj=jj+1 ) begin : vec_slice
            always@(posedge iClk) begin // dly = 1clk
                vEvenI[ (jj+1)*IBWID-1  : jj*IBWID ] <= iVecDI[jj*IBWID*2+IBWID-1: jj*IBWID*2  ];
                vEvenQ[ (jj+1)*IBWID-1  : jj*IBWID ] <= iVecDQ[jj*IBWID*2+IBWID-1: jj*IBWID*2  ];
                vOddI [ (jj+1)*IBWID-1  : jj*IBWID ] <= iVecDI[jj*IBWID*2+IBWID*2-1 : jj*IBWID*2+IBWID];
                vOddQ [ (jj+1)*IBWID-1  : jj*IBWID ] <= iVecDQ[jj*IBWID*2+IBWID*2-1 : jj*IBWID*2+IBWID];
                OpEvenI[ (jj+1)*2-1     : jj*2     ] <= iVecOpI[jj*2*2+2-1 : jj*2*2  ];
                OpEvenQ[ (jj+1)*2-1     : jj*2     ] <= iVecOpQ[jj*2*2+2-1 : jj*2*2  ];
                OpOddI [ (jj+1)*2-1     : jj*2     ] <= iVecOpI[jj*2*2+2*2-1 : jj*2*2+2];
                OpOddQ [ (jj+1)*2-1     : jj*2     ] <= iVecOpQ[jj*2*2+2*2-1 : jj*2*2+2];
            end
        end

        wire [clog2(Nops/2)+IBWID-1:0] sumEvenI, sumEvenQ, sumOddI, sumOddQ;
        wire dvEven, dvOdd;
        xtreeadd_cmplx #(
           .Nops( Nops/2 ),
           .IBWID( IBWID ),
           .IS_CMPLX( IS_CMPLX )
        ) m10_TreeAdd_EvenI   // dly = 4*log2(Nops) clks
        (
            .iClk( iClk ),
            .iVecDI( vEvenI ),
            .iVecDQ( vEvenQ ),
            .iVecOpI( OpEvenI ),
            .iVecOpQ( OpEvenQ ),
            .iND( iNDd1 ),
            .oSumI( sumEvenI ),
            .oSumQ( sumEvenQ ),
            .oDV ( dvEven )
        );
        xtreeadd_cmplx #(
           .Nops( Nops/2 ),
           .IBWID( IBWID ),
           .IS_CMPLX( IS_CMPLX )
        ) m10_TreeAdd_OddI    // dly = 4*log2(Nops) clks
        (
            .iClk( iClk ),
            .iVecDI( vOddI ),
            .iVecDQ( vOddQ ),
            .iVecOpI( OpOddI ),
            .iVecOpQ( OpOddQ ),
            .iND( iNDd1 ),
            .oSumI( sumOddI ),
            .oSumQ( sumOddQ ),
            .oDV ( dvOdd )
        );  

        xAdd #(
            .IBWID( clog2(Nops/2)+IBWID  )
        ) m21_sumAllI (   // dly = 1 clk
            .iClk( iClk ),
            .iA( sumEvenI ),
            .iB( sumOddI  ),
            .oC( sumAllI )
        );
        xAdd #(
            .IBWID( clog2(Nops/2)+IBWID  )
        ) m21_sumAllQ ( 
            .iClk( iClk ),
            .iA( sumEvenQ ),
            .iB( sumOddQ  ),
            .oC( sumAllQ )
        );     
        always@(posedge iClk) dvSum <= dvEven & dvOdd;

      end // gen_recur 
   endgenerate
        
    reg  [clog2(Nops/2)+IBWID:0] sumAllIdd [2:1];
    reg  [clog2(Nops/2)+IBWID:0] sumAllQdd [2:1];
    reg  [2:1]                   dvSumdd;
    always@(posedge iClk) begin
        sumAllIdd[1] <= sumAllI;   sumAllIdd[2] <= sumAllIdd[1];
        sumAllQdd[1] <= sumAllQ;   sumAllQdd[2] <= sumAllQdd[1];        
        dvSumdd[1]   <= dvSum;     dvSumdd[2]   <= dvSumdd[1];
    end
    assign oSumI = sumAllIdd[2];
    assign oSumQ = IS_CMPLX ? sumAllQdd[2] : 0;
    assign oDV  = dvSumdd[2];
   
endmodule