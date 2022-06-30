# Tetris on the DE-10 FPGA

Final project for ECE 385: Digital Systems Laboratory by Edward Guo and Minho Lee

## Table of Contents

1. [Introduction](#introduction)
2. [Written Description of the Final Project](#written-description-of-the-final-project)
    1. [Keyboard Input](#keyboard-input)
    2. [Piece Generation](#piece-generation)
    3. [Piece Movements](#piece-movements)
    4. [State Machines](#state-machines)
    5. [Sprint/Pixel Mapper and Display Drawing](#spritepixel-mapper-and-display-drawing)
    6. [Hardware/Software Interface](#hardwaresoftware-interface)
3. [Module Descriptions](#module-descriptions)
4. [Platform Designer Modules](#platform-designer-modules)
5. [C Program](#c-program)
6. [Design Resources and Statistics](#design-resources-and-statistics)
7. [Proposed List of Features](#proposed-list-of-features)
8. [Citations](#citations)

## Introduction

Our final project was to implement the game Tetris with our own design of IP core and SystemVerilog. We used the software to implement USB keyboard input. In our hardware part, we implemented the logic of the game such as block movement and placement, a state machine for game states, sprites for texts and scores, as well as VGA signal controls.

## Written Description of the Final Project

### Keyboard Input

The keyboard inputs for the game were read based on the code given for Lab 8 of the course. The keycodes were assigned to TETRIS_PTR[27] through the setKeycode() function which fed the value into the avalon interface used by the hardware.

### Piece Generation

Piece generation was handled by using a pseudo random number generator created in hardware. The random number generator works by cycling through a set order of numbers from 1 to 7 which refers to a given tetromino. The randomness comes from when the program reads the number from the random number generator.

### Piece Movements

Piece movement is determined by the given keycode which the user had inputted. The movements were left, right, down, and rotate. Based on which keycode is read, the program will compare if the next position will interfere with any other location on the board. If it does, the movement will not occur. Additionally, rotations when the piece is at the edge of the board will shift the piece such that it does not go out of bounds.

### State Machines

State machines were used to implement the gameplay of generating a piece, moving a piece, and updating the board. Each of these operations were state machines themselves which allowed for fluid gameplay. Each of these state machines also ran at a clock determined by the VGA_VS signal which allowed the game to be played at about 60 frames per second or 60 Hz.

### Sprite/Pixel Mapper and Display Drawing

Most of our pixel mapping is done in the Color_Mapper.sv module. The module contains other modules that read the sprites for texts. There are nested conditional statements that checks the state of the game. The game has three states, Start, in-game, and End. Based on the states, the color mapper decides what modules to output. For Start and End states, it is just one module that has all the information of start and end screen sprites, though in the End screen we add the score information for high-score features. During the in-game states, we use several modules and inputs from other modules. We have moving blocks, placed blocks, score/level/line counters, and background. Each of the components are positioned based on the X and Y coordinates of the screen. Each component has its bounding conditions. For example, our scoreboard is contained in a bounding box just the size for the text and numbers. If there is no bounding box, the sprite is repeated all over the screen, filling the entire screen with a pattern of the sprites. The output of the color mapper is an array of Red, Green, and Blue. These are directly passed to VGA modules, where it is converted to appropriate VGA signals.

### Hardware/Software Interface

An interface between the software and hardware was created to allow for operations on the board data on both the hardware and software. While the entire game could have been programmed on the NIOS-II processor using software, it may not have performed as well as if it were implemented on hardware. Thus, the hardware dependent portions of the game were implemented in hardware such as piece movement to make it relatively responsive to the user’s inputs. The portions that were not dependent on hardware were then implemented in software as they were typically easier to implement such as updating certain game values and handling clearing and shifting lines.

## Module Descriptions

- Top Level
  - **Module:** tetris.sv
  - **Inputs:** CLOCK_50, [1:0] KEY
  - **Outputs:** [9:0] LEDR, [6:0] HEX0, [6:0] HEX1, [6:0] HEX2, [6:0] HEX3, [6:0] HEX4, [6:0] HEX5, [12:0] DRAM_ADDR, [1:0] DRAM_BA, DRAM_CAS_N, DRAM_CKE, DRAM_CS_N, [1:0] DRAM_DQM, DRAM_RAS_N, DRAM_WE_N, DRAM_CLK, VGA_HS, VGA_VS, [3:0] VGA_R, [3:0] VGA_G, [3:0] VGA_B
  - **Bidirectional:** [15:0] DRAM_DQ, [15:0] ARDUINO_IO, ARDUINO_RESET_N
  - **Description:** This module includes a tetris_soc module which is from the Platform Designer which feeds the inputs and outputs given for the top level module to the tetris_soc. It also outputs the export data from the tetris_soc module to the HEX displays on the board and the VGA display output on the board.
  - **Purpose:** This module is used to take the inputs from the board, send them into the SOC module and take the outputs and feed them back to the board.
- SoC
  - **Module:** tetris_soc.v
  - **Inputs:** clk_clk, [1:0] key_external_connection_export, reset_reset_n, spi0_MISO, usb_gpx_export, usb_irq_export
  - **Outputs:** [47:0] game_export_new_signal, [12:0] sdram_wire_addr, [9:0] leds_export, [1:0] sdram_wire_ba, sdram_wire_cas_n, sdram_wire_cke, sdram_wire_cs_n, [1:0] sdram_wire_dqm, sdram_wire_ras_n, sdram_wire_we_n, sdram_clk_clk, spi0_MOSI, spi0_SCLK, spi0_SS_n, usb_rst_export
  - **Bidirectional:** [15:0] sdram_wire_dq
  - **Description:** This module includes all the modules defined in the Platform Designer for the SOC which include the NIOS-II processor, SDRAM and SDRAM PLL, JTAG UART peripheral, timer, PIO for the push buttons and the LEDS, and the avalon_tetris_interface module.
  - **Purpose:** This module serves to initialize the SOC with the different components that are included from the Platform Designer.
- Avalon Tetris Interface
  - **Module:** avalon_tetris_interface.sv
  - **Inputs:** CLK, RESET, AVL_READ, AVL_WRITE, AVL_CS, [3:0] AVL_ADDR, [31:0] AVL_WRITEDATA,  [31:0] AVL_READDATA
  - **Outputs:** [31:0] AVL_READDATA, [47:0] EXPORT_DATA
  - **Description:** If reset is pressed, the register file is cleared to contain all 0s. If not, then at the rising edge of the clock signal, if chip select is high, and if write is high, then the module will write the incoming data from AVL_WRITEDATA to the register file determined by AVL_ADDR and the AVL_BYTE_EN. If chip select is not high, then the decoded message and done signal are stored in the register file. The read data is set combinationally to be the data in the register file at AVL_ADDR when the chip select and read is high; otherwise, the read data is set to 0. The signals contained within the register file are used by all the other modules contained within the interface.
  - **Purpose:** This module serves as an interface of which the hardware can communicate with the SoC software to access the information of the game and keycodes to perform moves during the game.
- Hex Drivers
  - **Module:** HexDriver.sv
  - **Inputs:** [3:0] In0
  - **Outputs:** [6:0] Out0
  - **Bidirectional:** none
  - **Description:** Based on the input In0, the output Out0 is set equal to a certain 7-bit binary vector.
  - **Purpose:** This module determines which segments of the HEX display LED to be on in order to display a hexadecimal digit.
- Color Mapper
  - **Module:** Color_Mapper.sv
  - **Inputs:**  [3:0] pos_x, [4:0] pos_y, [2:0] piece_type, [1:0] orientation, [9:0] DrawX, [9:0] DrawY, start_game, end_game, [31:0] board[19:0], [31:0] score, [31:0] level, [31:0] line, [31:0] score1, [31:0] score2, [31:0] score3, blank
  - **Outputs:** [7:0] Red, [7:0] Green, [7:0] Blue, [23:0] dec_score
  - **Bidirectional:** none
  - **Description:** This module initiates many modules described below such as tetromino_color.sv and score_board.sv. The other modules give which color of pixel should be outputted based on the X and Y coordinates DrawX and Draw Y. Then, the color of pixels is decided based on the state of the game, start, end, or in-game. During in-game, there are many components such as the moving pieces, placed pieces, score and levels, as well as background. Each component’s colors and positions are determined in the modules initiated within the Color Mapper, and based on the condition statements, the components are outputted.
  - **Purpose:** This module is used to draw on the display.
- VGA Controller
  - **Module:** VGA_controller.sv
  - **Inputs:** Clk, Reset
  - **Outputs:** hs, vs, pixel_clk, blank, sync, [9:0] DrawX, [9:0] DrawY
  - **Bidirectional:** none
  - **Description:** This module takes a 50 MHz clock from the FPGA board, divides the clock in half to 25 MHz to create a screen refresh rate of 60 Hz which is outputted as pixel_clk. The module itself includes a counter to keep track of the current horizontal and vertical position within the VGA grid. Once the horizontal position reaches the set boundary of the display pixel width, the horizontal sync signal, hs, is set low and the counter is reset to 0. This signal is outputted from this module. Once the vertical position reaches the set boundary of the display pixel height, the vertical sync signal, vs, is set to low and the counter is reset to 0. This signal is also outputted from this module. The horizontal and vertical coordinate on the display is determined by the counters in the horizontal and vertical direction and is outputted as DrawX and DrawY. The display resolution is 640x480. If the horizontal counter is greater than or equal to 640 or if the vertical counter is greater than or equal to 480, nothing will be displayed as that is outside the defined resolution. This signal is outputted as blank. The sync signal is set to 0 as it is not used in this lab.
  - **Purpose:** It is used to output vga signals to the monitor, and draw on the display using color mapper, and update it accordingly.
- Random
  - **Module:** Random.sv
  - **Inputs:** CLK, RESET
  - **Outputs:** [3:0] T
  - **Bidirectional:** none
  - **Description:** This module takes in reset and clk from the interface. With the CLK input, it keeps on looping numbers with XOR logic, which has the effect of generating pseudo random numbers. The output random number array is used for random block generation.
  - **Purpose:** This module is used for pseudo random number generation.
- Move
  - **Module:** move.sv
  - **Inputs:** CLK, RESET, START, Init_start, Moving_start, Update_start
  - **Outputs:** DONE, Init_done, Moving_done, Update_done
  - **Bidirectional:** none
  - **Description:** This module takes a clock and reset in order to operate a state machine which outputs start signals to other state machines and moves between each state based on when those state machines are in their done states.
  - **Purpose:** This module serves as a strict state machine to handle the generation of a tetromino, movement left and right, rotation, downward movement, and updating the game board with the piece at the appropriate time.
- Moving
  - **Module:** moving.sv
  - **Inputs:** CLK, RESET, START, [7:0] keycode, [31:0] board[19:0], [31:0] lebel, [2:0] piece_type
  - **Outputs:** DONE, [3:0] curr_pos_x, [4:0] curr_pos_y, [1:0] curr_orient
  - **Bidirectional:** none
  - **Description:** This module takes a clock and reset input to operate. The input start triggers the start of this state machine which takes the current generated tetromino and determines the movement of the piece based on the inputted keycode. There are 4 states for this state machine which are Wait, Moving, Shifting, and Done. The Wait state resets signals for the next time the state machine is run. Moving determines the position of the tetromino left and right and the orientation of the tetromino based on the given inputted keycode from the keyboard. To avoid rotating too many times by holding down the key for rotate ‘J’, a signal holds the previous keycode and if it is the same (‘J’) it will not rotate. The movement left and right occurs every 6 clock cycles to avoid the same issue, but to maintain that you can shift left and right multiple times by holding the key. The piece will not move left or right or rotate if the piece would be in an invalid position if the left or right movement or rotation were to occur. To keep track of these different positions, modules of the current piece based on its left, right, and rotated positions are included. Shifting moves the position of the tetromino down by one. Within this state, a movement down will be attempted and checked if the piece is placed in an invalid location. If it is in an invalid location, the piece does not move and the Moving state machine is done and moves to the Done state. If not, the state would return back to Moving. The number of clock cycles that the state machine stays within the Moving state is determined by the current level of the game. As the levels increase, the number of clock cycles within Moving decreases which causes the tetrominos to fall faster. The user can force a piece to move one down by pressing ‘S’ which causes the piece to fall at 3 times the speed of the fall speed. The position of the tetromino and orientation is outputted from this module and used in the Update state machine.
  - **Purpose:** This module serves as a state machine to handle the movement of a piece after it has been generated and before it is included in the board.
- Current Blocks
  - **Module:** current_blocks.sv
  - **Inputs:** [2:0] piece_type, [1:0] orientation, [3:0] pos_x, [4:0] pos_y
  - **Outputs:** [3:0] cell1_x, [3:0] cell2_x, [3:0] cell3_x, [4:0] cell1_y, [4:0] cell2_y, [4:0] cell3_y
  - **Bidirectional:** none
  - **Description:** This module uses a set of cases within a case statement and calculates where each of the different cells from the center of the piece should be based on the orientation of the piece.
  - **Purpose:** This module is used to calculate the position of the 3 cells from the center of the piece based on a given piece type and orientation.
- Init
  - **Module:** init.sv
  - **Inputs:** CLK, RESET, START
  - **Outputs:** DONE, [2:0] piece_type
  - **Bidirectional:** none
  - **Description:** This module takes a clock and reset input to run the state machine. The state machine initializes signals to a certain value and reads the output from the random number generator module. The number is then converted to a value which represents a tetromino and is outputted from the module.
  - **Purpose:** This module is a state machine which handles generating a piece using a random number generator implemented in hardware.
- Update
  - **Module:** update.sv
  - **Inputs:** CLK, RESET, START, [31:0] board[19:0], [3:0] pos_x, [4:0] pos_y, [2:0] piece_type, [1:0] orientation
  - **Outputs:** DONE, [31:0] new_board[19:0]
  - **Bidirectional:** none
  - **Description:** This module takes a clock and reset input to run the state machine. The state machine takes the x and y position of the piece and updates the board at the locations the piece is on and outputs the new board.
  - **Purpose:** This module updates the game once a piece cannot move down.
- Tetrimino Color
  - **Module:** tetrimino_color.sv
  - **Inputs:** [2:0] piece_type
  - **Outputs:** [7:0] Red, [7:0] Green, [7:0] Blue
  - **Bidirectional:** none
  - **Description:** This module contains a case statement which assigns the RGB values for each piece. For the value of the piece_type that has a value of 7, the RGB values are set to the background color.
  - **Purpose:** This module outputs the RGB values of each different tetromino.
- Score Board
  - **Module:** score_board.sv
  - **Inputs:** reset, [9:0] DrawX, [9:0] DrawY, [31:0] score
  - **Outputs:** scr_board_on, [3:0] clr0, [23:0] dec_score
  - **Bidirectional:** none
  - **Description:** In this module, the input score is converted to decimal to be outputted. Also, it outputs the converted decimal score, color decider, and score board on signal which lets the color mapper module know at which location the score board should be inserted.
  - **Purpose:** This module is used to draw an in-game scoreboard.
- Line Board
  - **Module:** line_board.sv
  - **Inputs:** reset, [9:0] DrawX, [9:0] DrawY, [31:0] score
  - **Outputs:** line_board_on, [3:0] clr0, [23:0] dec_score
  - **Bidirectional:** none
  - **Description:** In this module, the input line is converted to decimals to be outputted. Also, it outputs the converted decimal line, color decider, and line_board_on signal which lets the color mapper module know at which location the line counter should be inserted.
  - **Purpose:** This module is used to draw the in-game line counter.
- Level Board
  - **Module:** level_board.sv
  - **Inputs:** reset, [9:0] DrawX, [9:0] DrawY, [31:0] score
  - **Outputs:** lv_board_on, [3:0] clr0, [23:0] dec_score
  - **Bidirectional:** none
  - **Description:** In this module, the input level is converted to decimals to be outputted. Also, it outputs the converted decimal level, color decider, and lv_board_on signal which lets the color mapper module know at which location the level counter should be inserted.
  - **Purpose:** This module is used to draw the in-game level counter.
- Start
  - **Module:** Start.sv
  - **Inputs:** [9:0] DrawX,  [9:0] DrawY
  - **Outputs:** [3:0] clr3
  - **Bidirectional:** none
  - **Description:** This module outputs color arrays according to the X and Y coordinates. The color array is converted into RGB outputs in the color mapper module for display output.
  - **Purpose:** This module outputs RGB color decider based on the pixel for the game start screen.
- End Screen
  - **Module:** End_Screen.sv
  - **Inputs:** [9:0] DrawX, [9:0] DrawY, [31:0] score, [31:0] score1, [31:0] score2, [31:0] score3
  - **Outputs:** [3:0] clr4
  - **Bidirectional:** none
  - **Description:** In addition to our start screen, for the end screen we have a high score system. 4 different input scores are the scores we have either stored from previous games or the latest end score. It converts the scores into decimals and decides where to output pixels for texts and scores.
  - **Purpose:** This module outputs RGB color decider based on the pixel for the game end screen.
- Sprite
  - **Module:** Sprite.sv
  - **Inputs:** none
  - **Outputs:** [4:0][28:0][3:0] score_letters, [4:0][28:0][3:0] level_letters, [4:0][22:0][3:0] line_letters, [4:0][4:0][3:0] zero, [4:0][4:0][3:0] one, [4:0][4:0][3:0] two, [4:0][4:0][3:0] three, [4:0][4:0][3:0] four, [4:0][4:0][3:0] five, [4:0][4:0][3:0] six, [4:0][4:0][3:0] seven, [4:0][4:0][3:0] eight, [4:0][4:0][3:0] nine, [13:0][78:0][3:0] gameover_text, [13:0][57:0][3:0] Game_Start, [4:0][90:0][3:0] press_start, [4:0][112:0][3:0] play_again, [4:0][46:0][3:0] high_score, [4:0][46:0][3:0] your_score
  - **Bidirectional:** none
  - **Description:** In this module, the output matrices are filled with our sprites which contain information about where to plot desired color of pixels. With simple always _comb statements, the module keeps outputting the sprites into other modules.
  - **Purpose:** This module is used to get the desired sprite for drawing on display.
- hs RAM
  - **Module:** hsRam.sv
  - **Inputs:** clk, cs, we, [31:0] data_in, [1:0] addr, DONE_WR
  - **Outputs:** [31:0] data_out
  - **Bidirectional:**
  - **Description:** This module contains a register file with 3 registers each with 32 bits to contain an integer value. The register can be both read from and written to for   maintaining the high scores.
  - **Purpose:** This module serves as the RAM which holds the 3 highest scores in one game session.
- HS
  - **Module:** hs.sv
  - **Inputs:** clk, reset, START_RD, START_WR
  - **Outputs:** DONE_RD, DONE_WR, cs, we, [1:0] addr
  - **Bidirectional:** none
  - **Description:** This module takes a clock and reset to run a state machine. The state machine sends out an address, chip select signal, and write enable signal to perform writes and reads from the hsRAM to read and write high scores.
  - **Purpose:** This module serves as a state machine to initialize the RAM to the data held within a text file and to write data to the text file.

## Platform Designer Modules

### clk_0

This module creates the clock signal for the FPGA board which is set to 50 MHz. The Clock and Reset outputs get wired from this module to the other modules.

### nios2_gen2_0

This module creates an instance of the NIOS-II processor which takes in the clock and reset inputs from the clk_0 module and provides the data and instruction wires for the rest of the modules to interact with. This module performs the instructions given by the program and works with the data fed into it. It also receives interrupt requests through the irq to handle inputs from the JTAG UART and timer.

### onchip_memory2_0

This module creates an on chip memory module to be used for data that the processor needs fast access to in order to perform instructions. It has a bit width of 32 bits and a total size of 16 bytes.

### sdram

This module is used to initialize the external memory module used to store data and the instructions for the program for the SOC. The module does not use the system clock given by the clock module but uses the clock determined by sdram_pll.

### sdram_pll

This module creates the clock for the sdram module as we require the clock to be offset by a value such that any values read from the sdram is not changing and won’t cause unexpected behavior with the data required to execute the given instructions.

### sysid_qsys_0

This module is used to ensure that the hardware determined by the Platform Designer for the SOC matches the hardware determined and used by the BSP for the program to prevent any potential mismatches between the configurations which could cause unintended behavior and possibly damage the board.

### key

This module is used as a parallel input module of which the input from the push buttons is fed into the data master which is received as data for the processor to use to execute an instruction. The module has a bit width of 2.

### jtag_uart_0

This module is used to enable communication from the host computer to the NIOS-II processor through the terminal in eclipse which is used for debugging purposes for the embedded C code through print and scan statements. This operates by sending an interrupt signal to the processor in order to read and print values.

### usb_irq

This module is used as a parallel input of which any input from the keyboard triggers an interrupt signal from the USB interface to the NIOS-II processor in order to read the keyboard input into the SOC.

### usb_gpx

This module is used as a parallel input to the NIOS-II processor from the USB interface. It is not used within this lab and is set to input a 1’b0.

### usb_rst

This module is used as a parallel output of which a signal is sent out from the SOC to reset the USB interface once a timeout is reached.

### hex_digits

This module is used as a parallel output of which the keycodes of the keyboard inputs are displayed on the HEX LED displays.

### leds

This module is used as a parallel output to be used for debugging purposes.

### timer_0

This module is a timer of which counts in millisecond intervals. It is used to keep track of the time-outs that the USB interface requires.

### spi_0

This module is used as a serial peripheral interface of which the NIOS-II chip is able to communicate with the MAX3421E slave board. This module enables data to be read from and written to the slave board to be able to receive the keyboard inputs from the USB port on the Arduino shield.

### TETRIS_GAME_CORE_0

This module is used to enable communication between the SOC and software in C and the hardware. The module is a customized module included into the platform designer.

## C Program

### void set_keycode()

This function is used to set the register[27] to contain the keycode to be used within hardware for movements.

### void start_move()

This function is used to set the register[20] to 0x00000001 which is used to start the move state machine in hardware

### int check_board()

This function is used to clear any filled lines and to shift all not filled lines down. It calculates the score and level based on the number of lines cleared. It also checks if the space of which the piece spawns in is filled. If it is, the function would return 1 signifying game over. It will return 0 otherwise.

### void start_game()

This function is used to start the game either from first loading the game or playing again. It clears the game board and other game values before triggering the start game signal to display the game.

### void end_game()

This function is used to update the high scores of the game session and to write the high scores into the RAM. Once that is completed, the signal to display the game over screen will be triggered to display the game over screen.

### int main()

This function is the main function of the program which has a portion of the code from Lab 8 which is used to read the keycodes. The changes were made to include starting the game when the keycode for enter is read which would start the game. While loops were included for the use of maintaining the playing game state until a game over is detected.

## Design Resources and Statistics

| Resource | Stastics |
| --- | ------ |
| LUT | 45,058 |
| DSP | 0 |
| Memory (BRAM) | 55,296 |
| Flip-Flop | 4,222 |
| Frequency | 71.9 MHz |
| Static Power | 100.79 mW |
| Dynamic Power | 793.44 mW |
| Total Power | 1020.39 mW |

## Proposed List of Features

- Baseline features
  - Generation of the map on the display where the tetriminos will stack.
  - Random generation of 1 of 7 different tetriminos (pieces for the game)
  - Automatic movement of the tetrimino once generated
  - Movement of the tetrimino left, right, and down determined by keyboard inputs
  - Rotation of the tetrimino 90 degrees counterclockwise and clockwise based on keyboard input
  - Clears a line when a row is completely filled and remaining blocks shift down to fill in cleared lines
  - Movement remains within a 10 wide section
  - Score keeping
- Additional features
  - Varying color of pieces
  - Acceleration of movement as number of cleared lines increases
  - Save piece for later option
  - Score on display
  - Drop tetrimino option
  - High score system

The above features are what we proposed in our final project proposal. We successfully implemented all the baseline features as well as some additional features. We implemented varying color of pieces, increasing level design, score on display and the high score system. Saving piece feature was quite difficult to implement as it directly interferes with our block movements and placements, which required a lot more work compared to other features. The Drop Tetrimino option was partially implemented. With the ‘S’ key, the user can increase the drop speed of the current block, but we do not have an immediate drop and placement feature for the game.

## Citations

- Random Number Generator
  - <https://stackoverflow.com/questions/14497877/how-to-implement-a-pseudo-hardware-random-number-generator/20145147>
- Font drawing
  - <https://github.com/ministrike3/ECE-385-Final-Project>
  - Used for implementation of sprite drawing as our first approach of using ram.sv and image conversion tool described below.
- High score RAM
  - <https://github.com/Atrifex/ECE385-HelperTools>
  - Specifically ram.sv was used as a template for the RAM used to contain high scores
- Gameplay
  - <https://tetris.wiki/>
  - Specifically useful within the wiki:
  - <https://tetris.wiki/Drop>
    - Used to understand the concept of gravity and for implementation of the Moving state machine
  - <https://tetris.wiki/Tetris_(Game_Boy>)
    - Used to get the gravity values of which the game plays on
  - <https://tetris.wiki/Scoring>
    - Used to get the scoring calculation for the game
    - Specifically used the Original Nintendo Scoring System
    - Only implemented the line clears and not soft drops
  - <https://www.youtube.com/watch?v=BQwohHgrk2s>
    - Used as a visual to see how the game should run
