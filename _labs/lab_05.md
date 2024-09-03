---
layout: page
toc: true
title: Seven Segment
lab: Seven_Segment
---

<!--
Some differences:
- Add buttons to top-level so that buttons can disable the segment
-->

In this lab you will learn what a seven-segment display is and how it works.
You will create a digital circuit that drives a seven-segment display with hexadecimal characters.

<span style="color:red;">The average time to complete this lab is 4 hours.</span>

# Learning Outcomes
* Learn how a seven-segment display works.
* Create a seven-segment decoder digital circuit.
* Learn how to use SystemVerilog dataflow operators.
* Learn how to validate your circuit with a testbench.

# Preliminary
The Basys 3 board contains a 4-digit, seven-segment display as shown below. 
This display can be used to display any information you desire, such as a counter value, register values, a timer, etc. In this week's lab you will create a circuit to drive one digit of this display. 
Later in the semester, we will provide you with a module to drive all of the four digits at once. 
It will use the display module created in this lab. 
You will then use that full display in a number of labs as a way to display numerical information.

<img src="{% link media/lab_01/00_four_digit_display.jpg %}" width="250">

Before designing a seven-segment controller circuit, it is necessary to understand how the seven-segment display operates. 
As the name implies, a seven-segment display has seven discrete _segments_ that can each be individually turned on to make a variety of different characters. 
Each of the seven segments are labeled with a letter as shown in the image below:

<img src="{% link media/lab_05/01_seven-segments.png %}" width="100">

For example, the character "0" can be displayed on the seven-segment display by turning on segments **a**, **b**, **c**, **d**, **e**, **f**, and turning off segment **g**.

Each segment of the seven-segment display is driven by an individual **LED** (light-emitting diode). The schematic diagram below shows these LEDs used by a seven-segment display. In addition to the seven segments for displaying a character, many displays include an eighth LED for the **digit point** (the dot to the bottom right of the seven segments). This is commonly abbreviated to **DP** as seen below.

In this configuration, all eight LEDs share a common **anode** which enables the display. Each segment has its own **cathode** signal labeled CX where **X** represents the segment letter. For example, signal **CA** corresponds to the cathode signal for segment **a**.

To turn on an LED, there must be a sufficient voltage drop from anode to cathode. That is, the anode needs to have a high voltage ('1') and the cathode has to have a low voltage ('0'). Go back and read that last sentence again - what do you drive onto a cathode wire to turn a segment on?

To display the character **0**, the anode signal will have a high voltage, the cathode signals CA, CB, CC, CD, CE, and CF will have a low voltage, and the cathode signal CG will have a high voltage.

<img src="{% link media/lab_05/02_seven_segment_cathode.png %}" width="750">

Although any arbitrary combination of segments can be turned on, digital circuits are often created to display the 16 different characters representing any 4-bit value in hexadecimal. These characters are: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, and F. Each of these is shown in the image below.

<img src="{% link media/lab_05/03_seven_segment_font.png %}" width="750">

Before you can create a circuit to display these hexadecimal characters, you need to determine the value each cathode signal needs for each character.

Fill out the decoder table below so that the segment outputs on each row will display the number given by that row's hexadecimal character. 
Also included in this table is the binary representation of each hexadecimal character in the **D** columns. 
The first row of the table is completed and shows the segments that will be active for an input of **0**. 
Carefully look at the top entry (which will display a '0' digit) to make sure you understand.

<!--
Both the markdown and the html tables don't fit in a common sized browser window, so a screenshot from "powerpointExcelWord/Lab5-Seven Segment Decoder.pptx", Slide 32 is used instead.

| Hex | Input |||| Outputs |
| Character | Binary |||| Segments |
|  | D3 | D2 | D1 | D0 | A | B | C | D | E | F | G |
|-----------------------------------------------------|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 1 | 0 | 0 | 0 | 1 |  | | | | | | |
| 2 | 0 | 0 | 1 | 0 |  | | | | | | |
| 3 | 0 | 0 | 1 | 1 |  | | | | | | |
| 4 | 0 | 1 | 0 | 0 |  | | | | | | |
| 5 | 0 | 1 | 0 | 1 |  | | | | | | |
| 6 | 0 | 1 | 1 | 0 |  | | | | | | |
| 7 | 0 | 1 | 1 | 1 |  | | | | | | |
| 8 | 1 | 0 | 0 | 0 |  | | | | | | |
| 9 | 1 | 0 | 0 | 1 |  | | | | | | |
| A | 1 | 0 | 1 | 0 |  | | | | | | |
| b | 1 | 0 | 1 | 1 |  | | | | | | |
| C | 1 | 1 | 0 | 0 |  | | | | | | |
| d | 1 | 1 | 0 | 1 |  | | | | | | |
| E | 1 | 1 | 1 | 0 |  | | | | | | |
| F | 1 | 1 | 1 | 1 |  | | | | | | |

  <table>
    <tr>
      <th>Hex</th><th>Input</th><th width="500"></th><th></th><th></th><th>Outputs</th><th></th><th></th><th></th><th></th><th></th><th></th>
    </tr>
    <tr>
      <th>Character</th><th>Binary</th><th width="500"></th><th></th><th></th><th>Segments</th><th></th><th></th><th></th><th></th><th></th><th></th>
    </tr>
    <tr>
      <th></th><th>D3</th><th width="500">D2</th><th>D1</th><th>D0</th><th>A</th><th>B</th><th>C</th><th>D</th><th>E</th><th>F</th><th>G</th>
    </tr>
    <tr>
      <td>0</td><td>0</td><td width="500">0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td>
    </tr>
    <tr>
      <td>1</td><td>0</td><td width="500">0</td><td>0</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>2</td><td>0</td><td width="500">0</td><td>1</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>3</td><td>0</td><td width="500">0</td><td>1</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>4</td><td>0</td><td width="500">1</td><td>0</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>5</td><td>0</td><td width="500">1</td><td>0</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>6</td><td>0</td><td width="500">1</td><td>1</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>7</td><td>0</td><td width="500">1</td><td>1</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>8</td><td>1</td><td width="500">0</td><td>0</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>9</td><td>1</td><td width="500">0</td><td>0</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>A</td><td>1</td><td width="500">0</td><td>1</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>b</td><td>1</td><td width="500">0</td><td>1</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>C</td><td>1</td><td width="500">1</td><td>0</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>d</td><td>1</td><td width="500">1</td><td>0</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>E</td><td>1</td><td width="500">1</td><td>1</td><td>0</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
    <tr>
      <td>F</td><td>1</td><td width="500">1</td><td>1</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
    </tr>
  </table>

  -->

Decoder Table<br>
<img src="{% link media/lab_05/table.png %}" width="500">

After filling in the decoder table for a seven-segment display:
1. <span style="color:red">Provide the requested segment values from the decoder table.</span>
2. <span style="color:red">Provide a logic equation for segment A (CA).</span>

If you're confused about how to make an equation for a segment, remember that a whole column represents an individual output. Simply pick the column for the segment as labeled in the table as a truth table output and read off the equation.

On Learning Suite, you will only have to fill in a few sections of this table. But, make sure that your entire table is correct -- it will make the rest of this lab much easier.

## The Board's 7 Segments
The seven-segment display on the Basys 3 board has _four_ unique digits as shown below.

Each digit of the four-digit display has its own anode input (A0-A3).
NOTE however, that there is a built-in inverter on each anode signal. 
Thus, to turn on any of the segments of a digit, its corresponding anode and cathode signals must both be _driven LOW_. 
The schematic of this four-digit, seven-segment display is shown below.

<img src="{% link media/lab_05/04_digits_diagram.JPG %}" width="850">

This four-digit, seven-segment display configuration is known as a **common cathode** arrangement because the cathode signals are shared among all four digits. 
If more than one anode signal is asserted low, the corresponding digits will have the same segments turn on because they are connected to the same cathode signals.
 While this significantly reduces the pin count, it makes it difficult to display different values simultaneously. 
 (Different values can be displayed by quickly switching between the various anode and cathode signals --- the LED's will flash so quickly your eye will see them as all being "on". 
 This is called "time-multiplexing" the digits. 
 You will be given a time-multiplexing seven-segment display controller to use in future laboratory assignments.)

For example, to turn on only the right two digits of the four digit display, AN1 and AN0 must have a logic value of **0** and the other anode signals must have a logic value of **1**.

In the following example, two of the digits are turned on by setting their corresponding anode to zero.
 The other digits are off since their anode signals are set to one. 
 In addition, the digit **3** is displayed based on which cathode signals have a logic **0**. 
 The digit point is also on since the cathode signal, DP, associated with the digit point is set to **0**.

<!-- FIXME: width of table too wide -->

| A3 | A2 | A1 | A0 |
|:-- |:-- |:-- |:-- |
| 1  | 0  | 0  | 1  |

| DP | CG | CF | CE | CD | CC | CB | CA |
|:-- |:-- |:-- |:-- |:-- |:-- |:-- |:-- |
| 0  | 0  | 1  | 1  | 0  | 0  | 0  | 0  |

<img src="{% link media/lab_05/05_4_digit_colored.JPG %}" width="200">

<span style="color:red">What would happen if all four anode control signals were set to a logic value of **0** simultaneously in the example above?</span>

<span style="color:red">Determine what will be shown on the display with the following signal values.</span>

| A3 | A2 | A1 | A0 |
|:-- |:-- |:-- |:-- |
| 0  | 1  | 0  | 1  |

| DP | CG | CF | CE | CD | CC | CB | CA |
|:-- |:-- |:-- |:-- |:-- |:-- |:-- |:-- |
| 1  | 1  | 1  | 1  | 1  | 0  | 0  | 0  |

<img src="{% link media/lab_05/06_4_digit_gray.JPG %}" width="200">

# Exercises

## Exercise #1 - Seven-Segment SystemVerilog
In this exercise you will create a seven-segment decoder in a SystemVerilog module. 
You will create the logic for just one digit. 
Begin by [creating a new Vivado project]({% link tutorials/lab_03/00_vivado_project_setup.md %}) like you did in the previous lab (you will create a new project for each laboratory assignment).
Remember to always follow the steps in the Project Configuration section to properly configure the error messages and other settings in your project. 
Also remember to use the correct FPGA part number.

After creating this project, create a new SystemVerilog file with the following module name and ports:

| **Module Name**: seven_segment |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| data | Input | 4 | Data input to display on the seven-segment display |
| segment | Output | 7 | Cathode signals for seven-segment display (excluding digit point). segment[0] corresponds to CA and segment[6] corresponds to CG |

Review the page on [Combinational Logic Styles]({% link resources/design_resources/combinational_logic_styles.md %}) since you are going to be required to implement each segment using a different SystemVerilog coding style. 
Note that for this lab you need not use `always_comb` blocks so you can skip those for now. 
But, you will use them in future labs so remember this page so you can go back there to review them when the time comes.

Create the logic necessary for your cathode segments (CA to CG) (for this circuit, you will not create logic for the digit point (segment[7])).

You are required to use a mix of combinational logic styles. 
For your seven segments, you must have at least one segment that uses each of the following styles:
* Structural SV (gates like in Lab 3), in non-minimized, sum-of-products form.
* Structural SV, minimized using the theorems in Table 4.1 of the textbook.
* Dataflow SV, using an `assign` statement and the `?:` (sometimes called the ternary) operator.
* Dataflow SV, using an `assign` statement and dataflow operators of your choice (comparison, and, or, etc.).

<!-- Removed due to scheduling with lectures
* Behavioral SV, using an `always_comb` block, and if/else statements.
* Behavioral SV, using an `always_comb` block, and case statements.
-->

Once you have completed the logic for your seven-segment decoder, proceed with the simulation of your module using a Tcl script. 
Your Tcl file should simulate all 16 possible digits to see if the output of your module matches that seven-segment decoder table you created above.

<span style="color:red">Include your Tcl simulation file in your report.</span>

**Exercise 1 Pass-off:** Show a TA your SV code, Tcl commands and simulation.

## Exercise #2 - Verification with a Testbench
A testbench circuit has been created for you in this lab to test your seven-segment decoder. 
Test your seven-segment decoder circuit using the testbench by following these steps.

1. Download the [tb_sevensegment.v]({% link resources/testbenches/tb_sevensegment.v %}) testbench file.
2. If needed, review the [Adding a Testbench and Simulating with a Testbench]({% link tutorials/lab_04/01_testbench_tutorial.md %}) tutorial.
3. Add the testbench to your project (as a simulation source file).
4. Start simulating the testbench and carefully view the messages. If you have errors, carefully debug these errors and simulate again until you have no errors. When you pass the testbench without any errors, you are ready to proceed to the next exercise.

<span style="color:red">Copy and paste the testbench console output into your report (the console should report no errors).</span>

**Exercise 2 Pass-off:** Nothing to pass off, just be sure it is passing the testbench.

## Exercise #3 - Top-Level Design
Begin this exercise by creating a second SystemVerilog file with the following module name and ports:

| **Module Name**: seven_segment_top |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| sw      | Input  | 4 | Input from four switches to drive seven-segment decoder. |
| btnc    | Input  | 1 | Center button (will turn on digit point when pressed). |
| segment | Output | 8 | Cathode signals for seven-segment display (including digit point). segment[0] corresponds to CA and segment[6] corresponds to CG, and segment[7] corresponds to DP. |
| anode   | Output | 4 | Anode signals for each of the four digits. |

The figure below demonstrates the structure of this top-level design. 
You will also create some additional logic in this top-level design.

<img src="{% link media/lab_05/07_seven_top_diagram.JPG %}" width="650">

### Instance Seven-Segment Decoder Module
Begin your top-level module by instancing the seven-segment display module you created in the previous exercise.

Connect the four-bit switch input ports from your top-level design to the data inputs of your seven-segment display. 
Connect the 7 segment bits (segment[6:0]) from your seven-segment display outputs to bits [6:0] of the top-level segment output.

### Digit Point
Your seven-segment decoder module drives seven of the eight cathode segment signals (segment[6:0]). 
The eighth segment signal (segment[7]) is used for the "digit point". You need to create logic to _turn on_ the digit point (DP or segment[7]). 
For this top-level design, we want to turn on the digit point when **btnc** is pressed. 
Create a logic circuit using structural SystemVerilog in your top-level module for the digit point based on the value of **btnc**. 
Remember that the cathode segment signals are turned on when the logic value of **0** is given.

### Anode Signals
The last component of your top-level design is the logic to drive the anode signals. 
For this top-level design, you will need to create logic that turns on the right most digit (associated with anode[0]) and turn off the other three digits (anode[3:1]). 
To turn on the right most digit, we simply need to assign the 'anode' output with a constant value (reread above if needed to learn what constant value to use). 
Add a dataflow `assign` statement in your top-level SystemVerilog file to assign the anode signals such that only the right most digit is turned on. 
The following SystemVerilog statement can be added to set the anode signals (you will need to replace the "X" values with actual '1's or '0'):

```verilog
assign anode = 4'bXXXX;
```

<!--
The last step of this top level Verilog design is to create the logic for the eight anode signals. The logic for the anode signals should be designed to meet the following specifications:
* When no buttons are pressed, turn on //only// the rightmost digit, digit 0 (corresponding to anode[0]).
* When the left button is pressed, **btnl**, turn on all 8 digits (no matter what the value of btnr is). All 8 digits will display the same value as dictated by the switches and btnc for **DP**.
* When the right button is pressed, **btnr**, turn off all 8 digits (including digit 0). Note that this condition has lower priority than the previous condition. If both the right and left buttons are pressed at the same time, all digits should be turned on as described in the previous condition.

Note that your center button //does not// affect your anodes at all. It only affects segment[7]. Do not include the center button in your logic for the anodes.

In your top level design, the logic for anode[0] signal (driving digit 0) will be different from the logic for the anode[7:1] signals (driving digits 1-7). Since the logic for the anode signals anode[7:1] is all the same, it is best to use one signal to drive all of them. Assuming you have a logic signal named **anode_1_7** you can drive anode outputs 1-7 with this signal using the **buf** primitive as shown in the following example.

<code Verilog>
buf(anode[1],anode_1_7);
buf(anode[2],anode_1_7);
buf(anode[3],anode_1_7);
buf(anode[4],anode_1_7);
buf(anode[5],anode_1_7);
buf(anode[6],anode_1_7);
buf(anode[7],anode_1_7);
</code>

Complete the [[tutorials:hierarchy_vivado_tutorial]] tutorial to learn about adding hierarchical modules in the Vivado design suite. Make sure your hierarchy is correct before proceeding to the next exercise.
-->

After completing your top-level design, simulate it to make sure your digit point (DP) logic and your anode logic is correct. 
Also, simulate all possible data inputs to verify your top-level circuit is working properly.

<span style="color:red">
Paste your top-level module SystemVerilog code.
</span>

<span style="color:red">
Attach a screenshot of your working simulation waveform to Learning Suite.
</span>

**Exercise 3 Pass-off:** Nothing to pass off - just answer the questions above.

## Exercise #4 - Implement and Download
<!-- do we want to have them look at the elaborated design pre-synthesis? */
/* [[tutorials:viewing_design_elaboration]] -->

Begin this process by [creating]({% link tutorials/lab_03/05_making_an_xdc_file.md %}) and [adding]({% link tutorials/lab_03/06_adding_an_xdc_file.md %}) an XDC constraints file. 
Do this like you have done in previous labs.
 Remember, the easiest way to create this file is to start with the [master .xdc]({% link resources/design_resources/basys3_220.xdc %}) file and modify it.

Once you have the XDC file added to your project, [synthesize]({% link tutorials/lab_03/07_synthesis.md %}) your project.

<span style="color:red">Provide a summary of your synthesis warnings and an explanation of why they do or do not matter (be careful -- it will be rare when a warning can be ignored, but it does happen; you just need to figure out when that is).</span>

[Implement]({% link tutorials/lab_03/08_implementation.md %}) your module.

<span style="color:red">Indicate the number of LUTs and I/O pins your design uses.</span>

You can find this in the the **Utilization** box within the "Project Summary" window (use the "Post-Implementation" tab).

[Generate a bitfile]({% link tutorials/lab_03/09_bitgen.md %}) for your design, download your circuit, and verify that it works as expected.

# Final Pass-Off:
Do the pass-off in person with a TA or by video:

<span style="color:green">Show your circuit working correctly on the board and explain what you are doing. Show that it displays digits properly as you manipulate the switches and btnc.</span>

<span style="color:green">Explain (in some detail) why you aren't able to display two different numbers on two different digits at the same time on the display.</span>

# Final Questions
<span style="color:red">Paste your 'seven_segment' SystemVerilog module code.</span>

And, as always, make sure your SystemVerilog conforms to the lab SystemVerilog coding standards.

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

<!--
# Personal Exploration
There is no personal exploration this week.
/*
Here are some ideas for personal exploration in this laboratory:
* Create a different seven-segment decoder that implements a different font (upside down, letters in the alphabet, your own unique character set, etc.)
* Change the behavior of the top-level design. Here are some ideas:
  * Turn on all of the segments or some sub-set of the segments
  * Add additional buttons and use the buttons to selectively turn on or off the segments
  * Use additional switches and multiplex the switches using a button
* Experiment with the simulator and learn new features, tools, or Tcl commands
<span style="color:red">Describe your personal exploration activities</span>
*/

/* Listing of errors helped with:
 - One student made his .tcl simulation file as a constraints file (had a .tcl extension but was in the Design Sources pane). Synthesis didn't like that...

*/
-->