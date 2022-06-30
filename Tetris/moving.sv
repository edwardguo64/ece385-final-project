module moving (
    input logic CLK,
    input logic RESET,
    
    input logic START,
    output logic DONE,
    
    input logic [7:0] keycode,      // keycode
    input logic [31:0] board[19:0], // current board
    input logic [31:0] level,       // current level
    
    output logic [3:0] curr_pos_x,  // current position of the piece
    output logic [4:0] curr_pos_y,
    
    input logic [2:0] piece_type,   // type of piece
    output logic [1:0] curr_orient // current orientation of piece
);

    enum logic [2:0] {Wait, Moving, Delay1, Delay2, Shifting, Done} State, Next_state;
    logic [1:0] orientation, Next_orientation;  // orientation: 0, 1, 2, 3
    logic [3:0] pos_x, Next_pos_x;
    logic [4:0] pos_y, Next_pos_y;
    logic STOP, Next_STOP;
    logic READY, Next_READY;
    logic [5:0] count, Next_count;
    logic [7:0] key, Next_key;
    
    logic [3:0] cell1_xl, cell2_xl, cell3_xl;
    logic [4:0] cell1_yl, cell2_yl, cell3_yl;
    
    logic [3:0] cell1_xr, cell2_xr, cell3_xr;
    logic [4:0] cell1_yr, cell2_yr, cell3_yr;
    
    logic [3:0] cell1_xd, cell2_xd, cell3_xd;
    logic [4:0] cell1_yd, cell2_yd, cell3_yd;
    
    logic [3:0] cell1_xrot, cell2_xrot, cell3_xrot;
    logic [4:0] cell1_yrot, cell2_yrot, cell3_yrot;
    
    logic [3:0] cell1_xrotl, cell2_xrotl, cell3_xrotl;
    logic [4:0] cell1_yrotl, cell2_yrotl, cell3_yrotl;
    
    logic [3:0] cell1_xrotr, cell2_xrotr, cell3_xrotr;
    logic [4:0] cell1_yrotr, cell2_yrotr, cell3_yrotr;
    
    logic [5:0] gravity;
    
    current_blocks l_blocks(.piece_type, .orientation(orientation), .pos_x(pos_x + 1),
        .pos_y(pos_y), .cell1_x(cell1_xl), .cell2_x(cell2_xl), .cell3_x(cell3_xl),
        .cell1_y(cell1_yl), .cell2_y(cell2_yl), .cell3_y(cell3_yl)
    );
    
    current_blocks r_blocks(.piece_type, .orientation(orientation), .pos_x(pos_x - 1),
        .pos_y(pos_y), .cell1_x(cell1_xr), .cell2_x(cell2_xr), .cell3_x(cell3_xr),
        .cell1_y(cell1_yr), .cell2_y(cell2_yr), .cell3_y(cell3_yr)
    );
    
    current_blocks d_blocks(.piece_type, .orientation(orientation), .pos_x(pos_x),
        .pos_y(pos_y + 1), .cell1_x(cell1_xd), .cell2_x(cell2_xd), .cell3_x(cell3_xd),
        .cell1_y(cell1_yd), .cell2_y(cell2_yd), .cell3_y(cell3_yd)
    );
        
    current_blocks rot_blocks(.piece_type, .orientation(orientation + 1), .pos_x(pos_x),
        .pos_y(pos_y), .cell1_x(cell1_xrot), .cell2_x(cell2_xrot), .cell3_x(cell3_xrot),
        .cell1_y(cell1_yrot), .cell2_y(cell2_yrot), .cell3_y(cell3_yrot)
    );
    
    current_blocks rotl_blocks(.piece_type, .orientation(orientation + 1), .pos_x(pos_x + 1),
        .pos_y(pos_y), .cell1_x(cell1_xrotl), .cell2_x(cell2_xrotl), .cell3_x(cell3_xrotl),
        .cell1_y(cell1_yrotl), .cell2_y(cell2_yrotl), .cell3_y(cell3_yrotl)
    );
    
    current_blocks rotr_blocks(.piece_type, .orientation(orientation + 1), .pos_x(pos_x - 1),
        .pos_y(pos_y), .cell1_x(cell1_xrotr), .cell2_x(cell2_xrotr), .cell3_x(cell3_xrotr),
        .cell1_y(cell1_yrotr), .cell2_y(cell2_yrotr), .cell3_y(cell3_yrotr)
    );
    
    always_comb
    begin
        gravity = 5'd3;
        if (level == 32'd0)
            gravity = 5'd53;
        else if (level == 32'd1)
            gravity = 5'd49;
        else if (level == 32'd2)
            gravity = 5'd45;
        else if (level == 32'd3)
            gravity = 5'd41;
        else if (level == 32'd4)
            gravity = 5'd37;
        else if (level == 32'd5)
            gravity = 5'd33;
        else if (level == 32'd6)
            gravity = 5'd28;
        else if (level == 32'd7)
            gravity = 5'd22;
        else if (level == 32'd8)
            gravity = 5'd17;
        else if (level == 32'd9)
            gravity = 5'd11;
        else if (level == 32'd10)
            gravity = 5'd10;
        else if (level == 32'd11)
            gravity = 5'd9;
        else if (level == 32'd12)
            gravity = 5'd8;
        else if (level == 32'd13)
            gravity = 5'd7;
        else if (level >= 32'd14 && level <= 32'd15)
            gravity = 5'd6;
        else if (level >= 32'd16 && level <= 32'd17)
            gravity = 5'd5;
        else if (level >= 32'd18 && level <= 32'd19)
            gravity = 5'd4;
    end
    
    always_ff @ (posedge RESET or posedge CLK)
    begin
        if (RESET)
        begin
            State <= Wait;
            pos_x <= 4'd5;
            pos_y <= 5'd0;
            orientation <= 2'd0;
            count <= 0;
            STOP <= 1'b0;
            READY <= 1'b0;
            key <= 8'h00;
        end
        else
        begin
            State <= Next_state;
            pos_x <= Next_pos_x;
            pos_y <= Next_pos_y;
            orientation <= Next_orientation;
            count <= Next_count;
            STOP <= Next_STOP;
            READY <= Next_READY;
            key <= Next_key;
        end
    end
    
    always_comb
    begin
        Next_state = State;
        Next_pos_x = pos_x;
        Next_pos_y = pos_y;
        Next_orientation = orientation;
        Next_count = count;
        Next_STOP = STOP;
        Next_READY = READY;
        Next_key = key;
        
        DONE = 1'b0;
        
        unique case (State)
            Wait :
                if (START)
                    Next_state = Moving;
            Moving :
                if (READY)
                    Next_state = Shifting;
//            Delay1 :
//                Next_state = Delay2;
//            Delay2 :
//                Next_state = Shifting;
            Shifting :
                if (STOP)
                    Next_state = Done;
                else
                    Next_state = Moving;
            Done :
                if (!START)
                    Next_state = Wait;
            default : ;
        endcase
        
        case (State)
            Wait :
            begin
                Next_pos_x = 4'd5;
                Next_pos_y = 5'd0;
                Next_orientation = 2'd0;
                
                Next_count = 1'b0;
                
                Next_READY = 1'b0;
                Next_STOP = 1'b0;
                Next_key = 8'h00;
            end
            Moving :
            begin
                Next_count = count + 1;
                
                Next_READY = (count + 1 == gravity);         // change condition for acceleration based on completed lines
                
                if (count - 1 != gravity)
                begin
                    case (keycode)
                        8'h00 : Next_key = 8'h00;
                        8'h04 :     // A (left)
                        begin
                            if (count % 6 == 0)
                            begin
                                Next_key = 8'h04;
                                Next_pos_x = pos_x + 1;
                                if (pos_x + 1 == 4'd10 || board[pos_y][pos_x + 1])
                                    Next_pos_x = pos_x;
                                else if (cell1_xl == 4'd10 || board[cell1_yl][cell1_xl])
                                    Next_pos_x = pos_x;
                                else if (cell2_xl == 4'd10 || board[cell2_yl][cell2_xl])
                                    Next_pos_x = pos_x;
                                else if (cell3_xl == 4'd10 || board[cell3_yl][cell3_xl])
                                    Next_pos_x = pos_x;
                            end
                        end
                        
                        8'h07 :     // D (right)
                        begin
                            if (count % 6 == 0)
                            begin
                                Next_key = 8'h07;
                                Next_pos_x = pos_x - 1;
                                if (pos_x - 1 == 4'd15 || board[pos_y][pos_x - 1])
                                    Next_pos_x = pos_x;
                                else if (cell1_xr == 4'd15 || board[cell1_yr][cell1_xr])
                                    Next_pos_x = pos_x;
                                else if (cell2_xr == 4'd15 || board[cell2_yr][cell2_xr])
                                    Next_pos_x = pos_x;
                                else if (cell3_xr == 4'd15 || board[cell3_yr][cell3_xr])
                                    Next_pos_x = pos_x;
                            end
                        end
                        
                        8'h16 :     // S (down)
                        begin
                            if (count + 1 == gravity / 3)
                                Next_READY = 1'b1;
                        end
                        
                        8'h0d :     // J (rotate)
                        begin
                            if (key != 8'h0d)
                            begin
                                Next_key = 8'h0d;
                                Next_orientation = orientation + 1;
                                
                                // checkif rotation iterferes with filled in locations
                                if (board[cell1_yrot][cell1_xrot] || board[cell2_yrot][cell2_xrot] || board[cell3_yrot][cell3_xrot])
                                    Next_orientation = orientation;
                                
                                // otherwise if hit left wall
                                else if (cell1_xrot == 4'd10 || cell2_xrot == 4'd10 || cell3_xrot == 4'd10)
                                begin
                                    Next_pos_x = pos_x - 1;                 // try to shift right by 1
                                    if (board[pos_y][pos_x - 1])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell1_yrotr][cell1_xrotr])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell2_yrotr][cell2_xrotr])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell3_yrotr][cell3_xrotr])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                end
                                
                                // if hit right wall
                                else if (cell1_xrot == 4'd15 || cell2_xrot == 4'd15 || cell3_xrot == 4'd15)
                                begin
                                    if (piece_type != 3'o0)
                                        Next_pos_x = pos_x + 1;                 // try to shift left by 1
                                    else
                                        Next_pos_x = pos_x + 2;
                                    if ((piece_type != 3'o0 && board[pos_y][pos_x + 1]) ||
                                        (piece_type == 3'o0 && board[pos_y][pos_x + 2]))
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell1_yrotl][cell1_xrotl])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell2_yrotl][cell2_xrotl])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                    else if (board[cell3_yrotl][cell3_xrotl])
                                    begin
                                        Next_pos_x = pos_x;
                                        Next_orientation = orientation;
                                    end
                                end
                            end
                        end
                    endcase
                end
            end
//            Delay1 : ;
//            Delay2 : ;
            Shifting :
            begin
                Next_count = 0;
                
                // Attempts to shift down by one unit
                Next_pos_y = pos_y + 1;
                if (pos_y + 1 == 5'd20 || board[pos_y + 1][pos_x])        // if any collisions occur, shift back up and stop
                begin
                    Next_pos_y = pos_y;
                    Next_STOP = 1'b1;
                end
                else if (cell1_yd == 5'd20 || board[cell1_yd][cell1_xd])
                begin
                    Next_pos_y = pos_y;
                    Next_STOP = 1'b1;
                end
                else if (cell2_yd == 5'd20 || board[cell2_yd][cell2_xd])
                begin
                    Next_pos_y = pos_y;
                    Next_STOP = 1'b1;
                end
                else if (cell3_yd == 5'd20 || board[cell3_yd][cell3_xd])
                begin
                    Next_pos_y = pos_y;
                    Next_STOP = 1'b1;
                end
            end
            Done :
                DONE = 1'b1;
            default : ;
        endcase
    end
    
    assign curr_pos_x = pos_x;
    assign curr_pos_y = pos_y;
    assign curr_orient = orientation;
    assign ready_sig = READY;
    assign curr_state = State;
    assign next_y = Next_STOP;

endmodule