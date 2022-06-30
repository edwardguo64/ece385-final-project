module score_board(
    input logic reset,
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
    input logic [31:0] score,
    output logic scr_board_on,
    output logic [3:0]clr0,
    output logic [23:0] dec_score
);

	//score conversion
    logic [4:0] ten = 10;
    logic [6:0] hundred = 100;
    logic [10:0] thousand = 1000;
    logic [14:0] ten_thousand = 10000;
    logic [17:0] hundred_thousand = 100000;
	 logic [4:0] hundred_thousand_digit, ten_thousand_digit, thousand_digit, hundred_digit, ten_digit, single_digit;
	
	 
    always_comb
    begin
        single_digit = score % ten;
        ten_digit = (score/ten) % ten;
        hundred_digit = (score/hundred) % ten;
        thousand_digit = (score/thousand) % ten;
        ten_thousand_digit = (score/ten_thousand) % ten;
        hundred_thousand_digit = (score/hundred_thousand) % ten;
    end

    logic [4:0][28:0][3:0] score_letters;
	logic [4:0][28:0][3:0] level_letters;
	logic [4:0][22:0][3:0] line_letters;
    logic [4:0][4:0][3:0] zero;
    logic [4:0][4:0][3:0] one;
    logic [4:0][4:0][3:0] two;
    logic [4:0][4:0][3:0] three;
    logic [4:0][4:0][3:0] four;
    logic [4:0][4:0][3:0] five;
    logic [4:0][4:0][3:0] six;
    logic [4:0][4:0][3:0] seven;
    logic [4:0][4:0][3:0] eight;
    logic [4:0][4:0][3:0] nine;	 	 
    logic [3:0] color;
	logic [13:0][57:0][3:0] Game_Start;
	logic [13:0][78:0][3:0] gameover_text;
    logic [4:0][90:0][3:0] press_start;
    logic [4:0][112:0][3:0] play_again;
    logic [4:0][46:0][3:0] high_score;
    logic [4:0][46:0][3:0] your_score;
	 
	//scoreBoard
    logic scoreboard;
    logic [9:0] scoreboard_x = 475;
    logic [9:0] scoreboard_size_x = 160;
    logic [9:0] scoreboard_y = 50;
    logic [9:0] scoreboard_size_y = 50;
	 //level letters
	 logic [9:0] level_letters_x = 475;
    logic [9:0] level_letters_size_x = 116;
    logic [9:0] level_letters_y = 150;
    logic [9:0] level_letters_size_y = 20;
	 //line letters
	 logic [9:0] line_letters_x = 475;
    logic [9:0] line_letters_size_x = 116;
    logic [9:0] line_letters_y = 100;
    logic [9:0] line_letters_size_y = 20;
    // score letters:
    logic [9:0] score_letters_x = 475;
    logic [9:0] score_letters_size_x = 116;
    logic [9:0] score_letters_y = 50;
    logic [9:0] score_letters_size_y = 20;
    // score Numbers
    // Hundred Thousand digit
    logic [9:0] hundred_thousand_x = 476 ;
    logic [9:0] hundred_thousand_size_x = 20;
    logic [9:0] hundred_thousand_y = 75;
    logic [9:0] hundred_thousand_size_y = 20;
    // Ten Thousand digit
    logic [9:0] ten_thousand_x = 500;
    logic [9:0] ten_thousand_size_x = 20;
    logic [9:0] ten_thousand_y = 75;
    logic [9:0] ten_thousand_size_y = 20;
    // Thousand_digit
    logic [9:0] thousand_x = 524;
    logic [9:0] thousand_size_x = 20;
    logic [9:0] thousand_y = 75;
    logic [9:0] thousand_size_y = 20;
    // Hundred_digit
    logic [9:0] hundred_x = 548;
    logic [9:0] hundred_size_x = 20;
    logic [9:0] hundred_y = 75;
    logic [9:0] hundred_size_y = 20;
    // Ten_digit
    logic [9:0] ten_x = 572;
    logic [9:0] ten_size_x = 20;
    logic [9:0] ten_y = 75;
    logic [9:0] ten_size_y = 20;
    // Single_digit
    logic [9:0] single_x = 596;
    logic [9:0] single_size_x = 20;
    logic [9:0] single_y = 75;
    logic [9:0] single_size_y = 20;	

    //TETRIS String
    logic [9:0] tetris_x = 420;
    logic [9:0] tetris_y = 100;
    logic [9:0] tetris_x2 = 200;
    logic [9:0] tetris_y2 = 100;
    logic [9:0] tetris_xh = 40;
    logic [9:0] tetris_yh = 100;
    logic [9:0] tetris_size_x = 40;
    logic [9:0] tetris_size_y = 320;
    logic [9:0] tetris_size_xh = 520;
    logic [9:0] tetris_size_yh = 150;
    Sprite Sp(.*);

    logic [9:0] offset_score_x, offset_score_y, offset_level_x, offset_level_y,
					 offset_line_x, offset_line_y, offset_thou_x, offset_thou_y, 
                offset_hun_x, offset_hun_y, offset_ten_x, offset_ten_y, 
                offset_single_x, offset_single_y, offset_x_go, offset_y_go,
                offset_ten_thou_x, offset_ten_thou_y, offset_hun_thou_x, offset_hun_thou_y;
    logic [4:0] di;
	 
	 
	 
    always_comb
    begin
		// score
        offset_score_x = DrawX - score_letters_x;
        offset_score_y = DrawY - score_letters_y;
		  offset_level_x = DrawX - level_letters_x;
        offset_level_y = DrawY - level_letters_y;
        offset_hun_thou_x = DrawX - hundred_thousand_x;
        offset_hun_thou_y = DrawY - hundred_thousand_y;
        offset_ten_thou_x = DrawX - ten_thousand_x;
        offset_ten_thou_y = DrawY - ten_thousand_y;
        offset_thou_x = DrawX - thousand_x;
        offset_thou_y = DrawY - thousand_y;
        offset_hun_x = DrawX - hundred_x;
        offset_hun_y = DrawY - hundred_y;
        offset_ten_x = DrawX - ten_x;
        offset_ten_y = DrawY - ten_y;
        offset_single_x = DrawX - single_x;
        offset_single_y = DrawY - single_y;
		
        di = 5'd4;
        color = 4'b0;
        scr_board_on = 1'b1;
		
		//level Drawing
	 
		//score Drawing
		if ((DrawX >= scoreboard_x) && (DrawX <= (scoreboard_x + scoreboard_size_x)) && 
            (DrawY >= scoreboard_y) && (DrawY < (scoreboard_y + scoreboard_size_y)))
        begin
			scr_board_on = 1'b1;
			if ((DrawX >= score_letters_x) && (DrawX <= score_letters_x + score_letters_size_x) && 
                (DrawY >= score_letters_y) && (DrawY < (score_letters_y + score_letters_size_y)))
            begin
                color = score_letters[(offset_score_y - (offset_score_y % di))/di][(offset_score_x - (offset_score_x%di))/di];
            end
            else if ((DrawX >= hundred_thousand_x) && (DrawX <= (hundred_thousand_x + hundred_thousand_size_x)) && 
                (DrawY >= hundred_thousand_y) && (DrawY < (hundred_thousand_y + hundred_thousand_size_y)))
            begin
                unique case(hundred_thousand_digit)
                    5'd0: color = zero[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd1: color = one[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 			
                    5'd2: color = two[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd3: color = three[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd4: color = four[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd5: color = five[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd6: color = six[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd7: color = seven[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd8: color = eight[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
                    5'd9: color = nine[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di];
                    default : ;	
                endcase
            end
            else if ((DrawX >= ten_thousand_x) && (DrawX <= (ten_thousand_x + ten_thousand_size_x)) && 
                (DrawY >= ten_thousand_y) && (DrawY < (ten_thousand_y + ten_thousand_size_y)))
            begin
                unique case(ten_thousand_digit)
                    5'd0: color = zero[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd1: color = one[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 			
                    5'd2: color = two[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd3: color = three[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd4: color = four[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd5: color = five[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd6: color = six[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd7: color = seven[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd8: color = eight[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
                    5'd9: color = nine[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di];
                    default : ;	
                endcase
            end
            else if ((DrawX >= thousand_x) && (DrawX <= (thousand_x + thousand_size_x)) && 
                (DrawY >= thousand_y) && (DrawY < (thousand_y + thousand_size_y)))
            begin
                unique case(thousand_digit)
                    5'd0: color = zero[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd1: color = one[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 			
                    5'd2: color = two[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd3: color = three[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd4: color = four[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd5: color = five[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd6: color = six[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd7: color = seven[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd8: color = eight[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
                    5'd9: color = nine[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di];
                    default : ;	
                endcase
            end
            // Hundred_digit
            else if ((DrawX >= hundred_x) && (DrawX <= (hundred_x + hundred_size_x)) && 
                (DrawY >= hundred_y) && (DrawY < (hundred_y + hundred_size_y)))
            begin
                unique case(hundred_digit)
                    5'd0: color = zero[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd1: color = one[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 		
                    5'd2: color = two[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd3: color = three[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd4: color = four[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd5: color = five[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd6: color = six[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd7: color = seven[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd8: color = eight[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    5'd9: color = nine[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
                    default : ;	
                endcase
            end	
            // Ten_digit
            else if ((DrawX >= ten_x) && (DrawX <= (ten_x + ten_size_x)) && 
                (DrawY >= ten_y) && (DrawY < (ten_y + ten_size_y)))
            begin
                unique case(ten_digit)
                    5'd0: color = zero[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd1: color = one[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 		
                    5'd2: color = two[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd3: color = three[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd4: color = four[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd5: color = five[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd6: color = six[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd7: color = seven[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd8: color = eight[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    5'd9: color = nine[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
                    default : ;	
                endcase
            end	
            // Single_digit
            else if ((DrawX >= single_x) && (DrawX <= (single_x + single_size_x)) && 
                (DrawY >= single_y) && (DrawY < (single_y + single_size_y)))
            begin
                unique case(single_digit)
                    5'd0: color = zero[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd1: color = one[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 					
                    5'd2: color = two[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd3: color = three[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd4: color = four[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd5: color = five[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd6: color = six[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd7: color = seven[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd8: color = eight[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    5'd9: color = nine[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
                    default : ;	
                endcase
            end
		end
		clr0 = color;
    end
    
    assign dec_score = {hundred_thousand_digit[3:0], ten_thousand_digit[3:0], thousand_digit[3:0],
        hundred_digit[3:0], ten_digit[3:0], single_digit[3:0]};

endmodule