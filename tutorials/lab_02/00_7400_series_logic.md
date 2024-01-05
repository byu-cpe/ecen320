---
layout: page
toc: true
title: 7400 Series Logic Devices
lab: 1
---

# History
The [7400 Series](https://en.wikipedia.org/wiki/7400_series) of logic **IC**s (integrated circuit) were an industry standard for logic for many years. These devices implement all the basic logic gates in a simple **DIP** (dual-inline package). A DIP is an electronic component with a rectangular housing and two parallel rows of connecting pins. Most 7400 series logic devices have 14 pins.

The amount of logic available in 7400 series logic devices is small and these devices are not widely used for complex systems. FPGAs or **ASIC**s (application specific integrated circuits) are used instead when complexity is needed.

7400 series ICs are still used for simple digital logic projects and hobbyists today. You will use discrete 7400 series ICs to implement simple logic functions. There are a large number of different [7400 series ICs](https://en.wikipedia.org/wiki/List_of_7400_series_integrated_circuits) available for implementing any digital logic function. These devices can be easily obtained online or in the EE shop in room CB 416.

We will use the following three 7400 devices:

| Device | Logic Function |
|-------------------------|
| 7408 | Quad 2-input AND gates |
| 7432 | Quad 2-input OR gates |
| 7404 | Hex Inverters |

The logic within these devices and their pin functions are shown below:

![]({% link media/tutorials/lab_02/00_7400_series_logic/00_all_3_chips.png %})

# Identifying the chip
The different chips look the same and you must be careful to choose the correct one. You can identify the part number by the text on the top of the device. Sometimes the printed text on the chip is faint and hard to read. Try tilting the chip to view the text in a better angle of light. If you really can't read it, just get another chip.

The devices have several numbers and letters on them that can be used to identify the circuit. Different manufacturers use different annotations so the instructions here may not apply to all chips everywhere. Refer to the image below for the following explanation.
* The first set of numbers on the top line of the chip below are manufacturer specific numbers identifying when and where the device was made (we don't care about this).
* The next set of numbers on the bottom line identify the device function.
  * The first two letters ''SN'' indicate that the device was made by **Texas Instruments**.
  * The ''74'' indicates this is a 7400 series device.
  * The ''LS'' indicates that this is a **Low-power Schottky** device that operates between 4.75–5.25 Volts.
  * The final ''32'' indicates this is the **7432 Quad 2-input OR gate**.
  * The ''N'' indicates that this is a **DIP**.

When combined, the highlighted numbers below specify the circuit, in this case 7432. For this lab, these are all you need to worry about.

![]({% link media/tutorials/lab_02/00_7400_series_logic/01_identify_chip.jpg %})

# Using the chips
It is relatively easy to use these chips in creating more complex digital logic circuits. Before hooking up the chip, you need to properly orient it in order to correctly identify the pins. This is done according to the **notch** that is shown on the left side of each chip in the diagram above. The pin numbers are oriented with respect to this notch.

With the notch on the left side of the chip, Pin 1 can be found below the notch and Pin 14 is above the notch. The pin numbering starts at 1 in the bottom left of the device and increases by one as you proceed to the bottom right side of the chip (Pin 7). The top right continues with pin 8 and increases as you move to the left until you reach Pin 14 in the top left corner of the chip.

![]({% link media/tutorials/lab_02/00_7400_series_logic/00_all_3_chips.png %})

Once you have properly oriented the chip and identified the pin numbers, you are ready to hook up the device to make a logic circuit. There are essentially two separate steps to hook the device up.

1. Properly power the device
2. Attach the inputs and the outputs

These are explained in detail in the following sections.

# Power the Device
All integrated circuit devices need power in order to operate. Dedicated pins are provided on all devices to provide this power. Each chip needs a connection to +3.3V power (**VCC**) and ground (**GND**). Powering the device is relatively easy but you must be very careful when doing so. If you make a mistake and power the chip improperly you will likely burn it up and destroy it. <span style="color:red">Pin 14</span> (**VCC**) on these devices must be connected to to +3.3 Volts. It is highlighted in red on the figures above and needs to be connected on every chip you use. <span style="color:blue">Pin 7</span> (**GND**) in blue needs to be connected to ground on every chip.

Make sure you double check your power and ground connections before turning on the power. As stated above, you can quickly destroy a device if you mix up these inputs.

# Attach Inputs and Outputs
The next step in using these devices is to attach the inputs and the outputs. Any output from a 7400 series device can be connected directly to an input of a 7400 device. Switch inputs can be provided as inputs and LEDs (with proper current limiting resistors) can be connected to the outputs.

When placing IC chips on the breadboard, only place them across the **gutter**, as explained in the [Building Logic Circuits on a Breadboard]({% link tutorials/lab_02/01_using_the_breadboard.md %}) tutorial.

![]({% link media/tutorials/lab_02/00_7400_series_logic/02_chip_on_gutter_explain.jpg %})
