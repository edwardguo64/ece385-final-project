module avalon_tetris_interface (
    input logic CLK,
    input logic RESET,
    input logic AVL_READ,
    input logic AVL_WRITE,
    input logic AVL_CS,
    input logic [4:0] AVL_ADDR,
    input logic [31:0] AVL_WRITEDATA,
    output logic [31:0] AVL_READDATA,
    
    output logic [47:0] EXPORT_DATA
);

    // Reg file is a 32 unpacked array of 32-bit packed arrays:
    // - Registers [19:0] will store a 10-bit bit vector which would refer to the game board
    // - Registers [21:20] refer to the Start and Done signals for reading and moving a piece and reading/writing high scores
    //   - [0] is for moving
    //   - [30] is for writing
    //   - [31] is for reading
    // - Registers [23:22] refer to the Start and Done signals for the game
    // - Register [24] refers to the score
    // - Register [25] refers to the level
    // - Register [26] refers to the lines cleared
    // - Register [27] refers to the keycode
    // - Register [30:28] refer to the high scores
    // - Register [31] is unused
    logic [31:0] REG_FILE[32];
    
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
    logic VGA_HS, VGA_VS;
    
    // Start and done signals for state machines for generating, moving, updating and entire process
    logic MOVE_START, MOVE_DONE, Init_start, Init_done;
    logic Moving_start, Moving_done, Update_start, Update_done;
    
    logic start_game, end_game;
    
    logic START_RD, DONE_RD;
    logic START_WR, DONE_WR;
    logic cs, we;
    logic [1:0] addr;
    
    logic [31:0] data_in, data_out;
    
    logic [31:0] score1, score2, score3, score4;
    
    logic [2:0] piece_type;
    logic [1:0] orientation;
    
    logic [31:0] board[19:0], new_board[19:0];
    
    logic [3:0] pos_x;
    logic [4:0] pos_y;
    
    logic [31:0] score;
    logic [23:0] dec_score;
    logic [31:0] level;
    logic [31:0] line;
    
    logic Reset_h, vssig, blank, sync, VGA_Clk;
    
    always_ff @ (posedge CLK or posedge RESET)
    begin
        if (RESET)  // when reset
        begin
            // clear register file
            for (int i = 0; i < 32; i++)
            begin
                REG_FILE[i] <= 32'b0;
            end
        end
        else
        begin
            if (AVL_CS && AVL_WRITE)                                             // if chip is selected
                REG_FILE[AVL_ADDR] <= AVL_WRITEDATA;
            else
            begin
                for (int i = 0; i < 20; i++)
                begin
                    if (Update_done)
                        REG_FILE[i] <= new_board[i];
                end
                
                REG_FILE[21][0] <= MOVE_DONE;
                REG_FILE[21][31] <= DONE_RD;
                REG_FILE[21][30] <= DONE_WR;
                
                if (cs && !we)
                begin
                    case (addr)
                        2'b00 : REG_FILE[28] <= data_out;
                        2'b01 : REG_FILE[29] <= data_out;
                        2'b10 : REG_FILE[30] <= data_out;
                    endcase
                end
            end
        end
    end
    
    always_comb                                 // read data set to data_out
    begin
        if (AVL_CS && AVL_READ)
            AVL_READDATA = REG_FILE[AVL_ADDR];
        else
            AVL_READDATA = 32'b0;
    end
    
    // assigns the export data to be the VGA signals and score.
    assign EXPORT_DATA = {Red[7:4], Green[7:4], Blue[7:4],
        VGA_VS, VGA_HS, 2'b00, 8'h00, dec_score};    // decimal converted score displayed on hex
    
    assign keycode = REG_FILE[27][7:0]; // reads keycode from register file
    assign MOVE_START = REG_FILE[20][0];
    assign level = REG_FILE[25];
    assign score = REG_FILE[24];
    assign line = REG_FILE[26];
    assign start_game = REG_FILE[22][0];
    assign end_game = REG_FILE[23][0];
    assign START_RD = REG_FILE[20][31];
    assign START_WR = REG_FILE[20][30];
    assign score1 = REG_FILE[28];
    assign score2 = REG_FILE[29];
    assign score3 = REG_FILE[30];
    
    always_comb
    begin
        for (int i = 0; i < 20; i++)
        begin
            board[i] = REG_FILE[i];
        end
    end
    
    always_comb
    begin
        if (cs && we)
        begin
            case (addr)
                2'b00 : data_in = REG_FILE[28];
                2'b01 : data_in = REG_FILE[29];
                2'b10 : data_in = REG_FILE[30];
                default : data_in = 32'b0;
            endcase
        end
        else
            data_in = 32'b0;
    end
    
    hs high_score_rd_wr(.clk(CLK), .reset(RESET), .*);
    
    hsRAM high_score_RAM(.clk(CLK), .*);
    
    move move_state_machine(.CLK(VGA_VS), .RESET(RESET), .START(MOVE_START), .DONE(MOVE_DONE), .*);
    
    init init_piece(.CLK(VGA_VS), .RESET(RESET), .START(Init_start), .DONE(Init_done), .*);
    
    moving moving_piece(.CLK(VGA_VS), .RESET(RESET), .START(Moving_start), .DONE(Moving_done), .keycode, .board,
        .level, .curr_pos_x(pos_x), .curr_pos_y(pos_y), .piece_type, .curr_orient(orientation)
    );
    
    update update_piece(.CLK(VGA_VS), .RESET(RESET), .START(Update_start), .DONE(Update_done), .board, .pos_x, .pos_y,
        .piece_type, .orientation, .new_board
    );

    // should be the same
    vga_controller u1(
        .Clk(CLK),
        .Reset(RESET),
        .hs(VGA_HS),
        .vs(VGA_VS),
        .pixel_clk(VGA_Clk),
        .blank(blank),
        .sync(),
        .DrawX(drawxsig),
        .DrawY(drawysig)
    );
     
    // Needs to change to handle pieces
    color_mapper u2(
        .pos_x,
        .pos_y,
        .piece_type,
        .orientation,
        .DrawX(drawxsig),
        .DrawY(drawysig),
        .start_game,
        .end_game,
        .board,
        .score,
        .level,
        .line,
        .score1,
        .score2,
        .score3,
        .blank,
        .Red(Red),
        .Green(Green),
        .Blue(Blue),
        .dec_score
    );
    
endmodule