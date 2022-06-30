/************************************************************************
Lab 9 Quartus Project Top Level

Xinying Wang,  Summer 2020
Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module tetris (
	input  logic        CLOCK_50,
	input  logic [1:0]  KEY,
	output logic [9:0]  LEDR,
	output logic [6:0]  HEX0,
	output logic [6:0]  HEX1,
	output logic [6:0]  HEX2,
	output logic [6:0]  HEX3,
	output logic [6:0]  HEX4,
	output logic [6:0]  HEX5,

	output logic [12:0] DRAM_ADDR,
	output logic [1:0]  DRAM_BA,
	output logic        DRAM_CAS_N,
	output logic        DRAM_CKE,
	output logic        DRAM_CS_N,
	inout  logic [15:0] DRAM_DQ,
	output logic [1:0]  DRAM_DQM,
	output logic        DRAM_RAS_N,
	output logic        DRAM_WE_N,
	output logic        DRAM_CLK,
    
    output logic VGA_HS,
    output logic VGA_VS,
    output logic [3:0] VGA_R,
    output logic [3:0] VGA_G,
    output logic [3:0] VGA_B,
    
    inout logic [15:0] ARDUINO_IO,
    inout logic ARDUINO_RESET_N
);

// Exported data to show on Hex displays
    logic [47:0] GAME_EXPORT_DATA;
    
    logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
   
    assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;

    // Instantiation of Qsys design
    tetris_soc u0 (
		.clk_clk                           (CLOCK_50),            //clk.clk
		.reset_reset_n                     (KEY[0]),         //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export
        .game_export_new_signal(GAME_EXPORT_DATA),           // Exported data from the interface
        .leds_export                       (LEDR),           // LEDs export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm(DRAM_DQM),                           //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
	);
	  
    // Display 6 digit score
    HexDriver hexdrv0 (
        .In0(GAME_EXPORT_DATA[3:0]),
       .Out0(HEX0)
    );
    HexDriver hexdrv1 (
        .In0(GAME_EXPORT_DATA[7:4]),
       .Out0(HEX1)
    );
    HexDriver hexdrv2 (
        .In0(GAME_EXPORT_DATA[11:8]),
       .Out0(HEX2)
    );
    HexDriver hexdrv3 (
        .In0(GAME_EXPORT_DATA[15:12]),
       .Out0(HEX3)
    );
    HexDriver hexdrv4 (
        .In0(GAME_EXPORT_DATA[19:16]),
       .Out0(HEX4)
    );
    HexDriver hexdrv5 (
        .In0(GAME_EXPORT_DATA[23:20]),
       .Out0(HEX5)
    );

    assign VGA_HS = GAME_EXPORT_DATA[34];
    assign VGA_VS = GAME_EXPORT_DATA[35];	
    assign VGA_R = GAME_EXPORT_DATA[47:44];
    assign VGA_G = GAME_EXPORT_DATA[43:40];
    assign VGA_B = GAME_EXPORT_DATA[39:36];

endmodule