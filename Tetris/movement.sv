/This module will make movements in both the registers and the display.
//It will output the VGA signals based on the registers, rotation value, and type of the piece.

module  movement( input Reset, clk,
					input [7:0] keycode,
					input [3:0] rot, tp,
					input [31:0] Board[20],
               output [9:0]  PieceX, PieceY, PieceS);

					
	 logic [9:0] Piece_X_Pos, Piece_X_Motion, Piece_Y_Pos, Piece_Y_Motion, Piece_Size;
	 
	 //the piece center is right top corner of block.
	 
    parameter [9:0] Piece_X_Center=315;  // Center position on the X axis
    parameter [9:0] Piece_Y_Center=79;  // Center position on the Y axis
    parameter [9:0] Piece_X_Min=224;       // Leftmost point on the X axis
    parameter [9:0] Piece_X_Max=424;     // Rightmost point on the X axis
    parameter [9:0] Piece_Y_Min=49;       // Topmost point on the Y axis
    parameter [9:0] Piece_Y_Max=449;     // Bottommost point on the Y axis
    parameter [9:0] Piece_X_Step=10;      // Step size on the X axis
    parameter [9:0] Piece_Y_Step=10;      // Step size on the Y axis
	 
	logic [31:0] myREG[20];
    logic loc;
	logic [9:0] xloc, yloc;
	logic [3:0] myRot, myType;
	
	//Each piece center starts at reg[0][5]
	
	assign myRot = rot;
	assign myTp  = tp;
	assign myREG = Board;
    assign Piece_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	always_ff @ (posedge Reset or posedge clk )
    begin: Move_Piece
			if(xloc == 10) //increment y at the col max.
				begin
					xloc <= 0;
					yloc <= yloc + 1;
				end
			
			//get the value of register.
			if(myREG[xloc][yloc] == 1)	begin
				loc <= 1;
			end
			
			//movement of cells.
			//set movements based on the cells
			xloc <= xloc + 1;
			
			
			//Unsure of the fuctionality in always_ff
			/*
			for(int i = 0, i < 20, i = i + 1) begin
				for(int j = 0, j < 10, j = j + 1) begin
					if(myREG[i][j] == 1)
						loc <= 1;
				end
			end
			*/
		 
		 
	 end
	
   
endmodule