// Used to determine the cell positions on the board of the other blocks
// of the piece that are not the center based on piece type and orientation

module current_blocks(
    input logic [2:0] piece_type,
    input logic [1:0] orientation,
    input logic [3:0] pos_x,
    input logic [4:0] pos_y,
    output logic [3:0] cell1_x, cell2_x, cell3_x,
    output logic [4:0] cell1_y, cell2_y, cell3_y
);

    always_comb
    begin
        case (piece_type)
            3'o0 :  // I
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    // 1 c 2 3
                        cell2_x = pos_x - 1;
                        cell3_x = pos_x - 2;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y;
                        cell3_y = pos_y;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x;        // 3
                        cell2_x = pos_x;        // 2
                        cell3_x = pos_x;        // c
                                                // 1
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y - 2;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x + 1;    // 1 c 2 3
                        cell2_x = pos_x - 1;
                        cell3_x = pos_x - 2;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y;
                        cell3_y = pos_y;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x;        // 3
                        cell2_x = pos_x;        // 2
                        cell3_x = pos_x;        // c
                                                // 1
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y - 2;
                    end
                endcase
            end
            3'o1 :  // O
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x;        // 1 2
                        cell2_x = pos_x - 1;    // c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x;        // 1 2
                        cell2_x = pos_x - 1;    // c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x;        // 1 2
                        cell2_x = pos_x - 1;    // c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x;        // 1 2
                        cell2_x = pos_x - 1;    // c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                endcase
            end
            3'o2 :  // T
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    //   2
                        cell2_x = pos_x;        // 1 c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x;        // 1
                        cell2_x = pos_x - 1;    // c 2
                        cell3_x = pos_x;        // 3
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y + 1;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x - 1;    // 3 c 1
                        cell2_x = pos_x;        //   2
                        cell3_x = pos_x + 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y + 1;
                        cell3_y = pos_y;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x;        //   3
                        cell2_x = pos_x + 1;    // 2 c
                        cell3_x = pos_x;        //   1
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y - 1;
                    end
                endcase
            end
            3'o3 :  // S
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    //   2 3
                        cell2_x = pos_x;        // 1 c
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y - 1;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x;        // 3
                        cell2_x = pos_x + 1;    // 2 c
                        cell3_x = pos_x + 1;    //   1
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y - 1;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x + 1;    //   2 3
                        cell2_x = pos_x;        // 1 c
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y - 1;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x;        // 3
                        cell2_x = pos_x + 1;    // 2 c
                        cell3_x = pos_x + 1;    //   1
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y - 1;
                    end
                endcase
            end
            3'o4 :  // Z
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    // 1 2
                        cell2_x = pos_x;        //   c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x - 1;    //   1
                        cell2_x = pos_x - 1;    // c 2
                        cell3_x = pos_x;        // 3
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y + 1;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x + 1;    // 1 2
                        cell2_x = pos_x;        //   c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x - 1;    //   1
                        cell2_x = pos_x - 1;    // c 2
                        cell3_x = pos_x;        // 3
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y + 1;
                    end
                endcase
            end
            3'o5 :  // J
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    // 1
                        cell2_x = pos_x + 1;    // 2 c 3
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x - 1;    // 2 1
                        cell2_x = pos_x;        // c
                        cell3_x = pos_x;        // 3
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y + 1;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x - 1;    // 3 c 2
                        cell2_x = pos_x - 1;    //     1
                        cell3_x = pos_x + 1;
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y;
                        cell3_y = pos_y;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x + 1;    //   3
                        cell2_x = pos_x;        //   c
                        cell3_x = pos_x;        // 1 2
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y + 1;
                        cell3_y = pos_y - 1;
                    end
                endcase
            end
            3'o6 :  // L
            begin
                case (orientation)
                    2'd0 :
                    begin
                        cell1_x = pos_x + 1;    //     3
                        cell2_x = pos_x - 1;    // 1 c 2
                        cell3_x = pos_x - 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y;
                        cell3_y = pos_y - 1;
                    end
                    2'd1 :
                    begin
                        cell1_x = pos_x;        // 1
                        cell2_x = pos_x;        // c
                        cell3_x = pos_x - 1;    // 2 3
                        
                        cell1_y = pos_y - 1;
                        cell2_y = pos_y + 1;
                        cell3_y = pos_y + 1;
                    end
                    2'd2 :
                    begin
                        cell1_x = pos_x - 1;    // 2 c 1
                        cell2_x = pos_x + 1;    // 3
                        cell3_x = pos_x + 1;
                        
                        cell1_y = pos_y;
                        cell2_y = pos_y;
                        cell3_y = pos_y + 1;
                    end
                    2'd3 :
                    begin
                        cell1_x = pos_x;        // 3 2
                        cell2_x = pos_x;        //   c
                        cell3_x = pos_x + 1;    //   1
                        
                        cell1_y = pos_y + 1;
                        cell2_y = pos_y - 1;
                        cell3_y = pos_y - 1;
                    end
                endcase
            end
            default :
            begin
                cell1_x = pos_x;
                cell2_x = pos_x;
                cell3_x = pos_x;
                
                cell1_y = pos_y;
                cell2_y = pos_y;
                cell3_y = pos_y;
            end
        endcase
    end

endmodule