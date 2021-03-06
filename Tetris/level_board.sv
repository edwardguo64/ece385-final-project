module level_board(
    input logic reset,
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
    input logic [31:0] level,
    output logic lv_board_on,
    output logic [3:0]clr2
);

	//level conversion
    logic [4:0] ten = 10;
    logic [6:0] hundred = 100;
	 logic [4:0] hundred_digit, ten_digit, single_digit;
	
	 
    always_comb
    begin
        single_digit = level % ten;
        ten_digit = (level/ten) % ten;
        hundred_digit = (level/hundred) % ten;
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
	
	//Board
    logic levelboard;
    logic [9:0] levelboard_x = 475;
    logic [9:0] levelboard_size_x = 160;
    logic [9:0] levelboard_y = 170;
    logic [9:0] levelboard_size_y = 50;
	 //level letters
	 logic [9:0] level_letters_x = 475;
    logic [9:0] level_letters_size_x = 116;
    logic [9:0] level_letters_y = 170;
    logic [9:0] level_letters_size_y = 20;
    // score Numbers
    // Hundred_digit
    logic [9:0] hundred_x = 476;
    logic [9:0] hundred_size_x = 20;
    logic [9:0] hundred_y = 195;
    logic [9:0] hundred_size_y = 20;
    // Ten_digit
    logic [9:0] ten_x = 500;
    logic [9:0] ten_size_x = 20;
    logic [9:0] ten_y = 195;
    logic [9:0] ten_size_y = 20;
    // Single_digit
    logic [9:0] single_x = 524;
    logic [9:0] single_size_x = 20;
    logic [9:0] single_y = 195;
    logic [9:0] single_size_y = 20;	
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
		  offset_level_x = DrawX - level_letters_x;
        offset_level_y = DrawY - level_letters_y;
        offset_hun_x = DrawX - hundred_x;
        offset_hun_y = DrawY - hundred_y;
        offset_ten_x = DrawX - ten_x;
        offset_ten_y = DrawY - ten_y;
        offset_single_x = DrawX - single_x;
        offset_single_y = DrawY - single_y;
		
        di = 5'd4;
        color = 4'b0;
        lv_board_on = 1'b1;
		
		//level Drawing
		if ((DrawX >= levelboard_x) && (DrawX <= (levelboard_x + levelboard_size_x)) && 
            (DrawY >= levelboard_y) && (DrawY < (levelboard_y + levelboard_size_y)))
        begin
			lv_board_on = 1'b1;
			if ((DrawX >= level_letters_x) && (DrawX <= level_letters_x + level_letters_size_x) && 
                (DrawY >= level_letters_y) && (DrawY < (level_letters_y + level_letters_size_y)))
            begin
                color = level_letters[(offset_level_y - (offset_level_y % di))/di][(offset_level_x - (offset_level_x%di))/di];
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
		clr2 = color;
    end

endmodule