module tetromino_color(
    input logic [2:0] piece_type,
    output logic [7:0] Red,
    output logic [7:0] Green,
    output logic [7:0] Blue
);
    
    always_comb
    begin
        case (piece_type)
            3'o0 :  // I
            begin
                Red = 8'h00;
                Green = 8'hff;
                Blue = 8'hff;
            end
            3'o1 :  // O
            begin
                Red = 8'hff;
                Green = 8'hff;
                Blue = 8'h00;
            end
            3'o2 :  // T
            begin
                Red = 8'haa;
                Green = 8'h00;
                Blue = 8'hff;
            end
            3'o3 :  // S
            begin
                Red = 8'h00;
                Green = 8'hff;
                Blue = 8'h00;
            end
            3'o4 :  // Z
            begin
                Red = 8'hff;
                Green = 8'h00;
                Blue = 8'h00;
            end
            3'o5 :  // J
            begin
                Red = 8'h00;
                Green = 8'h00;
                Blue = 8'hff;
            end
            3'o6 :  // L
            begin
                Red = 8'hff;
                Green = 8'haa;
                Blue = 8'h00;
            end
            default :
            begin
                Red = 8'h00;
                Green = 8'h00;
                Blue = 8'h00;
            end
        endcase
    end

endmodule