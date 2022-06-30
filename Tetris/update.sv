module update(
    input logic CLK,
    input logic RESET,
    
    input logic START,
    output logic DONE,
    
    input logic [31:0] board[19:0],
    
    input logic [3:0] pos_x,
    input logic [4:0] pos_y,
    
    input logic [2:0] piece_type,
    input logic [1:0] orientation,
    
    output logic [31:0] new_board[19:0]
);

    enum logic [1:0] {Wait, Update, Done} State, Next_state;
    logic [31:0] temp_board[19:0], Next_temp_board[19:0];
    logic [3:0] cell1_x, cell2_x, cell3_x;
    logic [4:0] cell1_y, cell2_y, cell3_y;
    
    current_blocks currb(.*);
    
    always_ff @ (posedge CLK or posedge RESET)
    begin
        if (RESET)
        begin
            State <= Wait;
            
            for (int i = 0; i < 20; i++)
            begin
                temp_board[i] <= board[i];
            end
        end
        else
        begin
            State <= Next_state;
            
            for (int i = 0; i < 20; i++)
            begin
                temp_board[i] <= Next_temp_board[i];
            end
        end
    end
    
    always_comb
    begin
        Next_state = State;
        
        for (int i = 0; i < 20; i++)
        begin
            Next_temp_board[i] = temp_board[i];
        end
        
        DONE = 1'b0;
        
        unique case (State)
            Wait :
                if (START)
                    Next_state = Update;
            Update :
                Next_state = Done;
            Done :
                if (!START)
                    Next_state = Wait;
            default : ;
        endcase
        
        case (State)
            Wait :
            begin
                for (int i = 0; i < 20; i++)
                begin
                    Next_temp_board[i] <= board[i];
                end
            end
            Update :
            begin
                Next_temp_board[pos_y][pos_x] = 1'b1;
                Next_temp_board[cell1_y][cell1_x] = 1'b1;
                Next_temp_board[cell2_y][cell2_x] = 1'b1;
                Next_temp_board[cell3_y][cell3_x] = 1'b1;
            end
            Done :
                DONE = 1'b1;
            default : ;
        endcase
    end
    
    always_comb
    begin
        for (int i = 0; i < 20; i++)
        begin
            new_board[i] = temp_board[i];
        end
    end

endmodule