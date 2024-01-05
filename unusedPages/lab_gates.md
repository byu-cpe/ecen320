---
layout: page
toc: true
title: Discrete Gates
lab: Gates
---

In this lab you will apply your understanding of Boolean algebra and digital gates to implement two logic functions using discrete logic gates. You will interface your logic gates to the Basys 3 board and test your logic function with switches and LEDs on the board.

# Learning Outcomes
* Apply logic minimization using Boolean algebra on a simple logic function.
* Build a circuit using 7400 series digital logic gates and interface it with the Basys 3 board.

# Preliminary
You will create two digital circuits that implement two logic functions. These two logic functions are defined below.

A laptop is being produced that requires a circuit which will activate an alarm if the laptop's battery is low and turn on the internal fan if the laptop's temperature is too high. The circuit also depends on whether the laptop's power cord is plugged in or not. The inputs and outputs of this circuit are as follows:

|Inputs|
|------|
|C| Cord Plugged In |
|B| Low Battery |
|T| High Temperature |

|Outputs|
|-------|
|A|Alarm|
|F|Fan|

The circuit operation of the alarm and the fan is defined in the following truth table:

|Inputs|||Outputs|
|C|B|T|F|A|
|---------|
|0|0|0|0|0|
|0|0|1|1|0|
|0|1|0|0|1|
|0|1|1|0|1|
|1|0|0|0|0|
|1|0|1|1|0|
|1|1|0|0|0|
|1|1|1|1|0|

- <span style="color:red">Write out the Boolean equations for the outputs **A** (Alarm) and **F** (Fan) in **SOP** (sum of products) form. (Chapter 6.2)</span>
- <span style="color:red">Use Boolean algebra to minimize the Boolean equations from the previous step. In particular, come up with a logic equation that reduces the number of logic operations (AND/OR/INVERT) and the size of the logic operations. Make sure to show your work. (Chapter 6.4)</span>

<!-- - <span style="color:red">Draw the gate schematics for these two equations using AND, OR, and NOT gates found in these 7400 series devices.</span> */ /* ((Chapter 4.1)) -->

# Exercises

## Exercise #1 - Creating Digital Circuits with 7400 Series Discrete Gates
In this first exercise, you will design the Alarm Fan circuit using 7400 series gates. To begin this exercise, carefully read the [7400 Series Logic Devices Tutorial]({% link tutorials/lab_02/00_7400_series_logic.md %}).

Create a schematic drawing of your circuit for the fan alarm using 7400 ICs. You can create your schematic circuit diagram in one of two ways:
1. You can draw your circuit diagram by hand.
2. You can create a diagram electronically. You may want to use the following [PowerPoint slide]({% link media/lab_02/00_three_7400_device_template.pptx %}) with 7400 devices and add lines to the slide to form a circuit according to your design.

Your diagram must include each of the following:
* Draw each 7400 series device that you need in order to implement both equations (just as big rectangles). Label each device with the part number and label each pin of the chip.
* Draw connections for VCC and GND for each of the devices in the circuit.
* Draw wires for the inputs to your logic equations and clearly label them.
* Draw wires for the two primary outputs (F and A) and label them.
* Draw wires between the various gates of the 7400 series devices to implement the correct logic equation.

The example below demonstrates a circuit diagram to give you an idea of what your circuit diagram might look like. It demonstrates a circuit diagram for a 7400 series schematic circuit that implements the function: `Z = AB' + ABC'`.

Note: This is just an example diagram and you should not build your circuit according to this diagram.

<img src="/media/lab_02/01_gates_example.png" width="800">

<span style="color:red">Attach a PDF or photo of your circuit diagram.</span>

**Exercise 1 Pass-off:** Show a TA your circuit diagram and explain how you know it is correct.

<!-- *Have the TA sign your lab book to verify that you passed it off correctly* -->

## Exercise #2 - Constructing Your Circuit on the Breadboard
The next exercise in this laboratory is to build your logic circuit onto a **breadboard**. This involves obtaining the 7400 chips from the TA, placing them on your breadboard, and then wiring up the chips according to the drawing you created in the previous exercise.

1. Read the [Building Logic Circuits on a Breadboard Tutorial](/tutorials/lab_02/01_using_the_breadboard).
2. Build your design based on your drawing in the previous exercise on the breadboard using the provided wires and IC chips.
3. Make sure the Basys 3 is **turned off**.
4. Connect the breadboard to the Basys 3 as described in the [Attaching the Basys 3](/tutorials/lab_02/01_using_the_breadboard) section of the breadboard tutorial.
5. Using the table below, connect the switch signals (SW0-SW2) from the Basys 3 board to the inputs of your circuit and the outputs of your circuit to the LEDS of the Basys 3.

| Name | I/O Pin | Basys 3 Assignment |
| Inputs |
|--------|
| C | J1-4 | SW2 |
| B | J1-3 | SW1 |
| T | J1-2 | SW0 |

| Outputs |
|---------|
| A | J2-1 | LED 0 |
| F | J2-2 | LED 1 |

<span style="color:red">How many wires did you need to build your circuit? Include **all** the wires you used in your count, including wires for powering the circuit, wires for the inputs and outputs, and wires between the 7400 series chips.</span>

**Exercise 2 Pass-off:** Show a TA your circuit and have them check that it will not damage the board. Do not turn on the Basys 3 board until you have reviewed your circuit with a TA. It is relatively easy to damage the logic chips on the FPGA board if you hook up your logic circuit incorrectly.

<!-- *Have the TA sign your lab book to verify that you passed it off correctly* -->

## Exercise #3 - Powering and Testing Your Circuit with the Basys 3
1. Make sure the jumpers on the Basys 3 board are setup properly by following the [Setting Jumpers on the Basys 3 Board](/tutorials/lab_01/04_setting_up_the_basys3_jumpers) tutorial.
2. Download the [alarm_fan.bit](/resources/example_bitfiles/alarm_fan.bit) configuration bit file.
3. Turn the Basys 3 board **on** (make sure there is no smoke or any other evidence of damage from the chips or wires before proceeding).
4. Configure the FPGA board with the downloaded bit file using [Vivado](/tutorials/lab_01/05_downloading_bitfile) or [Adept](/tutorials/lab_01/06_downloading_to_the_basys3_using_adept).

At this point, the FPGA board should provide the switch inputs to your circuit and the LEDs will display the logic produced by your circuit. Test all input combinations to make sure your two functions (F and A) are producing the correct results.

If their operation does not match the truth table given at the beginning of the lab, your circuit has a mistake! Turn off the Basys 3 and make changes as necessary. **Have a TA check your circuit each time before you turn the Basys 3 back on.**

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Demonstrate the function of your circuit and that it is operating correctly.</span>

After you complete pass-off, return your chips and wires to their respective bins in the lab.

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>
