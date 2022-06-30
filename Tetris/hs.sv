module hs (
    input logic clk,
    input logic reset,
    
    input logic START_RD,
    output logic DONE_RD,
    
    input logic START_WR,
    output logic DONE_WR,
    
    output logic cs,
    output logic we,
    output logic [1:0] addr
);
    
    enum logic [3:0] {Wait, rd1, rd2, rd3, Done_rd, wr1, wr2, wr3, Done_wr} State, Next_state;
    
    always_ff @ (posedge reset or posedge clk)
    begin
        if (reset)
            State <= Wait;
        else
            State <= Next_state;
    end
    
    always_comb
    begin
        Next_state = State;
        we = 1'b0;
        cs = 1'b0;
        
        DONE_RD = 1'b0;
        DONE_WR = 1'b0;
        addr = 2'b11;
        
        unique case (State)
            Wait :
                if (START_RD)
                    Next_state = rd1;
                else if (START_WR)
                    Next_state = wr1;
            rd1 :
                Next_state = rd2;
            rd2 : 
                Next_state = rd3;
            rd3 :
                Next_state = Done_rd;
            Done_rd :
                if (!START_RD)
                    Next_state = Wait;
            wr1 :
                Next_state = wr2;
            wr2 :
                Next_state = wr3;
            wr3 :
                Next_state = Done_wr;
            Done_wr :
                if (!START_WR)
                    Next_state = Wait;
        endcase
        
        case (State)
            Wait : ;
            rd1 :
            begin
                cs = 1'b1;
                addr = 2'b00;
            end
            rd2 :
            begin
                cs = 1'b1;
                addr = 2'b01;
            end
            rd3 :
            begin
                cs = 1'b1;
                addr = 2'b10;
            end
            Done_rd :
            begin
                DONE_RD = 1'b1;
            end
            wr1 :
            begin
                cs = 1'b1;
                we = 1'b1;
                addr = 2'b00;
            end
            wr2 :
            begin
                cs = 1'b1;
                we = 1'b1;
                addr = 2'b01;
            end
            wr3 :
            begin
                cs = 1'b1;
                we = 1'b1;
                addr = 2'b10;
            end
            Done_wr :
                DONE_WR = 1'b1;
        endcase
    end

endmodule