module End_Screen(
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
	input logic [31:0] score,
    input logic [31:0] score1,
    input logic [31:0] score2,
    input logic [31:0] score3,
    output logic [3:0] clr4
);

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
	
	
	Sprite Sp(.*);
	

//	logic[9:0] gameover_x = 320; 
//	logic[9:0] gameover_y = 220;
//	logic[9:0] gameover_size_x = 10'd79;
//	logic[9:0] gameover_size_y = 10'd14;
	
	//score conversion
    logic [4:0] ten = 10;
    logic [6:0] hundred = 100;
    logic [10:0] thousand = 1000;
    logic [14:0] ten_thousand = 10000;
    logic [17:0] hundred_thousand = 100000;
	logic [4:0] hundred_thousand_digit, ten_thousand_digit, thousand_digit, hundred_digit, ten_digit, single_digit;
    
    logic [4:0] hundred_thousand_digit1, ten_thousand_digit1, thousand_digit1, hundred_digit1, ten_digit1, single_digit1;
    logic [4:0] hundred_thousand_digit2, ten_thousand_digit2, thousand_digit2, hundred_digit2, ten_digit2, single_digit2;
    logic [4:0] hundred_thousand_digit3, ten_thousand_digit3, thousand_digit3, hundred_digit3, ten_digit3, single_digit3;
	
    always_comb
    begin
        single_digit1 = score1 % ten;
        ten_digit1 = (score1/ten) % ten;
        hundred_digit1 = (score1/hundred) % ten;
        thousand_digit1 = (score1/thousand) % ten;
        ten_thousand_digit1 = (score1/ten_thousand) % ten;
        hundred_thousand_digit1 = (score1/hundred_thousand) % ten;
    end

    always_comb
    begin
        single_digit2 = score2 % ten;
        ten_digit2 = (score2/ten) % ten;
        hundred_digit2 = (score2/hundred) % ten;
        thousand_digit2 = (score2/thousand) % ten;
        ten_thousand_digit2 = (score2/ten_thousand) % ten;
        hundred_thousand_digit2 = (score2/hundred_thousand) % ten;
    end
	
    always_comb
    begin
        single_digit3 = score3 % ten;
        ten_digit3 = (score3/ten) % ten;
        hundred_digit3 = (score3/hundred) % ten;
        thousand_digit3 = (score3/thousand) % ten;
        ten_thousand_digit3 = (score3/ten_thousand) % ten;
        hundred_thousand_digit3 = (score3/hundred_thousand) % ten;
    end
    
    always_comb
    begin
        single_digit = score % ten;
        ten_digit = (score/ten) % ten;
        hundred_digit = (score/hundred) % ten;
        thousand_digit = (score/thousand) % ten;
        ten_thousand_digit = (score/ten_thousand) % ten;
        hundred_thousand_digit = (score/hundred_thousand) % ten;
    end
    
//    // score letters:
//    logic [9:0] score_letters_x = 475;
//    logic [9:0] score_letters_size_x = 116;
//    logic [9:0] score_letters_y = 50;
//    logic [9:0] score_letters_size_y = 20;
//    // score Numbers
//    // Hundred Thousand digit
//    logic [9:0] hundred_thousand_x = 476 ;
//    logic [9:0] hundred_thousand_size_x = 20;
//    logic [9:0] hundred_thousand_y = 75;
//    logic [9:0] hundred_thousand_size_y = 20;
//    // Ten Thousand digit
//    logic [9:0] ten_thousand_x = 500;
//    logic [9:0] ten_thousand_size_x = 20;
//    logic [9:0] ten_thousand_y = 75;
//    logic [9:0] ten_thousand_size_y = 20;
//    // Thousand_digit
//    logic [9:0] thousand_x = 524;
//    logic [9:0] thousand_size_x = 20;
//    logic [9:0] thousand_y = 75;
//    logic [9:0] thousand_size_y = 20;
//    // Hundred_digit
//    logic [9:0] hundred_x = 548;
//    logic [9:0] hundred_size_x = 20;
//    logic [9:0] hundred_y = 75;
//    logic [9:0] hundred_size_y = 20;
//    // Ten_digit
//    logic [9:0] ten_x = 572;
//    logic [9:0] ten_size_x = 20;
//    logic [9:0] ten_y = 75;
//    logic [9:0] ten_size_y = 20;
//    // Single_digit
//    logic [9:0] single_x = 596;
//    logic [9:0] single_size_x = 20;
//    logic [9:0] single_y = 75;
//    logic [9:0] single_size_y = 20;	
//
//    
//
//    logic [9:0] offset_score_x, offset_score_y, offset_level_x, offset_level_y,
//					 offset_line_x, offset_line_y, offset_thou_x, offset_thou_y, 
//                offset_hun_x, offset_hun_y, offset_ten_x, offset_ten_y, 
//                offset_single_x, offset_single_y, offset_x_go, offset_y_go,
//                offset_ten_thou_x, offset_ten_thou_y, offset_hun_thou_x, offset_hun_thou_y;
//    logic [4:0] di;
	
	int xg, yg, xh, yh, xp, yp, xy, yy;
    int xa, ya, xb, yb, xc, yc, xd, yd;
    int x01, y01, x02, y02, x03, y03, x0s, y0s;
    int x11, y11, x12, y12, x13, y13, x1s, y1s;
    int x21, y21, x22, y22, x23, y23, x2s, y2s;
    int x31, y31, x32, y32, x33, y33, x3s, y3s;
    int x41, y41, x42, y42, x43, y43, x4s, y4s;
    int x51, y51, x52, y52, x53, y53, x5s, y5s;
    
    assign xg = (477 - DrawX) / 4;
    assign yg = (80 - DrawY) / 4;
    
    assign xh = (413 - DrawX) / 4;
    assign yh = (149 - DrawY) / 4;
    
    assign xa = (DrawX - 160) / 3;
    assign ya = (DrawY - 165) / 3;
    
    assign xb = (DrawX - 160) / 3;
    assign yb = (DrawY - 185) / 3;
    
    assign xc = (DrawX - 160) / 3;
    assign yc = (DrawY - 205) / 3;
    
    assign x01 = (DrawX - 460) / 3;
    assign x11 = (DrawX - 439) / 3;
    assign x21 = (DrawX - 418) / 3;
    assign x31 = (DrawX - 397) / 3;
    assign x41 = (DrawX - 376) / 3;
    assign x51 = (DrawX - 355) / 3;
    
    assign y01 = (DrawY - 165) / 3;
    assign y11 = (DrawY - 165) / 3;
    assign y21 = (DrawY - 165) / 3;
    assign y31 = (DrawY - 165) / 3;
    assign y41 = (DrawY - 165) / 3;
    assign y51 = (DrawY - 165) / 3;
    
    assign x02 = (DrawX - 460) / 3;
    assign x12 = (DrawX - 439) / 3;
    assign x22 = (DrawX - 418) / 3;
    assign x32 = (DrawX - 397) / 3;
    assign x42 = (DrawX - 376) / 3;
    assign x52 = (DrawX - 355) / 3;
    
    assign y02 = (DrawY - 185) / 3;
    assign y12 = (DrawY - 185) / 3;
    assign y22 = (DrawY - 185) / 3;
    assign y32 = (DrawY - 185) / 3;
    assign y42 = (DrawY - 185) / 3;
    assign y52 = (DrawY - 185) / 3;
    
    assign x03 = (DrawX - 460) / 3;
    assign x13 = (DrawX - 439) / 3;
    assign x23 = (DrawX - 418) / 3;
    assign x33 = (DrawX - 397) / 3;
    assign x43 = (DrawX - 376) / 3;
    assign x53 = (DrawX - 355) / 3;
    
    assign y03 = (DrawY - 205) / 3;
    assign y13 = (DrawY - 205) / 3;
    assign y23 = (DrawY - 205) / 3;
    assign y33 = (DrawY - 205) / 3;
    assign y43 = (DrawY - 205) / 3;
    assign y53 = (DrawY - 205) / 3;
    
    assign xy = (300 - DrawX) / 3;
    assign yy = (269 - DrawY) / 3;
    
    assign x0s = (DrawX - 460) / 3;
    assign x1s = (DrawX - 439) / 3;
    assign x2s = (DrawX - 418) / 3;
    assign x3s = (DrawX - 397) / 3;
    assign x4s = (DrawX - 376) / 3;
    assign x5s = (DrawX - 355) / 3;
    
    assign y0s = (DrawY - 255) / 3;
    assign y1s = (DrawY - 255) / 3;
    assign y2s = (DrawY - 255) / 3;
    assign y3s = (DrawY - 255) / 3;
    assign y4s = (DrawY - 255) / 3;
    assign y5s = (DrawY - 255) / 3;
    
    assign xp = (432 - DrawX) / 2;
    assign yp = (314 - DrawY) / 2;
	
    always_comb
    begin
//		// score
//        offset_score_x = DrawX - score_letters_x;
//        offset_score_y = DrawY - score_letters_y;
//        offset_hun_thou_x = DrawX - hundred_thousand_x;
//        offset_hun_thou_y = DrawY - hundred_thousand_y;
//        offset_ten_thou_x = DrawX - ten_thousand_x;
//        offset_ten_thou_y = DrawY - ten_thousand_y;
//        offset_thou_x = DrawX - thousand_x;
//        offset_thou_y = DrawY - thousand_y;
//        offset_hun_x = DrawX - hundred_x;
//        offset_hun_y = DrawY - hundred_y;
//        offset_ten_x = DrawX - ten_x;
//        offset_ten_y = DrawY - ten_y;
//        offset_single_x = DrawX - single_x;
//        offset_single_y = DrawY - single_y;
//		
//        di = 5'd4;
        color = 4'b0;
		
	 
//    if (((DrawX >= gameover_x) && (DrawX <= gameover_x + gameover_size_x) 
//    && (DrawY >= gameover_y) &&(DrawY <= gameover_y +gameover_size_y)))
//     begin
//     clr4 = gameover_text[DrawY-gameover_y][DrawX-gameover_x];
//     end
        
        if (DrawX >= 162 && DrawX < 478 && DrawY >= 25 && DrawY < 81)
            color = gameover_text[yg][xg];
        else if (DrawX >= 226 && DrawX < 414 && DrawY >= 130 && DrawY < 150)
            color = high_score[yh][xh];
        
        else if (DrawX >= 160 && DrawX < 175 && DrawY >= 165 && DrawY < 180)
            color = one[ya][xa];
        else if (DrawX >= 160 && DrawX < 175 && DrawY >= 185 && DrawY < 200)
            color = two[yb][xb];
        else if (DrawX >= 160 && DrawX < 175 && DrawY >= 205 && DrawY < 220)
            color = three[yc][xc];
        
        else if (DrawX >= 460 && DrawX < 475 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (single_digit1)
                5'd0 : color = zero[y01][x01];
                5'd1 : color = one[y01][x01];
                5'd2 : color = two[y01][x01];
                5'd3 : color = three[y01][x01];
                5'd4 : color = four[y01][x01];
                5'd5 : color = five[y01][x01];
                5'd6 : color = six[y01][x01];
                5'd7 : color = seven[y01][x01];
                5'd8 : color = eight[y01][x01];
                5'd9 : color = nine[y01][x01];
                default : ;
            endcase
        end
        else if (DrawX >= 439 && DrawX < 454 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (ten_digit1)
                5'd0 : color = zero[y11][x11];
                5'd1 : color = one[y11][x11];
                5'd2 : color = two[y11][x11];
                5'd3 : color = three[y11][x11];
                5'd4 : color = four[y11][x11];
                5'd5 : color = five[y11][x11];
                5'd6 : color = six[y11][x11];
                5'd7 : color = seven[y11][x11];
                5'd8 : color = eight[y11][x11];
                5'd9 : color = nine[y11][x11];
                default : ;
            endcase
        end
        else if (DrawX >= 418 && DrawX < 433 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (hundred_digit1)
                5'd0 : color = zero[y21][x21];
                5'd1 : color = one[y21][x21];
                5'd2 : color = two[y21][x21];
                5'd3 : color = three[y21][x21];
                5'd4 : color = four[y21][x21];
                5'd5 : color = five[y21][x21];
                5'd6 : color = six[y21][x21];
                5'd7 : color = seven[y21][x21];
                5'd8 : color = eight[y21][x21];
                5'd9 : color = nine[y21][x21];
                default : ;
            endcase
        end
        else if (DrawX >= 397 && DrawX < 412 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (thousand_digit1)
                5'd0 : color = zero[y31][x31];
                5'd1 : color = one[y31][x31];
                5'd2 : color = two[y31][x31];
                5'd3 : color = three[y31][x31];
                5'd4 : color = four[y31][x31];
                5'd5 : color = five[y31][x31];
                5'd6 : color = six[y31][x31];
                5'd7 : color = seven[y31][x31];
                5'd8 : color = eight[y31][x31];
                5'd9 : color = nine[y31][x31];
                default : ;
            endcase
        end
        else if (DrawX >= 376 && DrawX < 391 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (ten_thousand_digit1)
                5'd0 : color = zero[y41][x41];
                5'd1 : color = one[y41][x41];
                5'd2 : color = two[y41][x41];
                5'd3 : color = three[y41][x41];
                5'd4 : color = four[y41][x41];
                5'd5 : color = five[y41][x41];
                5'd6 : color = six[y41][x41];
                5'd7 : color = seven[y41][x41];
                5'd8 : color = eight[y41][x41];
                5'd9 : color = nine[y41][x41];
                default : ;
            endcase
        end
        else if (DrawX >= 355 && DrawX < 370 && DrawY >= 165 && DrawY < 180)
        begin
            unique case (hundred_thousand_digit1)
                5'd0 : color = zero[y51][x51];
                5'd1 : color = one[y51][x51];
                5'd2 : color = two[y51][x51];
                5'd3 : color = three[y51][x51];
                5'd4 : color = four[y51][x51];
                5'd5 : color = five[y51][x51];
                5'd6 : color = six[y51][x51];
                5'd7 : color = seven[y51][x51];
                5'd8 : color = eight[y51][x51];
                5'd9 : color = nine[y51][x51];
                default : ;
            endcase
        end
        
        else if (DrawX >= 460 && DrawX < 475 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (single_digit2)
                5'd0 : color = zero[y02][x02];
                5'd1 : color = one[y02][x02];
                5'd2 : color = two[y02][x02];
                5'd3 : color = three[y02][x02];
                5'd4 : color = four[y02][x02];
                5'd5 : color = five[y02][x02];
                5'd6 : color = six[y02][x02];
                5'd7 : color = seven[y02][x02];
                5'd8 : color = eight[y02][x02];
                5'd9 : color = nine[y02][x02];
                default : ;
            endcase
        end
        else if (DrawX >= 439 && DrawX < 454 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (ten_digit2)
                5'd0 : color = zero[y12][x12];
                5'd1 : color = one[y12][x12];
                5'd2 : color = two[y12][x12];
                5'd3 : color = three[y12][x12];
                5'd4 : color = four[y12][x12];
                5'd5 : color = five[y12][x12];
                5'd6 : color = six[y12][x12];
                5'd7 : color = seven[y12][x12];
                5'd8 : color = eight[y12][x12];
                5'd9 : color = nine[y12][x12];
                default : ;
            endcase
        end
        else if (DrawX >= 418 && DrawX < 433 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (hundred_digit2)
                5'd0 : color = zero[y22][x22];
                5'd1 : color = one[y22][x22];
                5'd2 : color = two[y22][x22];
                5'd3 : color = three[y22][x22];
                5'd4 : color = four[y22][x22];
                5'd5 : color = five[y22][x22];
                5'd6 : color = six[y22][x22];
                5'd7 : color = seven[y22][x22];
                5'd8 : color = eight[y22][x22];
                5'd9 : color = nine[y22][x22];
                default : ;
            endcase
        end
        else if (DrawX >= 397 && DrawX < 412 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (thousand_digit2)
                5'd0 : color = zero[y32][x32];
                5'd1 : color = one[y32][x32];
                5'd2 : color = two[y32][x32];
                5'd3 : color = three[y32][x32];
                5'd4 : color = four[y32][x32];
                5'd5 : color = five[y32][x32];
                5'd6 : color = six[y32][x32];
                5'd7 : color = seven[y32][x32];
                5'd8 : color = eight[y32][x32];
                5'd9 : color = nine[y32][x32];
                default : ;
            endcase
        end
        else if (DrawX >= 376 && DrawX < 391 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (ten_thousand_digit2)
                5'd0 : color = zero[y42][x42];
                5'd1 : color = one[y42][x42];
                5'd2 : color = two[y42][x42];
                5'd3 : color = three[y42][x42];
                5'd4 : color = four[y42][x42];
                5'd5 : color = five[y42][x42];
                5'd6 : color = six[y42][x42];
                5'd7 : color = seven[y42][x42];
                5'd8 : color = eight[y42][x42];
                5'd9 : color = nine[y42][x42];
                default : ;
            endcase
        end
        else if (DrawX >= 355 && DrawX < 370 && DrawY >= 185 && DrawY < 200)
        begin
            unique case (hundred_thousand_digit2)
                5'd0 : color = zero[y52][x52];
                5'd1 : color = one[y52][x52];
                5'd2 : color = two[y52][x52];
                5'd3 : color = three[y52][x52];
                5'd4 : color = four[y52][x52];
                5'd5 : color = five[y52][x52];
                5'd6 : color = six[y52][x52];
                5'd7 : color = seven[y52][x52];
                5'd8 : color = eight[y52][x52];
                5'd9 : color = nine[y52][x52];
                default : ;
            endcase
        end
        
        else if (DrawX >= 460 && DrawX < 475 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (single_digit3)
                5'd0 : color = zero[y03][x03];
                5'd1 : color = one[y03][x03];
                5'd2 : color = two[y03][x03];
                5'd3 : color = three[y03][x03];
                5'd4 : color = four[y03][x03];
                5'd5 : color = five[y03][x03];
                5'd6 : color = six[y03][x03];
                5'd7 : color = seven[y03][x03];
                5'd8 : color = eight[y03][x03];
                5'd9 : color = nine[y03][x03];
                default : ;
            endcase
        end
        else if (DrawX >= 439 && DrawX < 454 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (ten_digit3)
                5'd0 : color = zero[y13][x13];
                5'd1 : color = one[y13][x13];
                5'd2 : color = two[y13][x13];
                5'd3 : color = three[y13][x13];
                5'd4 : color = four[y13][x13];
                5'd5 : color = five[y13][x13];
                5'd6 : color = six[y13][x13];
                5'd7 : color = seven[y13][x13];
                5'd8 : color = eight[y13][x13];
                5'd9 : color = nine[y13][x13];
                default : ;
            endcase
        end
        else if (DrawX >= 418 && DrawX < 433 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (hundred_digit3)
                5'd0 : color = zero[y23][x23];
                5'd1 : color = one[y23][x23];
                5'd2 : color = two[y23][x23];
                5'd3 : color = three[y23][x23];
                5'd4 : color = four[y23][x23];
                5'd5 : color = five[y23][x23];
                5'd6 : color = six[y23][x23];
                5'd7 : color = seven[y23][x23];
                5'd8 : color = eight[y23][x23];
                5'd9 : color = nine[y23][x23];
                default : ;
            endcase
        end
        else if (DrawX >= 397 && DrawX < 412 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (thousand_digit3)
                5'd0 : color = zero[y33][x33];
                5'd1 : color = one[y33][x33];
                5'd2 : color = two[y33][x33];
                5'd3 : color = three[y33][x33];
                5'd4 : color = four[y33][x33];
                5'd5 : color = five[y33][x33];
                5'd6 : color = six[y33][x33];
                5'd7 : color = seven[y33][x33];
                5'd8 : color = eight[y33][x33];
                5'd9 : color = nine[y33][x33];
                default : ;
            endcase
        end
        else if (DrawX >= 376 && DrawX < 391 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (ten_thousand_digit3)
                5'd0 : color = zero[y43][x43];
                5'd1 : color = one[y43][x43];
                5'd2 : color = two[y43][x43];
                5'd3 : color = three[y43][x43];
                5'd4 : color = four[y43][x43];
                5'd5 : color = five[y43][x43];
                5'd6 : color = six[y43][x43];
                5'd7 : color = seven[y43][x43];
                5'd8 : color = eight[y43][x43];
                5'd9 : color = nine[y43][x43];
                default : ;
            endcase
        end
        else if (DrawX >= 355 && DrawX < 370 && DrawY >= 205 && DrawY < 220)
        begin
            unique case (hundred_thousand_digit3)
                5'd0 : color = zero[y53][x53];
                5'd1 : color = one[y53][x53];
                5'd2 : color = two[y53][x53];
                5'd3 : color = three[y53][x53];
                5'd4 : color = four[y53][x53];
                5'd5 : color = five[y53][x53];
                5'd6 : color = six[y53][x53];
                5'd7 : color = seven[y53][x53];
                5'd8 : color = eight[y53][x53];
                5'd9 : color = nine[y53][x53];
                default : ;
            endcase
        end
        
        else if (DrawX >= 160 && DrawX < 301 && DrawY >= 255 && DrawY < 270)
            color = your_score[yy][xy];
            
        else if (DrawX >= 460 && DrawX < 475 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (single_digit)
                5'd0 : color = zero[y0s][x0s];
                5'd1 : color = one[y0s][x0s];
                5'd2 : color = two[y0s][x0s];
                5'd3 : color = three[y0s][x0s];
                5'd4 : color = four[y0s][x0s];
                5'd5 : color = five[y0s][x0s];
                5'd6 : color = six[y0s][x0s];
                5'd7 : color = seven[y0s][x0s];
                5'd8 : color = eight[y0s][x0s];
                5'd9 : color = nine[y0s][x0s];
                default : ;
            endcase
        end
        else if (DrawX >= 439 && DrawX < 454 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (ten_digit)
                5'd0 : color = zero[y1s][x1s];
                5'd1 : color = one[y1s][x1s];
                5'd2 : color = two[y1s][x1s];
                5'd3 : color = three[y1s][x1s];
                5'd4 : color = four[y1s][x1s];
                5'd5 : color = five[y1s][x1s];
                5'd6 : color = six[y1s][x1s];
                5'd7 : color = seven[y1s][x1s];
                5'd8 : color = eight[y1s][x1s];
                5'd9 : color = nine[y1s][x1s];
                default : ;
            endcase
        end
        else if (DrawX >= 418 && DrawX < 433 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (hundred_digit)
                5'd0 : color = zero[y2s][x2s];
                5'd1 : color = one[y2s][x2s];
                5'd2 : color = two[y2s][x2s];
                5'd3 : color = three[y2s][x2s];
                5'd4 : color = four[y2s][x2s];
                5'd5 : color = five[y2s][x2s];
                5'd6 : color = six[y2s][x2s];
                5'd7 : color = seven[y2s][x2s];
                5'd8 : color = eight[y2s][x2s];
                5'd9 : color = nine[y2s][x2s];
                default : ;
            endcase
        end
        else if (DrawX >= 397 && DrawX < 412 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (thousand_digit)
                5'd0 : color = zero[y3s][x3s];
                5'd1 : color = one[y3s][x3s];
                5'd2 : color = two[y3s][x3s];
                5'd3 : color = three[y3s][x3s];
                5'd4 : color = four[y3s][x3s];
                5'd5 : color = five[y3s][x3s];
                5'd6 : color = six[y3s][x3s];
                5'd7 : color = seven[y3s][x3s];
                5'd8 : color = eight[y3s][x3s];
                5'd9 : color = nine[y3s][x3s];
                default : ;
            endcase
        end
        else if (DrawX >= 376 && DrawX < 391 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (ten_thousand_digit)
                5'd0 : color = zero[y4s][x4s];
                5'd1 : color = one[y4s][x4s];
                5'd2 : color = two[y4s][x4s];
                5'd3 : color = three[y4s][x4s];
                5'd4 : color = four[y4s][x4s];
                5'd5 : color = five[y4s][x4s];
                5'd6 : color = six[y4s][x4s];
                5'd7 : color = seven[y4s][x4s];
                5'd8 : color = eight[y4s][x4s];
                5'd9 : color = nine[y4s][x4s];
                default : ;
            endcase
        end
        else if (DrawX >= 355 && DrawX < 370 && DrawY >= 255 && DrawY < 270)
        begin
            unique case (hundred_thousand_digit)
                5'd0 : color = zero[y5s][x5s];
                5'd1 : color = one[y5s][x5s];
                5'd2 : color = two[y5s][x5s];
                5'd3 : color = three[y5s][x5s];
                5'd4 : color = four[y5s][x5s];
                5'd5 : color = five[y5s][x5s];
                5'd6 : color = six[y5s][x5s];
                5'd7 : color = seven[y5s][x5s];
                5'd8 : color = eight[y5s][x5s];
                5'd9 : color = nine[y5s][x5s];
                default : ;
            endcase
        end
        
        else if (DrawX >= 207 && DrawX < 433 && DrawY >= 305 && DrawY < 315)
            color = play_again[yp][xp];
		//score Drawing
		
//        else if ((DrawX >= score_letters_x) && (DrawX <= score_letters_x + score_letters_size_x) && 
//            (DrawY >= score_letters_y) && (DrawY < (score_letters_y + score_letters_size_y)))
//        begin
//            color = score_letters[(offset_score_y - (offset_score_y % di))/di][(offset_score_x - (offset_score_x%di))/di];
//        end
//        else if ((DrawX >= hundred_thousand_x) && (DrawX <= (hundred_thousand_x + hundred_thousand_size_x)) && 
//            (DrawY >= hundred_thousand_y) && (DrawY < (hundred_thousand_y + hundred_thousand_size_y)))
//        begin
//            unique case(hundred_thousand_digit)
//                5'd0: color = zero[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd1: color = one[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 			
//                5'd2: color = two[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd3: color = three[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd4: color = four[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd5: color = five[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd6: color = six[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd7: color = seven[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd8: color = eight[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di]; 
//                5'd9: color = nine[(offset_hun_thou_y - (offset_hun_thou_y%di))/di][(offset_hun_thou_x - (offset_hun_thou_x%di))/di];
//                default : ;	
//            endcase
//        end
//        else if ((DrawX >= ten_thousand_x) && (DrawX <= (ten_thousand_x + ten_thousand_size_x)) && 
//            (DrawY >= ten_thousand_y) && (DrawY < (ten_thousand_y + ten_thousand_size_y)))
//        begin
//            unique case(ten_thousand_digit)
//                5'd0: color = zero[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd1: color = one[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 			
//                5'd2: color = two[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd3: color = three[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd4: color = four[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd5: color = five[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd6: color = six[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd7: color = seven[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd8: color = eight[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di]; 
//                5'd9: color = nine[(offset_ten_thou_y - (offset_ten_thou_y%di))/di][(offset_ten_thou_x - (offset_ten_thou_x%di))/di];
//                default : ;	
//            endcase
//        end
//        else if ((DrawX >= thousand_x) && (DrawX <= (thousand_x + thousand_size_x)) && 
//            (DrawY >= thousand_y) && (DrawY < (thousand_y + thousand_size_y)))
//        begin
//            unique case(thousand_digit)
//                5'd0: color = zero[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd1: color = one[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 			
//                5'd2: color = two[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd3: color = three[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd4: color = four[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd5: color = five[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd6: color = six[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd7: color = seven[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd8: color = eight[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di]; 
//                5'd9: color = nine[(offset_thou_y - (offset_thou_y%di))/di][(offset_thou_x - (offset_thou_x%di))/di];
//                default : ;	
//            endcase
//        end
//        // Hundred_digit
//        else if ((DrawX >= hundred_x) && (DrawX <= (hundred_x + hundred_size_x)) && 
//            (DrawY >= hundred_y) && (DrawY < (hundred_y + hundred_size_y)))
//        begin
//            unique case(hundred_digit)
//                5'd0: color = zero[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd1: color = one[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 		
//                5'd2: color = two[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd3: color = three[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd4: color = four[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd5: color = five[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd6: color = six[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd7: color = seven[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd8: color = eight[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                5'd9: color = nine[(offset_hun_y - (offset_hun_y%di))/di][(offset_hun_x - (offset_hun_x%di))/di]; 
//                default : ;	
//            endcase
//        end	
//        // Ten_digit
//        else if ((DrawX >= ten_x) && (DrawX <= (ten_x + ten_size_x)) && 
//            (DrawY >= ten_y) && (DrawY < (ten_y + ten_size_y)))
//        begin
//            unique case(ten_digit)
//                5'd0: color = zero[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd1: color = one[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 		
//                5'd2: color = two[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd3: color = three[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd4: color = four[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd5: color = five[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd6: color = six[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd7: color = seven[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd8: color = eight[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                5'd9: color = nine[(offset_ten_y - (offset_ten_y%di))/di][(offset_ten_x - (offset_ten_x%di))/di]; 
//                default : ;	
//            endcase
//        end	
//        // Single_digit
//        else if ((DrawX >= single_x) && (DrawX <= (single_x + single_size_x)) && 
//            (DrawY >= single_y) && (DrawY < (single_y + single_size_y)))
//        begin
//            unique case(single_digit)
//                5'd0: color = zero[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd1: color = one[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 					
//                5'd2: color = two[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd3: color = three[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd4: color = four[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd5: color = five[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd6: color = six[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd7: color = seven[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd8: color = eight[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                5'd9: color = nine[(offset_single_y - (offset_single_y%di))/di][(offset_single_x - (offset_single_x%di))/di]; 
//                default : ;	
//            endcase
//        end
		
		clr4 = color;
    end
 

endmodule