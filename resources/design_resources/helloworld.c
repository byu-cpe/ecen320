/*
 * helloworld.c: simple demo application
 *
 * This application configures UART 16550 to baud rate 9600.
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xiomodule.h"
#include "sleep.h"

#define GP_BUTTONS  1
#define GP_7SEG     2
#define GP_LEDS     3
#define GP_SWITCHES 4

#define SS_DELAY 4000UL // Delay between seven-segment digits

static XIOModule IOModule; /* Instance of the IO Module */

void hex_display(int num)
{
	static unsigned char decode7[] = {
		0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10, 0x08, 0x03, 0x46, 0x21, 0x06, 0x0E
	};
	// bits [11:8] map to anode signals, [7] to radix point, and [6:0] to segment signals
	XIOModule_DiscreteWrite(&IOModule, GP_7SEG, 0x780 | decode7[(num >> 12) & 0xF]);
	usleep_MB(SS_DELAY);
	XIOModule_DiscreteWrite(&IOModule, GP_7SEG, 0xB80 | decode7[(num >>  8) & 0xF]);
	usleep_MB(SS_DELAY);
	XIOModule_DiscreteWrite(&IOModule, GP_7SEG, 0xD80 | decode7[(num >>  4) & 0xF]);
	usleep_MB(SS_DELAY);
	XIOModule_DiscreteWrite(&IOModule, GP_7SEG, 0xE80 | decode7[ num        & 0xF]);
	usleep_MB(SS_DELAY);
}

int main()
{
	XStatus Status;
	unsigned int buttons, switches;
	unsigned int count = 0;

	init_platform();

	print("Hello World\n\r");

	/*
	 * Initialize the IO Module driver so that it is ready to use.
	 */
	Status = XIOModule_Initialize(&IOModule, XPAR_IOMODULE_0_DEVICE_ID);
	if (Status != XST_SUCCESS)
	{
		print(" -- error: XIOModule_Initialize Fail\n\r");
		return XST_FAILURE;
	}
	for (;;) {
		// bits [4:0] map to (Center, Down, Right, Left, Up) buttons
		buttons = XIOModule_DiscreteRead(&IOModule, GP_BUTTONS);
		// bits [15:0] map to switches 15 to 0
		switches = XIOModule_DiscreteRead(&IOModule, GP_SWITCHES);

		hex_display(count >> 4);
		// bits [15:0] map to LEDs 15 to 0
		XIOModule_DiscreteWrite(&IOModule, GP_LEDS, switches ^ count >> 4);
		count++;

		if (buttons & 0x10) break; // exit if BTNC is pressed
	}

	print("Goodbye\n\r");

	cleanup_platform();
	return 0;
}
