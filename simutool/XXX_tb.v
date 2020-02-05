`timescale 1ns / 1ps

module XXX_tb();
    parameter FILE_DIR = "D:/XXX/tb/sim_data";
    parameter INFILE_NAME = "din_for_XXX_tb.txt";
    parameter OUTFILE_NAME = "dout_XXX_tb.txt";
    
    parameter CLK_PERIOD = 10;
    
    reg clk, rst;    
    initial begin clk = 0; forever #(CLK_PERIOD/2) clk = ~ clk; end  
    initial begin #123 rst =0; #23 rst =1; #33 rst =0; end
    
    wire [31:0] iRsdFs; // unsigned(0.32)
    wire [31:0] iFsdRs; // unsigned(16.16)
    wire [15:0] iI, iQ; // signed(3.13)
    wire        iND;
    wire [15:0] oI, oQ; // signed(3.13)
    wire        oDV, oOSP, oIsLocked;
    
    XXX #(
       .param1 ( 4    ),
       .param2 ( 12   ),
       .param3 ( 4096 )
    )  uut (
       /* input         */ clk, rst,
       /* input  [31:0] */ iRsdFs, // unsigned(0.32)
       /* input  [31:0] */ iFsdRs, // unsigned(16.16)
       /* input  [15:0] */ iI, iQ, // signed(3.13)
       /* input         */ iND,
       /* output [15:0] */ oI, oQ, // signed(3.13)
       /* output        */ oDV, oOSP, oIsLocked
    );

    read_txtDataFile_HoldOut #(
        .DATAFILE ( {FILE_DIR,"/",INFILE_NAME} ),
        .Ndo      ( 5                        ), // number data input
        .BWID0    ( 32                       ),
        .BWID1    ( 32                       ),
        .BWID2    ( 16                       ),
        .BWID3    ( 16                       ),
        .BWID4    ( 1                        ),
        .HOLDREF  ( 4                        )
    ) read_DataFile (
        clk,
        rst,
        iRsdFs,
        iFsdRs,
        iI,
        iQ,
        iND
    );

    write_txtDataFile #(
        .DATAFILE ( {FILE_DIR,"/",OUTFILE_NAME} ),
        .Ndo      ( 2                        ),
        .BWID0    ( 16                       ),
        .BWID1    ( 16                      )
    ) write_DataFile (
        clk,
        rst,
        oOSP, 
        oI,   
        oQ    
    ); 
 
endmodule 