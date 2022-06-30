module  board ( input Reset, frame_clk,
					input [7:0] keycode,
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
    parameter [9:0] Piece_Y_Step=1;      // Step size on the Y axis

    assign Piece_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Piece
        if (Reset)  // Asynchronous Reset
        begin 
            Piece_Y_Motion <= 10'd1; //Piece_Y_Step;
				Piece_Y_Pos <= Piece_Y_Center;
				Piece_X_Pos <= Piece_X_Center;
        end
           
        else 
        begin 
				 if ( (Piece_Y_Pos + Piece_Size) >= Piece_Y_Max )  // Piece is at the bottom edge, STOP!
					  Piece_Y_Motion <= 0;  								// 2's complement
				 else 
					  Piece_Y_Motion <= Piece_Y_Motion;  // Piece is somewhere in the middle, don't bounce, just keep moving
					  
				 
				 case (keycode)
					8'h04 : begin
								Piece_X_Pos   <= Piece_X_Pos - 10'd10;//A
								Piece_Y_Motion<= 0;
							  end
					        
					8'h07 : begin
								
					        Piece_X_Pos <= Piece_X_Pos + 10'd10;//D
							  Piece_Y_Motion <= 0;
							  end

							  
					8'h16 : begin

					        Piece_Y_Motion <= 1;//S
							 end
							  
//					8'h1A : begin
//					        Piece_Y_Motion <= -1;//W
//							  Piece_X_Motion <= 0;
//							 end	  
					default: ;
			   endcase
				 
				 Piece_Y_Pos <= (Piece_Y_Pos + Piece_Y_Motion);  // Update Piece position
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Piece_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Piece_Y_pos.  Will the new value of Piece_Y_Motion be used,
          or the old?  How will this impact behavior of the Piece during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign PieceX = Piece_X_Pos;
   
    assign PieceY = Piece_Y_Pos;
   
    assign PieceS = Piece_Size;
    

endmodule
