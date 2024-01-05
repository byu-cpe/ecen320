---
layout: page
toc: true
title: Board Intro
lab: Board
---

In this lab you will familiarize yourself with digital numbers, digital systems, and applications of digital systems by experimenting with the digital FPGA development board that you will use throughout the semester.

<span style="color:red;">The average time to complete this lab is 1 hour.</span>

# Learning Outcomes
* Become familiar with the lab FPGA board.
* Learn about simple logic equations, binary numbers, and applications of digital systems.

# Exercise #1 - Introduction to the Basys 3 Development Board
During the course of the semester you will build various digital systems using digital logic. You will complete these using the **[Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/start)** development board. You will be using this board throughout the semester so it is important to familiarize yourself with the board and learn how to use it. In this exercise, you will use the Basys 3 development board to explore a variety of digital system functions.

A picture of this board is shown below -- you should have purchased your own board for use in this class.

![](https://reference.digilentinc.com/_media/reference/programmable-logic/basys-3/basys-3-2.png)

In the center of this board is an **Integrated Circuit** (IC) device called a **Field Programmable Gate Array** or FPGA (this is the square device labeled **ARTIX-7**). This FPGA device is the heart of the board and contains the programmable digital logic that you will use in most of your lab exercises. An FPGA device is a programmable digital circuit that can be configured to perform many different functions based on the user's digital design. You will be creating digital circuit designs during the semester and placing these circuits onto the FPGA device. The circuit that is configured onto the FPGA is defined in a file called a **bitstream**. These files are created by software from the manufacturer of the FPGA. You will be creating your own circuit bitstreams throughout the semester, but not in this lab.

The following page contains a video giving an overview of this Basys 3 board: [Overview of the Basys 3 Board]({% link tutorials/lab_01/03_basys3.md %}). Watch the video.

Now, check to make sure the blue jumpers are set as shown in the [Basys 3 jumpers tutorial]({% link tutorials/lab_01/04_setting_up_the_basys3_jumpers.md %}). If they aren't, correct them.

<span style="color:red">What is the proper jumper setting of Jumper JP2?</span><br>
(You'll have to look closely at the board to find which one is JP2.)

<span style="color:red">What is the proper jumper setting of Jumper JP1?</span>

Now, connect the Basys 3 board to your host computer and turn on its power using the switch in the top left corner of the board. When you first turn the board on, the FPGA device will be programmed with a configuration file for a digital circuit that is saved on the board's memory. This digital circuit implements a number of functions on the seven-segment display, switches, buttons, and VGA display. Once the FPGA has been configured (as indicated by the **DONE** LED), the circuit is operational. Answer the following questions about the functionality of this digital circuit:

<span style="color:red">What do you see on the seven-segment displays?</span>

<span style="color:red">Describe, for each one, what happens when you push the various buttons (BTNC, BTNL, BTNR, BTNU, BTND)?</span>

<!--<span style="color:red"> What is happening to the two tri-color LEDs in the center of the board by the FPGA? </span>-->

<!-- Other possible questions:

What does “FPGA” stand for?

<span style="color:red"> Summarize what the default program does, and explain what the two connecting cables do. </span>

-->

# Exercise #2 - Digital Logic and Binary Numbers
In this next exercise, you will configure the FPGA with a different circuit. To use and experiment with this new circuit, you need to load [this configuration, or bit, file]({% link resources/example_bitfiles/basys3byuuserdemo.bit %}) onto the FPGA. You will be loading bit files on the the FPGA for **every** lab each week. You will be creating your own bit files in future lab assignments from the circuits you design.

In this case, download the above bitfile onto your computer using whatever mechanism your browser supports.

Follow [this tutorial]({% link tutorials/lab_01/05_downloading_bitfile.md %}) (top part) to program the FPGA with the new bit file using Xilinx tools.

<!--(NOTE: if you are using Adept 2 to program the board instead of Vivado, follow [this tutorial]({% link tutorials/lab_01/06_downloading_to_the_basys3_using_adept.md %}) instead.) -->

After being programmed, the FPGA should now be acting differently in its behavior than when you first powered it on.

## Seven-Segment Display
The Basys 3 board has a 4-digit seven-segment display. You will create a circuit to control this display in a future lab.

![]({% link media/lab_01/00_four_digit_display.jpg %})

Press different buttons on the board to see what happens to this display. When none of the buttons are pressed, the display on the right-most digit is determined by the settings of the first four switches (SW3-SW0).

<span style="color:red">Determine the value of the digit for all 16 combinations of switches SW3-SW0.</span>

| SW3 | SW2 | SW1 | SW0 | Digit |
| --- |
| 0   | 0   | 0   | 0   |
| 0   | 0   | 0   | 1   |
| 0   | 0   | 1   | 0   |
| 0   | 0   | 1   | 1   |
| 0   | 1   | 0   | 0   |
| 0   | 1   | 0   | 1   |
| 0   | 1   | 1   | 0   |
| 0   | 1   | 1   | 1   |
| 1   | 0   | 0   | 0   |
| 1   | 0   | 0   | 1   |
| 1   | 0   | 1   | 0   |
| 1   | 0   | 1   | 1   |
| 1   | 1   | 0   | 0   |
| 1   | 1   | 0   | 1   |
| 1   | 1   | 1   | 0   |
| 1   | 1   | 1   | 1   |

<!-- ### Tri-Color LEDs

The NEXYS4 board also has two \*\*tri-color LEDs\*\* (labelled LD17 and LD 16 on the board). Each of these LEDs actually contains three LEDs one each for the colors red, green, and blue. Different colors can be made from different combinations of the colors. The color of both LEDs is determined by the values of SW6-SW4 (SW6 = Red, SW5 = Green, and SW4 = Blue). <span style="color:red">Determine the colors for all eight combinations of switches SW6-SW4 in the table below.</span>

\^ SW6 \^ SW5 \^ SW4 \^ LED Color \^ | 0 | 0 | 0 | | | 0 | 0 | 1 | | | 0
| 1 | 0 | | | 0 | 1 | 1 | | | 1 | 0 | 0 | | | 1 | 0 | 1 | | | 1 | 1 | 0
| | | 1 | 1 | 1 | |-->

## LEDs
Above each of the 16 switches is a small green LED (labeled LD15 to LD0). The last five LEDs from left to right (LD4 to LD0) are each outputs to boolean logic equations based on switches SW6-SW4 (from left to right).

<span style="color:red">Determine the state of each LED (on=1, off=0) for all 8 combinations of switches SW6-SW4.</span>

| SW6 | SW5 | SW4 | LD4 | LD3 | LD2 | LD1 | LD0 |
| --- |
| 0   | 0   | 0   |
| 0   | 0   | 1   |
| 0   | 1   | 0   |
| 0   | 1   | 1   |
| 1   | 0   | 0   |
| 1   | 0   | 1   |
| 1   | 1   | 0   |
| 1   | 1   | 1   |

<!--
##### Exercise #4 - Audio

The NEXYS4 board also includes an omnidirectional MEMS microphone. This is located near the left middle of the board and is labeled \*\*MIC\*\*. This microphone uses an Analog Device ADMP421 chip to capture audio and digitize it into \*\*PDM\*\* (pulse density modulated) format. This chip is constantly digitizing the audio and sending the digital data to the FPGA device. The circuit is configured to record the audio data and store it in the 128 Mega bit DDR memory. It will then play this stored audio file back on the audio out jack. Perform this experiment by following these steps:

` - Attach your headphones to the Audio Out Jack of the NEXYS 4 board`\
` - Press the up button, labeled **BTNU** on the board. Once you press this button, the circuit will save or record all audio. The recording is indicated by the LEDs turning on from left to right. Talk into the microphone during this recording time.`\
` - After five seconds of recording, the circuit will then play back the audio. This playback  is indicated by the LEDs turning on from right to left.`

<span style="color:red"> Based on what you heard, what can you say about the microphone and speaker setup: is it high or low quality, is it stereo or mono?</span>
-->

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Demonstrate the operation of your board and describe your answers to the experiments. Be sure to show: a) what happens when you flip the switches and push the buttons on the board when it is first powered up, and b) show how the new bitfile you used to program the board works and affects its operation.
</span>

# Final Questions
Answer the following questions:

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

<!--
## Personal Exploration

As described in the <tutorials:laboratory_instructions> tutorial, you are sometimes required to do a simple personal exploration exercise for some labs. The intent is to have you learn more by doing something additional.

Here are a few choices for personal exploration activities for this lab. Choose one and do it and describe it in your lab book:

` * The circuit configured on this FPGA has a secret six-bit code embedded in the logic. You can unlock this code by experimenting with the values on switches SW15-SW10. See if you can find this secret code by trying all combinations of SW15-SW10. Test your code by pressing the center button (BTNC). The code is only tested when BTNC is pressed. You should see different behavior on the LEDs when you press this button with the correct secret code.`\
` * Pressing BTNL will show a continuous counter counting with Hexadecimal. See if you can estimate the rate at which this counter is counting (i.e., counts per second).`

<span style="color:red">Describe your personal exploration activities.</span>

##### Lab Report

` * **Header**`\
`   * Class  `\
`   * Lab`\
`   * Name`\
`   * Section`\
` * **Exercise 1**`\
`   * CAEDM username`\
`   * 3 questions`\
` * **Exercise 2**`\
`   * 4 questions`\
` * **Exercise 3**`\
`   * Seven-Segment Display table`\
`   * Tri-Color LED table`\
`   * Single color LED output table`\
` * **Exercise 4**`\
`   * 3 descriptions of what you see`\
` * Personal exploration description`\
` * Hours spent on lab`\
` * Feedback`

-   /

------------------------------------------------------------------------

[TA Notes and Feedback](labs:ta:introduction "wikilink")
-->