// Module used to control when to retrieve random piece, when to move the piece, and when to update the board

module move (
    input logic CLK,                // VGA clock used to play game at 60 fps
    input logic RESET,              // Reset
    input logic START,              // Start signal given by software to determine to start game process
    output logic DONE,              // Done signal given to software to determine clearing lines and score
    output logic Init_start,        // Start signal to generate random piece
    input logic Init_done,          // Done signal of generate random piece
    output logic Moving_start,      // Start signal to 
    input logic Moving_done,
    output logic Update_start,
    input logic Update_done
);

    enum logic [2:0] {Wait, Init, Moving, Update, Done} State, Next_state;
    
    always_ff @ (posedge RESET or posedge CLK)
    begin
        if (RESET)
        begin
            State <= Wait;
        end
        else
        begin
            State <= Next_state;
        end
    end
    
    always_comb
    begin
        Next_state = State;
        
        DONE = 1'b0;
        
        Init_start = 1'b0;
        Moving_start = 1'b0;
        Update_start = 1'b0;
        
        unique case (State)
            Wait :
                if (START)
                    Next_state = Init;
            Init :
                if (Init_done)
                    Next_state = Moving;
            Moving :
                if (Moving_done)
                    Next_state = Update;
            Update :
                if (Update_done)
                    Next_state = Done;
            Done :
                if (!START)
                    Next_state = Wait;
            default : ;
        endcase
        
        case (State)
            Wait : ;
            Init : Init_start = 1'b1;
            Moving : Moving_start = 1'b1;
            Update : Update_start = 1'b1;
            Done : DONE = 1'b1;
            default : ;
        endcase
    end

endmodule