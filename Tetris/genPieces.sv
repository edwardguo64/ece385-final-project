//This module will generate a piece in registers according to the random value.
//It will output the rotation, type, and the updated Register.

module genPieces(
    input logic RESET, clk,
    output logic [3:0] rot, tp,
    output logic [31:0] REG_OUT[19:0]
);

	Random myRandom(.clk(clk), .reset_n(~Reset), .T(tp), .R(rot));
	
	logic [31:0] REG_temp[19:0];
	
	
	assign REG_OUT = REG_temp;
	
	always_ff @ (posedge clk or posedge Reset )
    begin 
	 
        if(RESET)
            REG_temp[19:0]<= 1'b0;
            
        else begin
         
            //center of the block
            REG_temp[0][5] <= 1;
            
            //I-Block
            if(tp == 1'b0) begin
                if(rot == 0) begin //position 1
                    REG_temp[0][4] <= 1;
                    REG_temp[0][6] <= 1;
                    REG_temp[0][7] <= 1;
                end
                //other rotations...
                
            end
            
            //J-block
            if(tp == 1) begin
                if(rot == 0) begin
                    REG_temp[1][5] <= 1;
                    REG_temp[1][6] <= 1;
                    REG_temp[1][7] <= 1;
                end
            end
            
            //L-block
            if(tp == 2) begin
                if(rot == 0) begin
                    REG_temp[1][5] <= 1;
                    REG_temp[1][4] <= 1;
                    REG_temp[1][3] <= 1;
                end
            end
            
            //O-block
            if(tp == 3) begin
                if(rot == 0) begin
                    REG_temp[0][6] <= 1;
                    REG_temp[1][5] <= 1;
                    REG_temp[1][6] <= 1;
                end
            end
            
            //S-block
            if(tp == 4) begin
                if(rot == 0) begin
                    REG_temp[0][6] <= 1;
                    REG_temp[1][5] <= 1;
                    REG_temp[1][4] <= 1;
                end
            end
            
            //T-Block
            if(tp == 5) begin
                if(rot == 0) begin
                    REG_temp[1][4] <= 1;
                    REG_temp[1][5] <= 1;
                    REG_temp[1][6] <= 1;
                end
            end
            
            //Z-Block
            if(tp == 6) begin
                if(rot == 0) begin
                    REG_temp[0][4] <= 1;
                    REG_temp[1][5] <= 1;
                    REG_temp[1][6] <= 1;
                end
            end
            
        end
	
	
	 
    end

endmodule