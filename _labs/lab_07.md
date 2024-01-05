---
layout: page
toc: true
title: Stopwatch
lab: Stopwatch
---

# Some Introductory Videos to Get You on the Right Track<br>(and Keep You Out Of Trouble)
Here is a video introduction to the lab:

<iframe width="768" height="432" src="https://www.youtube.com/embed/CUeUaOWnzDI?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<br>

And, in this lab you are going to have to convert between frequency and time to answer some of the questions. Here is a video with a short tutorial on doing this:

<iframe width="768" height="432" src="https://www.youtube.com/embed/nuzDjl21fC0?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# Overview
In this lab you will create a digital stopwatch. As shown in the video above, the stopwatch will be displayed on the four-digit seven-segment display.
* Digits 3:2 will display seconds, digits 1:0 will display hundredths of a second.
* Switch 0 will start and stop the timer.
* Button btnc will reset the timer.

<!--<iframe width="768" height="432" src="https://www.youtube.com/embed/c4hfuvQAtW4?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
-->

<span style="color:red;">The average time to complete this lab is 4 hours.</span>

# Learning Outcomes
* Create a sequential circuit using multiple counters.
* Practice with SystemVerilog hierarchy and parameters.

# Preliminary

## Seven-Segment Controller
Read about the [Seven-Segment Controller]({% link resources/modules/seven_seg.md %}) module that is provided to you. The module cycles through the four seven-segment digits, lighting up one at a time. Answer the following questions after becoming more familiar with the SevenSegmentControl control module.

<span style="color:red">Why doesn't the Seven-Segment Controller just display all four digits at the same time?</span>

<span style="color:red">How long (in microseconds) is each digit illuminated?</span>

<span style="color:red">What value is needed on the digitDisplay input port of the SevenSegmentControl module to enable all four digits?</span>

<span style="color:red">What value is needed on the digitPoint input port of the SevenSegmentControl module to only turn on the third digit point from the right?</span>

# Exercises

## Exercise 1: Modulus Counter
At the heart of your stopwatch will be a counter module for each of the four digits. The counter should be a modulus counter, meaning it counts up to some predetermined value, then rolls over to 0 and continues counting.

You will use a SystemVerilog parameter, `MOD_VALUE` to indicate the modulus value. The counter should reach `(MOD_VALUE-1)` and then roll over to 0. This approach will allow us to use this module for digits that count 0-9, as well as digits that count 0-5. Consult the _Parameterization in Dataflow SystemVerilog_ section in the textbook (Chapter 14) for an example on adding parameters to your SystemVerilog modules.

<img src="{% link media/lab_07/00_mod_counter.png %}" width="500">

| Module Name = mod_counter |||
| Parameter | Default Value | Description |
|------------------------------------------|
| MOD_VALUE | 10 | Sets the modulus value of the counter. The counter will count from 0 up to (MOD_VALUE-1), then continue again at 0. |

| Port Name | Direction | Width | Description |
|---------------------------------------------|
| clk | Input | 1 | 100 MHz Input Clock |
| reset | Input | 1 | Reset |
| increment | Input | 1 | When high, increment the counter value on the next clock edge. |
| rolling_over | Output | 1 | High when the counter is about to roll-over (increment is high __and__ counter is at the maximum value). NOW, re-read the previous sentence carefully - it is NOT asserted just when the counter is at the maximum value. Do you see the difference? |
| count | Output | 4 | The counter value |

What you need to do:
* Create a Vivado project.
* Write the SystemVerilog for the `mod_counter` module.
  * NOTE: the vast majority (>90%?) of students write the logic for their `rolling_over` wrong the first time. Why? Go re-read the description for this signal above a third time. Exactly what is the logic condition for this signal? Does it involve the 'clk' signal and a register or is it purely combinational logic? If you put the code to generate this signal inside an `always_ff` block, will it generate a register or will it generate combinational logic? What is it that you really want?
* Create a Tcl simulation script, and verify that your counter is working. Make sure your simulation is thorough; for example, check that the counter only counts when `increment` is high, and that the `rolling_over` output is high only in the appropriate condition. Also, don't forget to do the Tcl file in this general order: a) set up the clocking, b) reset the design and simulate a few cycles, and then c) exercise the rest of your counter functionality.
* A common problem in your Tcl simulation script is forgetting to reset your counter before using the `increment` signal. So, put lines to do that at the beginning of your Tcl file.

<span style="color:red">Include your mod_counter Tcl simulation script in your lab report.</span>

**Pass-Off:** Show the TA your simulation and explain how you tested the correctness of your module.

## Exercise 2: Stopwatch Module
In this exercise you will create the stopwatch module which will consist of four instances of your `mod_counter` module . Each of these instances will be responsible for generating the value for one digit of the display. In addition, you will create one counter which will serve as a timer module to output a pulse every 0.01 second. The figure below shows the main components of your `stopwatch` module.

### The "mod_counter" Modules
Your stopwatch will contain at least four copies of your `mod_counter`. Each counter's `rolling_over` output is fed into the `increment` signal for the next most significant digit, as shown below. You will need to declare those intermediate signals as local signals in your SystemVerilog code.

Make sure you set the `rolling_over` parameter for each of your `mod_counter` instances. Each of the digits should roll over after 9 except for the left most digit which rolls over after 5. The most significant two digits represent seconds and the lower two digits represent 1/100th of a second.

### The 0.01s "timer" Module
Note the module in the upper left -- this is a counter that rolls over every 0.01s. When this counter rolls over, it should generate a **single cycle pulse** on its output. That pulse then is the input to the `increment` signal for the least significant digit of the 4 digits. This 0.01s counter should increment every cycle that the `run` input is high, and reset to 0 if the `reset` input is high (where reset takes precedence).

<span style="color:red">Given that the system clock is 100MHz, what is the highest count reached by the timer module before it rolls over every 0.01s?</span>

<span style="color:red">How many bits are needed to hold the high count in the 0.01s timer module with a 100MHz clock?</span>

To answer this question you should a) compute how long (in seconds) one clock period is for a 100MHz clock. Then calculate how many of those will fit into a 0.01s interval. That is the maximum count value for this counter. Also, once you compute this, you should then be able to calculate how many bits wide the counter should be. Remember: you can only count from 0-15 using 4-bits, to count from 0-1023 takes 10 bits, to count from 0-2047 takes 11 bits, and so on. Once you know the maximum count value and the number of bits for the counter, you can design it.

You have two ways to design this timer, you can choose which to use.
1. The first way is to simply design this counter very similarly to how you designed the `mod_counter` module. In fact, you could largely just copy the code and change the number of bits in the counter.
2. The second way is to modify your `mod_counter` module to be parameterized for width and then just instance another copy of it. Note that it already is parameterized with a `MOD_VALUE` parameter for its maximum count. If you simply add a **second parameter** to parameterize number of bits for the counter signal, you can then just instance another copy of your `mod_counter` design for this `timer` module.
  * The textbook example on parameterization shows how to parameterize signal widths.
  * To add a second parameter in the module definition, you just separate it from the first using a comma like this: `#(parameter PARAM1 = val1, PARAM2 = val2)`.
  * Then, when you instance it, you add a second value inside the parens like this: `mod_counter #(10, 495) TIMER (clk, run, ...)`.

<img src="{% link media/lab_07/01_stopwatch.jpg %}" width="750">

### The Stopwatch Design
Now that you have all the blocks designed, create a `stopwatch` module and instance all of the needed modules inside it.

Some things to remember:
1. You will need to declare local signals for those wires in the diagram below that are not input or output signals.
2. Note that the `timer` module output ('count') is not tied to anything. You will still need to declare a local signal and connect it to the `timer` module, but that signal will not connect to anything else in your `stopwatch` module.

| Module Name = stopwatch ||||
| Port Name | Direction | Width | Description |
|---------------------------------------------|
| clk | Input | 1 | 100 MHz Input Clock |
| reset | Input | 1 | Active-high reset |
| run | Input | 1 | High when timer should be running, 0 when stopped |
| digit0 | Output | 4 | The value of the hundredths of a second digit |
| digit1 | Output | 4 | The value of the tenths of a second digit |
| digit2 | Output | 4 | The value of the seconds digit |
| digit3 | Output | 4 | The value of the tens of seconds digit |

Create a Tcl simulation script to simulate the behavior of your `stopwatch` module. You will likely need to simulate for several milliseconds to check that the lower digits are functioning correctly. It will take too long to simulate the upper digits, so you will have to wait until next exercise to test it on the board. In your simulation, make sure to check that:
* The digitX outputs increment appropriately.
* Your least significant digit increments every 0.01s.
* The stopwatch only runs when the `run` input is high.
* The digits roll over correctly.
* The rest works after it has counted for some time.

<span style="color:red">Include your stopwatch Tcl simulation script in your lab report.</span>

<span style="color:green">
Include a screenshot of your simulation showing that your stopwatch module works.
</span>

## Exercise 3: Top-Level Module
In this exercise you will create the top-level module and test your stopwatch on the board.

Create the top-level module as follows:

| Module Name = stopwatch_top |
| Port Name | Direction | Width | Description |
|---------------------------------------------|
| clk | Input | 1 | 100 MHz Input Clock |
| btnc | Input | 1 | Active-high reset |
| sw| Input | 1 | High when stopwatch should be running, 0 when stopped |
| anode| Output | 4 | Seven-segment anode values, from Seven-Segment Controller |
| segment| Output | 8 |Seven-segment segment values, from Seven-Segment Controller |

Your top module should:
* Instantiate both your `stopwatch` module, as well as a [Seven-Segment Controller]({% link resources/modules/seven_seg.md %}) module.
* Connect your digit values output from the `stopwatch` module to the `dataIn` input of the `SevenSegmentControl`.
* Turn on the appropriate decimal point.
<!-- * **Note:** The CPU_RESETN button is active-low. This means it behaves differently than the other buttons you have used: it is a `0` when pressed and a `1` otherwise. **You will need to invert the signal when connecting it to your `stopwatch` and `SevenSegmentControl` modules.** -->

Be sure to include an appropriate constraints file:
* **Note:** For this lab, and all subsequent labs that use the `clk` pin, you should also uncomment two lines near the top that refer to the clock. One line connects the clock; the other line after it tells Vivado that the clock runs at 100MHz.

Make sure your SystemVerilog conforms to the lab SystemVerilog coding standards.

<span style="color:red">Paste your mod_counter SystemVerilog module.</span>

<span style="color:red">Paste your stopwatch SystemVerilog module.</span>

<span style="color:red">Paste your stopwatch_top SystemVerilog module.</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Demonstrate the operation of your stopwatch and explain what you are doing. Show how you can clear it with a button press and how you can start and stop it by flipping the switch. Time it to verify that it really is counting seconds at the correct rate. Also, describe how long it will take for the counter to completely roll over and show it if you can.
</span>

# Final Questions
<span style="color:red">
How many hours did you work on the lab?
</span>

<span style="color:red">
List the problems you encountered in this lab. What made it take longer than it should have (from your expectation)?
</span>