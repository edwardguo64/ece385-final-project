module Random(
    input logic CLK,
    input logic RESET,
    output logic [3:0] T
);
//Generate pseudo-random number from 0 to 6 for various tetriminos.
//keep on looping in numbers while Reset = 0;
  
    logic [3:0] a;
	
	logic [3:0] data_next;
	
    always_comb begin
        data_next = a;
        repeat(4) begin
            data_next = {(data_next[3]^data_next[1]), data_next[3:1]};
        end
    end

	
    always_ff @(posedge CLK or posedge RESET) begin
        if(RESET)
            a <= 4'hf;
        else
            a <= data_next;
      
    end
	
    assign T = a;
	
endmodule