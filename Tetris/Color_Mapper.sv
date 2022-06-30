//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color_mapper(
	 //input logic [7:0] R, G, B,						 //clock for framebuffer
    input logic [3:0] pos_x,            // x position of the piece
    input logic [4:0] pos_y,            // y position of the piece
    
    input logic [2:0] piece_type,       // the piece type
    input logic [1:0] orientation,      // the current orientation
    
    input logic [9:0] DrawX,            // current x location being drawn
    input logic [9:0] DrawY,            // current y location being drawn
    
    input logic start_game,             // start game signal
    input logic end_game,               // end game signal
    
    input logic [31:0] board[19:0],     // unpacked array storing current state of the board
    input logic [31:0] score,           // current score
	input logic [31:0] level,           // current level
	input logic [31:0] line,            // current lines
    
    input logic [31:0] score1,          // high score 1
    input logic [31:0] score2,          // high score 2
    input logic [31:0] score3,          // high score 3
    
    input logic blank,                  // blank signal used to properly display colors
    
    output logic [7:0] Red,             // output red value
    output logic [7:0] Green,           // output green value
    output logic [7:0] Blue,            // output blue value
    output logic [23:0] dec_score       // output 6 digit decimal value for the score
);
    
    // signals to determine colors on display
    logic piece_on, board_on, board_back_on, border_on, scr_board_on,line_board_on, lv_board_on;
    
    // cell positions based on current piece and orientation
    logic [3:0] cell1_x, cell2_x, cell3_x;
    logic [4:0] cell1_y, cell2_y, cell3_y;
    
    // x and y values within board array to determine if the board is on
    int x, y;
    
    // the RGB values of the current piece
    logic [7:0] piece_r, piece_g, piece_b;
    
    tetromino_color piece_color(.piece_type, .Red(piece_r), .Green(piece_g), .Blue(piece_b));
    
    // determines the cell locations of the current piece
    current_blocks cur_cell(.*); 
	
    // signals to determine between letters and numbers for text display
    logic [3:0] clr0;
	logic [3:0] clr1;
	logic [3:0] clr2;

    // determines which text to display and values
    score_board scr_brd(.DrawX, .DrawY, .score, .scr_board_on, .clr0, .dec_score);	 
	 line_board	 line_brd(.DrawX, .DrawY, .line, .line_board_on, .clr1);
	 level_board lv_brd(.DrawX, .DrawY, .level, .lv_board_on, .clr2);

    // calculates x and y based on current DrawX and DrawY
    assign x = (424 - DrawX) / 20;
    assign y = (DrawY - 49) / 20;
	 
	 logic [3:0] clr3;
	 Start start(.DrawX, .DrawY, .clr3);
	 
	 logic [3:0] clr4;
	 End_Screen end_screen(.DrawX, .DrawY, .score, .clr4, .score1, .score2, .score3);
	 
	 /*
	 //Sprite for Game start and end
	 logic [7:0] R,G,B;
	
	 framebuffer StartEnd(.clk, .Game_Start(start_game), .Game_End(end_game), .DrawX, .DrawY, .R, .G, .B);
    */
    // determines the border around the board for visual purposes
	 
	 //tetris_sprite startScreen(.SpriteX(DrawX), .SpriteY(DrawY), .SpriteR(R), .SpriteG(G), .SpriteB(B));
	 
    always_comb
    begin
        border_on = 1'b0;
        if (DrawX <= 224 && DrawX > 214 &&
            DrawY >= 49 && DrawY < 449)
            border_on = 1'b1;
        else if (DrawX > 214 && DrawX <= 434 &&
            DrawY >= 449 && DrawY < 459)
            border_on = 1'b1;
        else if (DrawX <= 434 && DrawX > 424 &&
            DrawY >= 49 && DrawY < 449)
            border_on = 1'b1;
    end
    
    // determines if part of the tetromino is on the board
    always_comb
    begin
        piece_on = 1'b0;
        if (DrawX <= 424 - pos_x * 20 &&
            DrawX > 424 - (pos_x + 1) * 20 &&
            DrawY < 49 + (pos_y + 1) * 20 &&
            DrawY >= 49 + pos_y * 20)
        begin
            piece_on = 1'b1;
        end
        else if (DrawX <= 424 - cell1_x * 20 &&
            DrawX > 424 - (cell1_x + 1) * 20 &&
            DrawY < 49 + (cell1_y + 1) * 20 &&
            DrawY >= 49 + cell1_y * 20)
        begin
            piece_on = 1'b1;
        end
        else if (DrawX <= 424 - cell2_x * 20 &&
            DrawX > 424 - (cell2_x + 1) * 20 &&
            DrawY < 49 + (cell2_y + 1) * 20 &&
            DrawY >= 49 + cell2_y * 20)
        begin
            piece_on = 1'b1;
        end
        else if (DrawX <= 424 - cell3_x * 20 &&
            DrawX > 424 - (cell3_x + 1) * 20 &&
            DrawY < 49 + (cell3_y + 1) * 20 &&
            DrawY >= 49 + cell3_y * 20)
        begin
            piece_on = 1'b1;
        end
    end
    
    // determines if the board is on or not
    always_comb
    begin
        board_back_on = 1'b0;
        board_on = 1'b0;
        if (DrawX > 224 && DrawX < 425 && DrawY >= 49 && DrawY < 449)
        begin
            if (!board[y][x])
                board_back_on = 1'b1;
            else
                board_on = 1'b1;
        end
    end
    
    // based on current signals, display the screen
    always_comb
    begin
		Red = 8'h00;	//background
        Green = 8'h47;
        Blue = 8'ha0;
        
        // if blanking signal (active low) set to black to display colors properly
		  
        if (blank == 1'b0)
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        
        // display the end screen (game over and start again)
		else if(end_game == 1'b1)
		begin
            //display game end
			unique case (clr4)
                4'd0: // background
                begin
                    Red = 8'h02;
                    Green = 8'h16;
                    Blue = 8'h69;
                end
                4'd1: //Letters
                begin
                    Red = 8'hb2;
                    Green = 8'hff;
                    Blue = 8'h00;
                end
                4'd2:
                begin
                    Red = 8'hfc;
                    Green = 8'hab;
                    Blue = 8'h00;
                end
                4'd3:
                begin
                    Red = 8'hf8;
                    Green = 8'h03;
                    Blue = 8'haf;
                end
                4'd4:
                begin
                    Red = 8'ha3;
                    Green = 8'h00;
                    Blue = 8'hff;
                end
                4'd5:
                begin
                    Red = 8'h1f;
                    Green = 8'ha8;
                    Blue = 8'hff;
                end
                4'd9: //nums
                begin
                    Red = 8'hff;
                    Green = 8'hff;
                    Blue = 8'hff;
                end
                default :
                begin
                    Red = 8'hff;
                    Green = 8'hff;
                    Blue = 8'hff; 
                end
            endcase
		end
        
        // dispay the start screen (when start_game == 1'b1 the game would start and should display board)
		else if(start_game == 1'b0)
		begin
		    //display game start
			unique case (clr3)
                4'd0: // background
                begin
                    Red = 8'h02;
                    Green = 8'h16;
                    Blue = 8'h69;
                end
                4'd1: //Letters
                begin
                    Red = 8'hb2;
                    Green = 8'hff;
                    Blue = 8'h00;
                end
                4'd2:
                begin
                    Red = 8'hfc;
                    Green = 8'hab;
                    Blue = 8'h00;
                end
                4'd3:
                begin
                    Red = 8'hf8;
                    Green = 8'h03;
                    Blue = 8'haf;
                end
                4'd4:
                begin
                    Red = 8'ha3;
                    Green = 8'h00;
                    Blue = 8'hff;
                end
                4'd5:
                begin
                    Red = 8'h1f;
                    Green = 8'ha8;
                    Blue = 8'hff;
                end
                4'd9: //nums
                begin
                    Red = 8'hff;
                    Green = 8'hff;
                    Blue = 8'hff;
                end
                default : 
                begin
                    Red = 8'hff;
                    Green = 8'hff;
                    Blue = 8'hff;
                end
            endcase
		end
        
        // display the game
        else if (piece_on == 1'b1)
        begin
            Red = piece_r;
            Green = piece_g;
            Blue = piece_b;
        end
        else if (board_back_on == 1'b1)
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else if (board_on == 1'b1)
        begin
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		else if (border_on == 1'b1)
        begin
            Red = 8'h7f;
            Green = 8'h7f;
            Blue = 8'h7f;
        end
		else if (scr_board_on || line_board_on || lv_board_on)
        begin
            unique case (clr0)
                4'd1: //Letters
                    begin
                        Red = 8'h30;
                        Green = 8'hb0;
                        Blue = 8'hff;
                    end
                4'd9: //nums
                    begin
                        Red = 8'hff;
                        Green = 8'hff;
                        Blue = 8'hff;
                    end
                default : ;
            endcase
				unique case (clr1)
                4'd1: //Letters
                    begin
                        Red = 8'h30;
                        Green = 8'hb0;
                        Blue = 8'hff;
                    end
                4'd9: //nums
                    begin
                        Red = 8'hff;
                        Green = 8'hff;
                        Blue = 8'hff;
                    end
                default : ;
            endcase
				unique case (clr2)
                4'd1: //Letters
                    begin
                        Red = 8'h30;
                        Green = 8'hb0;
                        Blue = 8'hff;
                    end
                4'd9: //nums
                    begin
                        Red = 8'hff;
                        Green = 8'hff;
                        Blue = 8'hff;
                    end
                default : ;
            endcase
        end
    end

endmodule
