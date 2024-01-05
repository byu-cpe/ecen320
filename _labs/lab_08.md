---
layout: page
toc: true
title: Debouncer
lab: Debouncer
---

# Introductory Video
Here is an introduction to the lab to help you with the big picture of what is to be built...

<iframe width="768" height="432" src="https://www.youtube.com/embed/uSAA6TGFucc?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<span style="color:red;">The average time to complete this lab is 4.5 hours.</span>

# Overview and Learning Outcomes
You will create a debounce state machine and use this state machine to debounce the button on the Basys 3 board to reliably count the number of times the button is pressed.
* Understand how to debounce noisy input signals.
* Demonstrate the ability to synchronize an asynchronous input.
* Demonstrate the benefits of a debounce circuit used to count button presses.
* Implement a state machine using behavioral SystemVerilog.

# Preliminary
Carefully read and review Chapter 26 of the textbook. This lab will closely follow that design.

Figure 26.1 in the textbook demonstrates the "noise" that occurs with mechanical buttons or switches. In this figure, the button signal starts at zero, transitions between zero and one, and then settles down to one. But, the same noise can happen when the button signal later transitions from one to zero.

<span style="color:red">Assuming a 100 MHz clock (10 ns period), how many clock cycles are needed to implement a delay of at least 5 ms?</span>

<span style="color:red">How many bits are needed for a counter to implement a 5 ms delay with a 100 MHz clock?</span>

<!--
** Verilog Functions **

In a number of situations it is necessary to determine how many bits are needed to represent an arbitrary decimal number using a binary number. The number of bits needed to represent a decimal number can be computed by taking the "ceiling" of the base-2 logarithm of that number. For example, the number of bits needed to represent the number 353,124 can be computed first taking the base-2 log: log2(353,124) = 18.4. Next, we take the "ceiling" (or round up) giving us 19. Thus, we need 19 bits to represent the number 353,124.

The following Verilog function, clogb2 (ceiling of base 2 logarithm), can be used in your Verilog modules to determine the number of bits needed to represent a decimal number:
```verilog
  function integer clogb2;
    input [31:0] value;
    begin
      value = value - 1;
      for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
        value = value >> 1;
      end
    end
  endfunction
```
You will need to use this function in your Verilog module in a later exercise. The following example demonstrates how you can use this function to determine the minimum width of a register.
```verilog
  localparam COUNTER_MAX_VALUE = 500,000;
  localparam COUNTER_BITS = clogb2(COUNTER_MAX_VALUE);
  reg [COUNTER_BITS-1:0] counter_reg;
```

<span style="color:red">
Demonstrate how this function computes the number of bits needed to represent the number 353.
</span>
-->

# Exercises

## Exercise #1 - Debounce State Machine
The first exercise is to create the debounce state machine. Begin this exercise by creating the module name and ports for your module as described below:

<!--
| Parameter | Type || Function |
| WAIT_TIME_US | integer (5000) || Determines the wait time, in micro seconds, for the debounce circuit |
| CLK_PERIOD_NS | integer (10) || Specifies the period of the clock in nano seconds |
-->

| Module Name = debounce ||||
| Port Name | Direction | Width | Function |
|------------------------------------------|
| clk | Input | 1 | 100 MHz System Clock |
| reset | Input | 1 | Active high reset |
| noisy | Input | 1 | Noisy debounce input |
| debounced | Output | 1 | Debounced output |

As shown in Figure 26.3, the debounce circuit described in Chapter 26 is composed of two parts: a state machine and a timer. You will need to create these two parts which will be described in more detail below.


### Debounce State Machine
The first part of this debounce circuit is the debounce finite state machine (Figure 26.4). You will need to create this state machine using behavioral SystemVerilog. The inputs to the state machine are "noisy", which is a module input, and "timerDone", which is an internal signal. The outputs of the state machine are the signals "debounced", which is a module output, and an internal signal named "clrTimer".

Create your debounce FSM using behavior SystemVerilog.

<img src="{% link media/lab_08/00_debounce_sm.png %}" width="750">

The diagram above shows a `clr` signal that resets/initializes your state machine. You should use your `reset` input to set your state machine to S0.

### Debounce Timer
The second part of the debounce circuit is the debounce timer. The purpose of this timer is to wait a predetermined amount of time for the noise input signal to settle down.

Many students try to re-use their mod-counter from the stopwatch lab for this timer. Don't. Can you see how the description of the timer above is just a bit different from that for the mod-counter? HINT: this counter does not need an increment signal since it should increment any time it is not being reset.

<!--
An important feature of this Verilog module is making it //parameterizable// so that you can support an arbitrary timer wait count for the debouncer. Add a "localparam" parameter named "TIMER_CLOCK_COUNT" to your Verilog module that indicates the number of clock cycles used for the timer in your state machine:

<code>
localparam integer TIMER_CLOCK_COUNT = WAIT_TIME_US * 1000 / CLK_PERIOD_NS;
</code>

Next, add the //clogb2// function described above into your Verilog module. You will use this function to determine how many bits are needed for your debounce wait counter.

The number of bits of this counter needs to be large enough to hold the maximum count of the counter (TIMER_CLOCK_COUNT-1). Determine the size of this signal using the //clogb2// function and declare the counter signal by using the results of the //clogb2// function.
-->

The description of the debounce timer is found at the end of section 26.1. For this design, however, you will be required to wait precisely 5ms instead of whatever the maximum value for your timer is. At 5ms your timer should assert "timerDone". Your counter should be cleared when clrTimer is asserted by the state machine. You DO NOT wire the reset signal for your overall circuit to the clr on the timer. Rather, the state machine is in charge here - your state machine design will reset the timer when it needs to.

**Exercise 1 Pass-off:** Show a TA your debounce module. Explain how you implemented the state machine and how the state machine should behave when it receives a noisy input.

## Exercise #2 - Debounce Simulation
After completing your SystemVerilog module, you will need to simulate your module to make sure it operates as described in the textbook. Create a Tcl simulation script that simulates your debounce module with the following conditions:
* A "short" noisy pulse that is not long enough to generate a valid debounce output
* A "long" noisy pulse that is long enough to generate a valid debounce output
* Enough time to see that debounced goes low after noisy goes low

<span style="color:red">Include a copy of your debounce module Tcl simulation script.</span>

After completing your Tcl simulation, download the following testbench file and simulate your debounce circuit with this testbench. Make sure the simulation runs as long as necessary until the "simulation done" message is received (this will take about 100ms of simulation time).

[tb_debounce.v]({% link resources/testbenches/tb_debounce.v %})

<span style="color:red">Include a copy of your testbench output that shows you had 0 errors.</span>

**Exercise 2 Pass-off:** No passoff, just make sure that you passed the testbench with zero errors.

## Exercise #3 - Top-Level Push Button Counter
For this exercise, you will create a top-level circuit that instances the debounce circuit for debouncing one of the push buttons. This debounce circuit will be used to increment a counter so you can verify that the counter increments only once for each button press. In addition to the debounce circuit, you will include a second counter that responds to undebounced button presses. You will compare the values of the two different counters to see the impact of debouncing. Begin this exercise by creating a SystemVerilog module with the following name and top-level ports:

| Module Name = debounce_top ||||
| Port Name | Direction | Width | Function |
|------------------------------------------|
| clk | Input | 1 | 100 MHz System Clock |
| btnu | Input | 1 | Active high reset |
| btnc | Input | 1 | Counter button input |
| anode | Output | 4 | Seven-Segment Display anode outputs |
| segment | Output | 8 | Seven-Segment Display cathode segment outputs |

### Debounce Counter
The purpose of this circuit is to accurately count the number of times a button has been pressed. Although this function sounds simple, it takes some effort to create a circuit to reliably count button presses. The figure below shows the four components involved in the circuit.
1. Synchronizer
2. Debounce State Machine
3. One-Shot pulse detector
4. Counter

<img src="{% link media/lab_08/01_debounce_counter.png %}" width="950">

The first part of this circuit is the "synchronizer" whose purpose is to synchronize the asynchronous button signal to the global system clock. Because this signal is not synchronized to the clock, it is possible that this signal could cause metastability in circuitry that follows, including the debounce state machine. You can synchronize the signal by feeding it through two flip flips, as described in Section 24.3 and shown in Figure 24.3 (the textbook uses only one flip-flop -- you will need to use two because of the 100 MHz clock rate).

Instance your `debounce` state machine and attach the output of the synchronizer to its input. The output of your state machine is now a synchronized, debounced version of the button input.

Add the "edge detector" circuit (also known as a one shot detector). The purpose of this circuit is to create a single clock cycle pulse when the debounced button signal transitions from a zero to a one. This single clock cycle pulse will be used to increment the button counter. If you attach the output of the debounce state machine directly into the input of your counter, the counter will increment continuously for as long as the button is pressed. The one shot is added to make sure that the counter is only incremented once each time the button goes through a 0->1 transition.

A one shot circuit can be implemented by feeding a signal through two flip-flops (F1, then F2) and then outputting the equation `F1 AND F2'`. This is shown in Figure 26.5 of the textbook.

The final part of this circuit is a counter that counts the button transitions. Create an 8-bit counter with an enable input. Attach the enable signal to the output of the one shot circuit. The output from the counter will be displayed on the seven-segment display. Use the reset input to clear this counter.

### Undebounced Counter
To demonstrate the behavior of the debounce circuit, a second counter is added to the top-level design which is incremented using a signal that is *not* debounced. The behavior of this counter will be contrasted with the debounced counter. You will use btnc as the input, the reset signal to clear, the synchronizer, an edge detector (one shot) circuit, and an 8-bit counter, but you will not use a debouncer. You can see this additional one shot and counter in the figure below.

<!-- <img src="{% link media/lab_08/02_nodebounce_counter.png %}" width="500"> -->

### Seven-Segment Display
After creating your two counters, instance the [Seven-Segment Controller]({% link resources/modules/seven_seg.md %}) and connect the seven-segment display as described below:
* You will use all 4 digits of the display
* Do not turn on any digit points
* Attach the 8-bit value of the _debounced_ counter to the lower 8 bits of the display
* Attach the 8-bit value of the _undebounced_ counter to the upper 8 bits of the display

Your top-level design should look something like this (clock, reset not shown).

<img src="{% link media/lab_08/03_lab_debounce.png %}" width="1000">

### Simulation
After completing your top-level module, create a Tcl script to simulate at least three "noisy" button presses on your top-level design. Verify that your design counts properly in these noisy button press situations.

<span style="color:red">Paste your Tcl script that tests the top-level module.</span>

<span style="color:red">Paste your **debounce** SystemVerilog module.</span>

<span style="color:red">Paste your **debounce_top** SystemVerilog module.</span>

**Exercise #3 Pass-Off:** Nothing to be passed off in person.

## Exercise #4 - Implementation and Download
After successfully verifying your top-level module, create and add a .xdc file to the project and proceed with the implementation of your design.

<span style="color:red">Provide a summary of your synthesis warnings.</span>

After successfully synthesizing your design, proceed with the implementation and bitstream generation of your design.

<span style="color:red">Indicate the number of Look-up Tables (LUT) and Input/Output (I/O) pins for your design.</span>

<!-- TODO: have them do a timing analysis on the circuit - this is the first fully synchronouos design -->

Once the bitstream has been generated, download your bitstream to verify that it works correctly. After downloading your circuit, press the button several times to see if you can see a difference between the counter using the debounce state machine and the counter that does not use the debounce state machine. What you see will depend on just how "bouncy" your button is. It may bounce almost every time you push it or it may rarely bounce.

<span style="color:red">Summarize the results from your experiments comparing the debounced counter value to the non-debounced counter value. Report the percentage of button pushes that bounce.</span>

<!-- TODO: Could consider an oscilliscope exercise. Is the logic analyzer able to captuer a 10 ns pulse? -->

**Exercise #4 Pass-Off:** Nothing to pass off in person here.

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Demonstrate your circuit operating on the FPGA board. After carefully reading through the entire lab, describe how your circuit meets all the requirements that were given. Be sure to demonstrate the bounciness of your button by pressing it multiple times and showing different counter values.
</span>

# Final Questions
<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>

<!-- <span style="color:red">Submit your SystemVerilog modules using the code submission on Learning Suite.</span> (Make sure your SystemVerilog conforms to the lab SystemVerilog coding standards). -->
