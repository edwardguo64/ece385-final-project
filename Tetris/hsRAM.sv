module hsRAM (
    input logic clk,
    input logic cs,
    input logic we,
    input logic [31:0] data_in,
    input logic [1:0] addr,
    input logic DONE_WR,
    output logic [31:0] data_out
);

    logic [31:0] mem[3];
    
    initial
    begin
        $readmemh("scores.txt", mem);
    end
    
    always_comb
    begin
        if (DONE_WR)
            $writememh("scores.txt", mem);
    end
    
    always_ff @ (posedge clk)
    begin
        if (cs && we)
            mem[addr] <= data_in;
    end
    
    always_comb
    begin
        if (cs && !we)
            data_out = mem[addr];
        else
            data_out = 32'b0;
    end

endmodule