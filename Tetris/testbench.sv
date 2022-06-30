module testbench();

timeunit 10ns;

timeprecision 1ns;

logic CLK;
logic RESET;
logic START;
logic DONE;
logic [2:0] piece_type, T;
logic [1:0] orientation;

always begin : CLOCK_GENERATION


#1 CLK = ~CLK;

end 

initial begin : CLOCK_INITIALIZATION
	CLK = 0;
end

init initialize(.*);

assign T = initialize.randT.T;

initial begin : TEST
RESET = 1'b1;

#2 RESET = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

#2 START = 1'b1;

#6 START = 1'b0;

end

endmodule