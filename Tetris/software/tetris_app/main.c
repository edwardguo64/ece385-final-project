//ECE 385 USB Host Shield code
//based on Circuits-at-home USB Host code 1.x
//to be used for ECE 385 course materials
//Revised October 2020 - Zuofu Cheng

#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "usb_kb/GenericMacros.h"
#include "usb_kb/GenericTypeDefs.h"
#include "usb_kb/HID.h"
#include "usb_kb/MAX3421E.h"
#include "usb_kb/transfer.h"
#include "usb_kb/usb_ch9.h"
#include "usb_kb/USB.h"

extern HID_DEVICE hid_device;

static BYTE addr = 1; 				//hard-wired USB address
const char* const devclasses[] = { " Uninitialized", " HID Keyboard", " HID Mouse", " Mass storage" };
volatile unsigned int * TETRIS_PTR = (unsigned int *) TETRIS_GAME_CORE_0_BASE;

BYTE GetDriverandReport() {
	BYTE i;
	BYTE rcode;
	BYTE device = 0xFF;
	BYTE tmpbyte;

	DEV_RECORD* tpl_ptr;
	printf("Reached USB_STATE_RUNNING (0x40)\n");
	for (i = 1; i < USB_NUMDEVICES; i++) {
		tpl_ptr = GetDevtable(i);
		if (tpl_ptr->epinfo != NULL) {
			printf("Device: %d", i);
			printf("%s \n", devclasses[tpl_ptr->devclass]);
			device = tpl_ptr->devclass;
		}
	}
	//Query rate and protocol
	rcode = XferGetIdle(addr, 0, hid_device.interface, 0, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetIdle Error. Error code: ");
		printf("%x \n", rcode);
	} else {
		printf("Update rate: ");
		printf("%x \n", tmpbyte);
	}
	printf("Protocol: ");
	rcode = XferGetProto(addr, 0, hid_device.interface, &tmpbyte);
	if (rcode) {   //error handling
		printf("GetProto Error. Error code ");
		printf("%x \n", rcode);
	} else {
		printf("%d \n", tmpbyte);
	}
	return device;
}

void setLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_BASE) | (0x001 << LED)));
}

void clearLED(int LED) {
	IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,
			(IORD_ALTERA_AVALON_PIO_DATA(LEDS_BASE) & ~(0x001 << LED)));
}

void setKeycode(WORD keycode)
{
	TETRIS_PTR[27] = keycode;
}

void start_move() {
	TETRIS_PTR[20] = 0x00000001;
}

int check_board() {
	int stop = 0;
	unsigned int lines_cleared = 0, points = 0;
	unsigned int curr_level = TETRIS_PTR[25];

	unsigned int temp_board[20];

	for (int i = 0; i < 20; i++) {
		temp_board[i] = TETRIS_PTR[i];
	}

	for (int i = 19; i >= 0; i--) {
		if ((temp_board[i] & 0x000003ff) == 0x000003ff) {
			temp_board[i] = 0x00000000;
			lines_cleared++;
		}
	}

	int i = 19;
	while (i >= 0) {
		int shift = 0;
		if ((temp_board[i] & 0x000003ff) == 0x00000000) {
			for (int j = i - 1; j >= 0; j--) {
				if ((temp_board[j] & 0x000003ff) != 0x00000000) {
					shift = 1;
					break;
				}
			}
			if (shift) {
				for (int j = i; j > 0; j--) {
					int temp = temp_board[j];
					temp_board[j] = temp_board[j - 1];
					temp_board[j - 1] = temp;
				}
			}
		}
		if (!shift) {
			i--;
		}
	}

	if ((temp_board[0] & 0x00000010) ||
		(temp_board[0] & 0x00000020) ||
		(temp_board[0] & 0x00000040)) {
		// game over
		stop = 1;
	}

	for (int i = 0; i < 20; i++) {
		unsigned int val = temp_board[i];
		TETRIS_PTR[i] = val;
	}

	if (lines_cleared == 1) {
		points = 40 * (curr_level + 1);
	} else if (lines_cleared == 2) {
		points = 100 * (curr_level + 1);
	} else if (lines_cleared == 3) {
		points = 300 * (curr_level + 1);
	} else if (lines_cleared == 4) {
		points = 1200 * (curr_level + 1);
	}

	TETRIS_PTR[26] += lines_cleared;		// increase lines cleared
	TETRIS_PTR[25] = TETRIS_PTR[26] / 10;	// calculate new level based on lines cleared
	TETRIS_PTR[24] += points;				// add points to score

	printf("Board:\n");
	for (int i = 0; i < 20; i++) {
		printf("%x\n", TETRIS_PTR[i]);
	}
	printf("level: %d\nlines cleared: %d\nscore: %d\n", TETRIS_PTR[25], TETRIS_PTR[26], TETRIS_PTR[24]);

	return stop;
}

void start_game() {
	// resets the board if play again
	for (int i = 0; i < 20; i++) {
		TETRIS_PTR[i] = 0x00000000;
	}

	// resets the score, lines, and level
	TETRIS_PTR[24] = 0x00000000;
	TETRIS_PTR[25] = 0x00000000;
	TETRIS_PTR[26] = 0x00000000;

	TETRIS_PTR[22] = 0x00000001;
	TETRIS_PTR[23] = 0x00000000;
	for (int i = 0; i < 100000; i++) {

	}
	start_move();
}

void end_game() {
	TETRIS_PTR[20] = 0x80000000;
	while ((TETRIS_PTR[21] & 0x80000000) == 0x00000000) {

	}
	TETRIS_PTR[20] = 0x00000000;

	int curr_score = TETRIS_PTR[24];

	int j = 28;
	for (j = 28; j < 31; j++) {
		if (curr_score > TETRIS_PTR[j]) {
			break;
		}
	}

	for (int k = 30; k > j; k--) {
		TETRIS_PTR[k] = TETRIS_PTR[k - 1];
	}

	TETRIS_PTR[j] = curr_score;

	TETRIS_PTR[20] = 0x40000000;
	while ((TETRIS_PTR[21] & 0x40000000) == 0x00000000) {

	}

	for (int i = 0; i < 100000; i++) {

	}
	TETRIS_PTR[20] = 0x00000000;

	for (int i = 0; i < 100000; i++) {

	}
	TETRIS_PTR[23] = 0x00000001;
	TETRIS_PTR[22] = 0x00000000;

	printf("High scores:\n");
	printf("1: %d\n", TETRIS_PTR[28]);
	printf("2: %d\n", TETRIS_PTR[29]);
	printf("3: %d\n", TETRIS_PTR[30]);
}

int main() {
	BYTE rcode;
	BOOT_MOUSE_REPORT buf;		//USB mouse report
	BOOT_KBD_REPORT kbdbuf;

	BYTE runningdebugflag = 0;//flag to dump out a bunch of information when we first get to USB_STATE_RUNNING
	BYTE errorflag = 0; //flag once we get an error device so we don't keep dumping out state info
	BYTE device;
//	WORD keycode;
	int game_start = 0;
	int cont = 0;

	printf("initializing MAX3421E...\n");
	MAX3421E_init();
	printf("initializing USB...\n");
	USB_init();
	while (1) {
		while ((TETRIS_PTR[21] & 0x00000001) == 0x00000000) {
			printf(".");
			MAX3421E_Task();
			USB_Task();
			//usleep (500000);
			if (GetUsbTaskState() == USB_STATE_RUNNING) {
				if (!runningdebugflag) {
					runningdebugflag = 1;
					setLED(9);
					device = GetDriverandReport();
				} else if (device == 1) {
					//run keyboard debug polling
					rcode = kbdPoll(&kbdbuf);
					if (rcode == hrNAK) {
						continue; //NAK means no new data
					} else if (rcode) {
						printf("Rcode: ");
						printf("%x \n", rcode);
						continue;
					}
					printf("keycodes: ");
					for (int i = 0; i < 6; i++) {
						printf("%x ", kbdbuf.keycode[i]);
					}

					if (!game_start && kbdbuf.keycode[0] == 0x28) {
						start_game();
						game_start = 1;
					}

					setKeycode(kbdbuf.keycode[0]);
					printf("\n");
				}

				else if (device == 2) {
					rcode = mousePoll(&buf);
					if (rcode == hrNAK) {
						//NAK means no new data
						continue;
					} else if (rcode) {
						printf("Rcode: ");
						printf("%x \n", rcode);
						continue;
					}
					printf("X displacement: ");
					printf("%d ", (signed char) buf.Xdispl);
					printf("Y displacement: ");
					printf("%d ", (signed char) buf.Ydispl);
					printf("Buttons: ");
					printf("%x\n", buf.button);
					if (buf.button & 0x04)
						setLED(2);
					else
						clearLED(2);
					if (buf.button & 0x02)
						setLED(1);
					else
						clearLED(1);
					if (buf.button & 0x01)
						setLED(0);
					else
						clearLED(0);
				}
			} else if (GetUsbTaskState() == USB_STATE_ERROR) {
				if (!errorflag) {
					errorflag = 1;
					clearLED(9);
					printf("USB Error State\n");
					//print out string descriptor here
				}
			} else //not in USB running state
			{

				printf("USB task state: ");
				printf("%x\n", GetUsbTaskState());
				if (runningdebugflag) {	//previously running, reset USB hardware just to clear out any funky state, HS/FS etc
					runningdebugflag = 0;
					MAX3421E_init();
					USB_init();
				}
				errorflag = 0;
				clearLED(9);
			}
		}

		TETRIS_PTR[20] = 0x00000000;

		if (!check_board()) {
			cont = 1;
		} else {
			cont = 0;
			game_start = 0;
			printf("game over\n");
			end_game();
		}

		if (cont && GetUsbTaskState() == USB_STATE_RUNNING && device == 1) {
			start_move();
		}
	}
	return 0;
}
