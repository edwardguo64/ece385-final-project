module init(
    input logic CLK,
    input logic RESET,
    input logic START,
    output logic DONE,
    output logic [2:0] piece_type
);

    enum logic [1:0] {Wait, Generate, Done} State, Next_state;
    logic [2:0] piece, Next_piece, rand_piece;
    
    Random randT(.CLK, .RESET, .T(rand_piece));
    
    always_ff @ (posedge RESET or posedge CLK)
    begin
        if (RESET)
        begin
            State <= Wait;
            piece <= 3'o7;  // 3'o7 means 3 bit octal 7
        end
        else
        begin
            State <= Next_state;
            piece <= Next_piece;
        end
    end
    
    always_comb
    begin
        Next_piece = piece;
        Next_state = State;
        
        DONE = 1'b0;
        
        unique case (State)
            Wait :
                if (START)
                    Next_state = Generate;
            Generate :
                if (rand_piece != 3'o0)
                    Next_state = Done;
            Done :
                if (!START)
                    Next_state = Wait;
            default : ;
        endcase
        
        case (State)
            Wait : ;
            Generate :
                Next_piece = rand_piece - 1;
            Done :
                DONE = 1'b1;
            default : ;
        endcase
    end
    
    assign piece_type = piece;

endmodule