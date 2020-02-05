`timescale 1ns/1ps

module write_txtDataFile #(
	parameter DATAFILE = "./Dout.txt",
	parameter Ndo    = 5,  		// number data to write
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
	input wire iND,
	input wire [BWID0 -1:0] iData0 ,
	input wire [BWID1 -1:0] iData1 ,
	input wire [BWID2 -1:0] iData2 ,
	input wire [BWID3 -1:0] iData3 ,
	input wire [BWID4 -1:0] iData4 ,
	input wire [BWID5 -1:0] iData5 ,
	input wire [BWID6 -1:0] iData6 ,
	input wire [BWID7 -1:0] iData7 ,
	input wire [BWID8 -1:0] iData8 ,
	input wire [BWID9 -1:0] iData9 ,
	input wire [BWID10-1:0] iData10,
	input wire [BWID11-1:0] iData11,
	input wire [BWID12-1:0] iData12,
	input wire [BWID13-1:0] iData13,
	input wire [BWID14-1:0] iData14,
	input wire [BWID15-1:0] iData15
);
	integer res, tmpData;
	integer fid=0;

    integer ii=0;    
	initial begin
		fid = $fopen(DATAFILE, "w");
		if( fid==0 ) begin
			$display("Error @write_txtDataFile : file can NOT open for WRITING.\nExit Simulation!");
			$finish;
		end
		@(posedge iTrig);
        forever @(posedge iClk) 
        if( iND ) begin
            for( ii = 0; ii < Ndo ; ii = ii+1 ) begin
				case ( ii )
					0  : tmpData = $signed( iData0  );
					1  : tmpData = $signed( iData1  );
					2  : tmpData = $signed( iData2  );
					3  : tmpData = $signed( iData3  );
					4  : tmpData = $signed( iData4  );
					5  : tmpData = $signed( iData5  );
					6  : tmpData = $signed( iData6  );
					7  : tmpData = $signed( iData7  );
					8  : tmpData = $signed( iData8  );
					9  : tmpData = $signed( iData9  );
					10 : tmpData = $signed( iData10 );
					11 : tmpData = $signed( iData11 );
					12 : tmpData = $signed( iData12 );
					13 : tmpData = $signed( iData13 );
					14 : tmpData = $signed( iData14 );
					15 : tmpData = $signed( iData15 );
					default : ;
				endcase
                $fdisplay(fid, "%d", tmpData);
			end // for
        end	// forever
    end // initial

endmodule // read_txtDataFile


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    