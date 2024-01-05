---
layout: page
toc: true
title: Working with IP
lab: IP
---

In this lab you will create a design that includes a 32-bit processor which is connected to the devices (buttons, switches, LEDs, etc.) on your board. You will learn how to access a library of ready-made components that can be used in a project for your board and quickly connect the components with a graphical user interface (GUI). You will also modify a demo program written in 'C' that runs on the processor and interacts with the devices.

# Learning Outcomes
* Become familiar with the Vivado IP Integrator
* Learn how to create a design using a library of components
* Create a platform description using Vitis IDE
* Create a software application using Vitis IDE

# Preliminary
Before beginning this lab, it is important to know the tools you will be using and the design flow which consists of three phases: 1) hardware design, 2) hardware handoff, and 3) software design.

## Hardware Design
We will use Vivado and select ready-made components from a library to build a hardware design. Someone else has already written Verilog or VHDL code for these components and then packaged them for inclusion in a library. A well written and debugged hardware component is often considered "Intellectual Property" (IP) and can be worth up to thousands of dollars. When components are grouped together in a library, it is often referred to as an "IP Library". We will use the Vivado IP Integrator, a graphical user interface (GUI), to create a design with a MicroBlaze processor. It is a soft 32-bit microprocessor core developed by Xilinx and can be implemented in the logic fabric of Xilinx FPGAs. It is available as an IP component in the IP library supplied with Vivado.

## Hardware Handoff
Once a hardware design with a processor is created, a description of that system is needed by a software project so a program can know what devices are connected and how to access them. Other detail needed by software includes information about the memory, such as its location and how much is available. The handoff to software is done by exporting a description of the hardware in an .xsa file.

## Software Design
The Vitis IDE will be used to implement and compile a software application to run on the hardware processing system created previously. The program created in this lab will run "bare metal", meaning that the 'C' program will run directly on the processor with no operating system support.

# Install Board Configuration Files
Before starting your design, you need to download and install some board configuration files specific to your board. Much of the information in the board files is the same as what is contained in the master constraints file you have been using, but with some additional information. Download the compressed archive file [board_files.tgz]({% link resources/design_resources/board_files.tgz %}) to your ecen220 project directory. Open a terminal window and `cd` to that directory. Then type the following to unpack the compressed archive:
```sh
$ tar -xzf board_files.tgz
```
You can remove the .tgz file after it is unpacked, if you like, by typing `rm board_files.tgz`.

Now start Vivado and paste the following into the Tcl Console input window (where it says "Type a Tcl command here"). If the path to where you installed your board files is different, please edit the path to match your path.
```tcl
set_param board.repoPaths [list "$::env(HOME)/ecen220/board_files"]
```
If you intend to use IP Integrator on another project, you will need to set the path to the board files using the above set_param Tcl command before creating the project so you can select the Basys3 board. The Basys3 board is not in the default set of boards supplied with Vivado. You will not need to unpack the .tgz file again.

# Exercises

## Exercise #1 - Create a Block Design with IP Integrator
1. Launch `vivado` if you have not done so already, and create a project with project name "proj" in a project location ending in "lab_ip".
2. When selecting a default part, select "Boards" in the dialog window. Then click on the row for "Basys3" and click Next, then Finish. If you do not see "Basys3" in the list of boards, you did not get the board configuration files set up correctly. Go back and revisit that section.
3. Click "Create Block Design" from the Flow Navigator. Specify a design name of "system" and click OK.
4. In the diagram window, click the '+' button to add IP. Your will see a long list of IP that can be added to your project. You can narrow the list by typing "micro" into the search box. Select "MicroBlaze MCS" and hit "enter" on your keyboard.
5. Customize the configuration for the processor by double clicking on the MicroBlaze block. In the dialog window, select the MCS tab and then change the "Memory Size" to 16KB. Also change "Enable Debug Support" to DEBUG ONLY.
6. Add the "Constant" IP block to your design by clicking the '+' button again and selecting it from the list.
7. Connect the dout\[0:0\] signal from xlconstant_0 to the Reset signal on microblaze_mcs_0. This is done by clicking on one of the pins and holding down the mouse button to rubber-band a line to the other pin, and then releasing the mouse button.
7. Connect a system clock to the processor by clicking on "Run Connection Automation" in the green bar at the top of the diagram window, then click OK in the dialog window.
9. Add connections from the processor to devices on your board. To see the devices, click on the "Board" tab (next to Sources, Design, and Signals tabs). This will expose a list of connections or devices available on your board. Right click on each port and select "Auto Connect" from the menu, and then OK. Add them in the following order:
  - USB UART
  - 5 Push Buttons
  - 7-Segment Display
  - 16 LEDs
  - 16 Switches
10. Click the "Validate Design" button in the diagram window and OK. It has a check mark in a box icon.
11. Click the "Save" button in the menu bar.
12. Create a top level module for the design by clicking on the "Sources" tab and then right click on "system" to select "Create HDL Wrapper...", then click OK.

If you have trouble creating your design with IP Integrator, you can download and run the [mcs.tcl]({% link resources/design_resources/mcs.tcl %}) script, which will create the design described in this exercise. If you use this script, download it to your "lab_ip" directory and then run it from the "Tools -> Run Tcl Script..." menu in Vivado. Make sure a previously created "proj" directory is removed before running the script.

13. Build your design by clicking on the "Generate Bitstream" button in the menu bar. It has a green down arrow and some binary digits. Click Yes and OK to the prompts. When the build is done, you can click Cancel (for Open Implemented Design).
14. Export the hardware design by clicking the menu option "File -> Export -> Export Hardware...". Make sure to select the "Include bitstream" option from the dialog box, then click OK. This is the hardware handoff step and generates an .xsa file for use by the next exercise.

## Exercise #2 - Create a Software Application for the Processor
1. You can launch Vitis from a terminal window by typing `vitis` on the command line or if you have Vivado still open, you can run Vitis by clicking the menu option "Tools -> Launch Vitis". Click Launch in the dialog window to use the default workspace location.
2. From the menu click "File -> New -> Platform Project...". For the Project name, use "basys_bsp". Click Next, then Next and then browse to the .xsa file. It should be in your "lab_ip/proj" directory. Once the .xsa file is found, click Open, and then Finish.
3. Build the basys_bsp platform by selecting it in the Explorer window and then clicking the build button in the menu bar. It looks like a hammer.
4. From the menu click "File -> New -> Application Project...". For the Project name, use "demo". For the System project use "basys_system" (overwrite the default). Click Next three times, then Finish.
5. Replace the default helloworld.c file with the demo below by overwriting it with a downloaded version or by copying and pasting it in the text editor. You can find the default file by opening the demo/src folder in the Vitis Explorer window. Double clicking on helloworld.c will open it in the Vitis text editor. Ctl-A will select all text in the text editor window.

Demo [helloworld.c]({% link resources/design_resources/helloworld.c %}).
```c
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
```

6. Build the demo application by selecting "demo" in the Explorer window and then clicking the build button in the menu bar.
7. Run the application on your board. First make sure that it is plugged into your computer with a USB cable and turned on. Right click on "demo" in the Explorer window. Select "Run As -> Launch on Hardware (Single Application Debug)". After a few seconds of download, your application should start running on the board. After the first time running an application, you can run it again by clicking the Run button in the menu bar. It is a green and white "play" button.

The text output printed from the application program can be seen by running a terminal program and connecting to the USB serial device (/dev/ttyUSB1 on lab machines). Configure the serial device for 9600 baud, 8 bits, 1 stop bit, no parity, and no flow control. Run PuTTY from the command line by typing `putty` or launch it from the application menu. From the PuTTY Configuration dialog, click on "Serial" in the "Category:" window on the left side to set the serial port options. You may need to scroll down to see it. Click "Open" to start a session.

## Exercise #3 - Personal Exploration
Modify the helloworld.c program to explore the functionality of your board and interact with the buttons, switches, and LEDs. Add code and features as needed. This is your chance to be creative. The following are just ideas and are not required.

Exploration Ideas
- Increase the delay defined by SS_DELAY in the helloworld.c program so that you can see the sequence of drawing digits on the seven-segment display. A value around 100000 for SS_DELAY will allow you to clearly see the sequencing.
- Think of some operation or function to control with the switches and display the result on the LEDs or seven-segment display.
- Think of events or operations to control with the buttons and display the action.
- Write a sequencer for the 16 LEDs that turns them on and off in a sequence so that the light seems to move across the board.
- Make the LEDs pulsate by controlling how long they are turned on. The brightness can be controlled by how long the LEDs are turned on versus off when toggling rapidly (also known as pulse width modulation).
- Make a reaction timer that counts how many loops occur between the time an LED turns on and a button is pushed.

<span style="color:red">What did you do to explore the board design? Describe the modifications or new features you added to the demo code.</span>

<span style="color:red">Paste your modified helloworld.c source code.</span>

### Accessing Buttons, Switches, and LEDs
An example of interacting with the buttons, switches and LEDs is given in the helloworld.c program. A few more details are given here to help you access individual buttons and switches. Make sure any usage of XIOModule functions occur after the call to `XIOModule_Initialize`. The XIOModule must be initialized before it is used, otherwise your program may hang or exhibit strange behavior.

- Button state is read by calling `XIOModule_DiscreteRead(&IOModule, GP_BUTTONS)`. The least significant 5 bits \[4:0\] returned from this function map to the (Center, Down, Right, Left, Up) buttons.
- Switch state is read by calling: `XIOModule_DiscreteRead(&IOModule, GP_SWITCHES)`. The lower 16 bits \[15:0\] are mapped to Switches 15 to 0.
- The LEDs are controlled by calling `XIOModule_DiscreteWrite(&IOModule, GP_LEDS, leds)`. The lower 16 bits \[15:0\] of the `leds` argument are mapped to LEDs 15 to 0.
- The 7-segment display is controlled by calling `XIOModule_DiscreteWrite(&IOModule, GP_7SEG, sseg)`. Bits \[11:8\] of the `sseg` argument map to the anode signals, bit \[7\] maps to the radix point, and bits \[6:0\] map to the segment signals.

Notice in the helloworld.c program that the state of all the buttons is contained in the `buttons` variable. The same applies to the `switches` variable. Each button or switch is mapped to a bit in one of these variables. How do you test for just one button being pressed or one switch being flipped? You can use the '&' operator in C to test if an individual bit is a '1' among the others in an integer value. For example, the following code tests if Switch 0 is on.
```c
if (switches & 0x1) {
    // Do something when Switch 0 is ON.
}
```
Similarly, a hex value of 0x4 would test if Switch 2 is on, and 0x8000 would test if Switch 15 is on.

If you introduce a variable that represents the state of your LEDs (e.g. a variable named `leds`), you can use the '|' operator in C to set a single bit in the variable. For example, the following code will set bit 4 (and turn on LED 4).
```c
leds |= 0x10;
```
A hex value of 0x8000 would set bit 15. Don't forget to pass the `leds` argument to the `XIOModule_DiscreteWrite()` function so that your intentions actually take effect.

Single bits can also be cleared to zero by a similar operation. This example clears bit 3 (and turns off LED 3).
```c
leds &= ~0x8;
```

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Show that you can download your design and run a modified version of the demo application on your board. Explain what is new or different about the modified demo application.</span>

# Final Questions
Answer the following questions:

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

<!-- Exercise Ideas
- Add a packaged version of the SevenSegmentController to a user IP library and use it in the design.
- Add a VGA controller to the user IP library and use it in the design.
-->
