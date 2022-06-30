module Start(
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
    output logic [3:0]clr3
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
	
	logic[9:0] Game_Start_x = 320; 
	logic[9:0] Game_Start_y = 150;
	logic[9:0] Game_Start_size_x = 10'd79;
	logic[9:0] Game_Start_size_y = 10'd100;
    
    int x, y, x1, y1;
    
    assign x = (464 - DrawX) / 5;
    assign y = (269 - DrawY) / 5;
    
    assign x1 = (410 - DrawX) / 2;
    assign y1 = (284 - DrawY) / 2;
	
	Sprite Sp(.*);
	
    always_comb
    begin:Game_StartSprite
//        if (((DrawX >= Game_Start_x) && (DrawX <= Game_Start_x + Game_Start_size_x) 
//            && (DrawY >= Game_Start_y) &&(DrawY <= Game_Start_y +Game_Start_size_y)))
//        begin
//            clr3 = Game_Start[DrawY-Game_Start_y][DrawX-Game_Start_x];
//        end
        if (DrawX >= 175 && DrawX < 465 && DrawY >= 200 && DrawY < 270)
            clr3 = Game_Start[y][x];
        else if (DrawX >= 229 && DrawX < 411 && DrawY >= 275 && DrawY < 285)
            clr3 = press_start[y1][x1];
        else
            clr3 = 4'b0;
    end 

endmodule