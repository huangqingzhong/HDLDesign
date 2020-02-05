`timescale 1ns/1ps

module read_txtDataFile #(
	parameter DATAFILE = "./Din.txt",
	parameter Ndo    = 5,  		// number data output
	parameter BWID0  = 16,
	parameter BWID1  = 16,
	parameter BWID2  = 16,
	parameter BWID3  = 16,
	parameter BWID4  = 16,
	parameter BWID5  = 1,
	parameter BWID6  = 1,
	parameter BWID7  = 1,
	parameter BWID8  = 1,
	parameter BWID9  = 1,
	parameter BWID10 = 1,
	parameter BWID11 = 1,
	parameter BWID12 = 1,
	parameter BWID13 = 1,
	parameter BWID14 = 1,
	parameter BWID15 = 1
) (
	input wire iClk,
	input wire iTrig,
	output reg [BWID0 -1:0] oData0 =0,
	output reg [BWID1 -1:0] oData1 =0,
	output reg [BWID2 -1:0] oData2 =0,
	output reg [BWID3 -1:0] oData3 =0,
	output reg [BWID4 -1:0] oData4 =0,
	output reg [BWID5 -1:0] oData5 =0,
	output reg [BWID6 -1:0] oData6 =0,
	output reg [BWID7 -1:0] oData7 =0,
	output reg [BWID8 -1:0] oData8 =0,
	output reg [BWID9 -1:0] oData9 =0,
	output reg [BWID10-1:0] oData10=0,
	output reg [BWID11-1:0] oData11=0,
	output reg [BWID12-1:0] oData12=0,
	output reg [BWID13-1:0] oData13=0,
	output reg [BWID14-1:0] oData14=0,
	output reg [BWID15-1:0] oData15=0
);
	integer res, tmpData;
	integer fid=0;

    integer ii=0;    
	initial begin
		fid = $fopen(DATAFILE, "r");
		if( fid==0 ) begin
			$display("Error @read_txtDataFile : file can NOT open for READING.\nExit Simulation!");
			$finish;
		end
		@(posedge iTrig);
        forever @(posedge iClk) begin
            for( ii = 0; ii < Ndo ; ii = ii+1 ) begin
                res = $fscanf(fid, "%d\n", tmpData);
				case ( ii )
					0  : oData0  = $signed( tmpData );
					1  : oData1  = $signed( tmpData );
					2  : oData2  = $signed( tmpData );
					3  : oData3  = $signed( tmpData );
					4  : oData4  = $signed( tmpData );
					5  : oData5  = $signed( tmpData );
					6  : oData6  = $signed( tmpData );
					7  : oData7  = $signed( tmpData );
					8  : oData8  = $signed( tmpData );
					9  : oData9  = $signed( tmpData );
					10 : oData10 = $signed( tmpData );
					11 : oData11 = $signed( tmpData );
					12 : oData12 = $signed( tmpData );
					13 : oData13 = $signed( tmpData );
					14 : oData14 = $signed( tmpData );
					15 : oData15 = $signed( tmpData );
					default : ;
				endcase
            end // for
        end	// forever
    end // initial

endmodule // read_txtDataFile

module read_txtDataFile_HoldOut #(
	parameter DATAFILE = "./Din.txt",
	parameter Ndo    = 5,  		// number data output
	parameter BWID0  = 16,
	parameter BWID1  = 16,
	parameter BWID2  = 16,
	parameter BWID3  = 16,
	parameter BWID4  = 1,
	parameter BWID5  = 1,
	parameter BWID6  = 1,
	parameter BWID7  = 1,
	parameter BWID8  = 1,
	parameter BWID9  = 1,
	parameter BWID10 = 1,
	parameter BWID11 = 1,
	parameter BWID12 = 1,
	parameter BWID13 = 1,
	parameter BWID14 = 1,
	parameter BWID15 = 1,
	parameter HOLDREF = 15  // the first one is index 0
) (
	input wire iClk,
	input wire iTrig,
	output reg [BWID0 -1:0] oData0 =0,
	output reg [BWID1 -1:0] oData1 =0,
	output reg [BWID2 -1:0] oData2 =0,
	output reg [BWID3 -1:0] oData3 =0,
	output reg [BWID4 -1:0] oData4 =0,
	output reg [BWID5 -1:0] oData5 =0,
	output reg [BWID6 -1:0] oData6 =0,
	output reg [BWID7 -1:0] oData7 =0,
	output reg [BWID8 -1:0] oData8 =0,
	output reg [BWID9 -1:0] oData9 =0,
	output reg [BWID10-1:0] oData10=0,
	output reg [BWID11-1:0] oData11=0,
	output reg [BWID12-1:0] oData12=0,
	output reg [BWID13-1:0] oData13=0,
	output reg [BWID14-1:0] oData14=0,
	output reg [BWID15-1:0] oData15=0
);
	wire [BWID0 -1:0] tmp_oData0, tmp_oData1, tmp_oData2, tmp_oData3  ;
    wire [BWID4 -1:0] tmp_oData4, tmp_oData5, tmp_oData6, tmp_oData7  ;
    wire [BWID8 -1:0] tmp_oData8, tmp_oData9, tmp_oData10,tmp_oData11 ;
    wire [BWID12-1:0] tmp_oData12,tmp_oData13,tmp_oData14,tmp_oData15 ;

    read_txtDataFile #(
	   .DATAFILE ( DATAFILE ),
	   .Ndo      ( Ndo      ),  		// number data output
	   .BWID0    ( BWID0    ), .BWID1    ( BWID1    ), .BWID2    ( BWID2    ), .BWID3    ( BWID3    ),
	   .BWID4    ( BWID4    ), .BWID5    ( BWID5    ), .BWID6    ( BWID6    ), .BWID7    ( BWID7    ),
	   .BWID8    ( BWID8    ), .BWID9    ( BWID9    ), .BWID10   ( BWID10   ), .BWID11   ( BWID11   ),
	   .BWID12   ( BWID12   ), .BWID13   ( BWID13   ), .BWID14   ( BWID14   ), .BWID15   ( BWID15   )
    ) read_data (
        iClk,
        iTrig,
        tmp_oData0, tmp_oData1, tmp_oData2, tmp_oData3,
        tmp_oData4, tmp_oData5, tmp_oData6, tmp_oData7,
        tmp_oData8, tmp_oData9, tmp_oData10,tmp_oData11,
        tmp_oData12,tmp_oData13,tmp_oData14,tmp_oData15
    );
    
    reg xRef;
    always@*
        case( HOLDREF ) 
            0  : xRef = tmp_oData0 [0 ];
            1  : xRef = tmp_oData1 [0 ];
            2  : xRef = tmp_oData2 [0 ];
            3  : xRef = tmp_oData3 [0 ];
            4  : xRef = tmp_oData4 [0 ];
            5  : xRef = tmp_oData5 [0 ];
            6  : xRef = tmp_oData6 [0 ];
            7  : xRef = tmp_oData7 [0 ];
            8  : xRef = tmp_oData8 [0 ];
            9  : xRef = tmp_oData9 [0 ];
            10 : xRef = tmp_oData10[0 ];
            11 : xRef = tmp_oData11[0 ];
            12 : xRef = tmp_oData12[0 ];
            13 : xRef = tmp_oData13[0 ];
            14 : xRef = tmp_oData14[0 ];
            15 : xRef = tmp_oData15[0 ];
            default : xRef = tmp_oData15[0];
         endcase
    
    always@( posedge iClk)
    begin 
        if( xRef )begin
             oData0  <= tmp_oData0 ;
             oData1  <= tmp_oData1 ;
             oData2  <= tmp_oData2 ;
             oData3  <= tmp_oData3 ;
             oData4  <= tmp_oData4 ;
             oData5  <= tmp_oData5 ;
             oData6  <= tmp_oData6 ;
             oData7  <= tmp_oData7 ;
             oData8  <= tmp_oData8 ;
             oData9  <= tmp_oData9 ;
             oData10 <= tmp_oData10;
             oData11 <= tmp_oData11;
             oData12 <= tmp_oData12;
             oData13 <= tmp_oData13;
             oData14 <= tmp_oData14;
             oData15 <= tmp_oData15; 
        end 
        case( HOLDREF ) 
            0  : oData0  <= tmp_oData0 [0 ];
            1  : oData1  <= tmp_oData1 [0 ];
            2  : oData2  <= tmp_oData2 [0 ];
            3  : oData3  <= tmp_oData3 [0 ];
            4  : oData4  <= tmp_oData4 [0 ];
            5  : oData5  <= tmp_oData5 [0 ];
            6  : oData6  <= tmp_oData6 [0 ];
            7  : oData7  <= tmp_oData7 [0 ];
            8  : oData8  <= tmp_oData8 [0 ];
            9  : oData9  <= tmp_oData9 [0 ];
            10 : oData10 <= tmp_oData10[0 ];
            11 : oData11 <= tmp_oData11[0 ];
            12 : oData12 <= tmp_oData12[0 ];
            13 : oData13 <= tmp_oData13[0 ];
            14 : oData14 <= tmp_oData14[0 ];
            15 : oData15 <= tmp_oData15[0 ];
            default : oData15 = tmp_oData15[0];
         endcase 
    end

endmodule

 
    