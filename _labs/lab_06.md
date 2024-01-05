---
layout: page
toc: true
title: Fun With Registers
lab: Registers
---

**Originally written by Prof Brent Nelson**

In this lab you will do some experimentation with flip-flops to learn how they operate. You will create a single-bit loadable register, a 4-bit loadable register, and a counter.

Here is a video intro to the lab:
<iframe width="768" height="432" src="https://www.youtube.com/embed/MIE5j9WLap8?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<span style="color:red;">The average time to complete this lab is 3 hours.</span>

# Learning Outcomes
* Create a sequential circuit using FDCE flip-flop primitives
* Learn how to organize multiple flip-flops into a register
* Create a clearable, incrementable 4-bit counter

# Preliminary
The Artix-7 FPGA we are using has built-in flip-flops that you can use to make sequential circuits. You will use FDCE flip-flop **primitives** to construct a few simple register-type circuits. The FDCE flip-flop is available to you without any extra work required on your part, you merely need to instance it into your design the same way you instance your own modules into your designs. Refer to the following pdf file to learn about the FDCE module, its ports, and how to instance the module in your SystemVerilog.

[fdce.pdf]({% link media/lab_06/00_fdce.pdf %})

The SystemVerilog example below demonstrates how to instance a single FDCE flip-flop into a design:
```verilog
FDCE my_ff (.Q(ff_output), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(ff_input));
```

The example shown above assigns a constant zero to the CLR input and a constant one to the clock enable (CE) since we will not use those functions. As a result, what you are getting is basically a D flip-flop with input D, output Q and a clock C. NOTE: this is a rising edge triggered flip-flop.

# Exercises

## Exercise #1 - 1-Bit Register
For this exercise you will create a 1-bit register. It is exactly the circuit in Figure 16.4 in the textbook. Begin this exercise by creating a new Vivado project and an empty SystemVerilog module with the following name and ports.

| Module Name: FunRegister |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| CLK | Input | 1 | Clock input |
| DIN | Input | 1 | Data to be loaded into register |
| LOAD | Input | 1 | Control signal to cause register to load |
| Q | Output | 1 | Register output |
| NXT | Output | 1 | Next value going to the register (we want to monitor it as an output of this module) |

Note that in Figure 16.4 there is an unlabeled signal --- it is the output of the MUX (which is also the input to the flip-flop). Label it in your textbook with the name NXT. It is the NXT signal in the table above. It is the value the flip-flop will load on the next edge of the CLK signal (and thus the name NXT). It is NOT the output of the counter, it is the next state value for the counter. Just to better understand our circuit we want to see it in our design and so we are bringing it out of the module as an output. But, normally we would not be doing anything with this signal other than just feeding it into the flip-flop.

First, instance one FDCE flip-flop as shown above. Then, add either a single dataflow statement or an always_comb block to implement the MUX logic. HINT: our recommendation is to use a dataflow assign statement instead of an always_comb block. It is simpler, requires less typing, and is less error-prone (given the possibility of inferred latches).

You should now have logic which implements the MUX and have the MUX wired to the ports on the FDCE. This is called a "loadable register". On each rising edge of CLK, If LOAD is high, then the flip-flop will load what is on its DIN input. On the other hand, if LOAD is low, then the flip-flop will load its old value (thus retaining its old value).

SANITY CHECK: your code should have only 2 lines if you use a dataflow assign statement to implement the MUX logic or 5-8 lines if you use an always_comb block. If it has a lot more, you are likely on the wrong track...

After creating your register, simulate your register with a Tcl script. The following set of Tcl commands demonstrates a simple test for your register file. You can use this script and add to or modify it to test your register as you like.
- Make sure that your Tcl file includes a `run 100ns` at the beginning. For the first 100ns, the FDCE primitive resets itself. During this time it won't operate at all, so wait for this time to be over.
- The line that defines the oscillating clock signal will be used in all labs for the rest of the semester - it is how you get a clock to drive your flip-flops.

```tcl
restart

# set inputs low
add_force LOAD 0
add_force DIN 0

# add oscillating clock input with 10ns period
add_force CLK {0 0} {1 5ns} -repeat_every 10ns

# run for 100ns so the FDCE can properly reset
run 100 ns

# load a 0
add_force LOAD 1
run 20ns
add_force LOAD 0

# change DIN and run some time
# notice that the register doesn't
# load this new value because
# the load signal is low
add_force DIN 1
run 18ns

# now load the register
add_force LOAD 1
run 10ns
add_force LOAD 0
add_force DIN 0
run 10ns

# now apply various data
# input values and watch
# the register load them
# on succeeding clock edges
add_force DIN 1
run 10ns
add_force LOAD 1
run 10ns
add_force DIN 0
run 10ns
run 10ns
run 10ns
add_force DIN 1
run 10ns
run 10ns
add_force DIN 0
```
<span style="color:red">Under what conditions does the value of NXT change?</span>

<span style="color:red">Under what conditions does the value of Q change?</span>

**Exercise 1 Pass-off:** No need for pass off. Just make sure it works in simulation before you proceed.

## Exercise #2 - 4-bit Register
In this exercise, you will modify your register to be 4-bits wide as shown in Figure 16.5 of the textbook. Make a copy of your file containing the FunRegister module and call it FunRegister4.sv. Remember to change the module name also to FunRegister4. The changes needed to your code are minimal: (a) make the DIN, NXT, and Q signals 4-bits wide in your module definition and (b) instance a total of 4 FDCE flip-flops and wire them up like the one in Exercise #1. If you have used a ?: operator or an if-then-else statement to describe your MUX, you probably shouldn't even have to change the MUX code.

<span style="color:blue">Note: An easy way to copy a file is to use the Linux command `cp`. Open a Linux terminal window and `cd` to your project directory. After making the copy, click on the "plus" icon in the "Sources" window to add the file to your project. You can then open it from the "Sources" window and modify it with the Vivado editor.</span>

Make sure to set the FunRegister4 module as the top module for simulation. In the "Sources" window, expand "Simulation Sources", right click on the module name and then select "Set as top". Also, make sure the previous simulation for a different module is closed. If needed, go to the "File" menu and click on "Close Simulation".

After creating your 4-bit register, simulate it with a modified copy of your Tcl script from the previous exercise. The only changes that you should have to make are to change the 1 and 0 values you drive into DIN to be more interesting numbers between 0000 and 1111.

<span style="color:red">Provide a copy of your Tcl script you used to simulate the 4-bit register.</span>

<span style="color:green">
Attach a screenshot of your 4-bit register working correctly in simulation. Make sure it shows that your register loads 4-bit values from DIN when LOAD=1 and keeps its old value otherwise. Also show that the NXT signal does indeed precede the value of Q.
</span>

## Exercise #3 - 4-bit Counter
We are now going to modify a copy of your file containing the 4-bit register module to create a 4-bit counter and use the counter to blink some lights.

In addition to holding values, registers can be used to create counters. Figure 16.7 from the textbook shows such a counter. It can be cleared and it can be incremented under control of the signals CLR and INC. If both CLR and INC are asserted, do nothing.

| Module Name: Counter ||||
| Port Name | Direction | Width | Function |
|------------------------------------------|
| CLK | Input | 1 | Clock input |
| CLR | Input | 1 | Clear control signal |
| INC | Input | 1 | Increment control signal |
| Q | Output | 4 | Counter register output value |
| NXT | Output | 4 | Next value going to the counter register |

Create a Counter module by copying your file containing the FunRegister4 module and then making the following modifications.

* Change the name of the module to Counter and update the header.
* Change your module definition to reflect the port signals in the table above.
* Create combinational logic using either a ?: dataflow assignment or an always_comb if statement to implement the MUX of Figure 16.7 in the textbook (dataflow assignment statement is recommended).
* Wire the MUX up to the register's input and output wires.

Modify a copy of the Tcl script from the previous exercise to simulate the counter. First, clear the counter and then increment for 3 clock cycles (30ns). Then, clear it again for 2 clock cycles (20ns) and then run the circuit for a total of 20 clock cycles (200ns). Raise and lower INC over this time to observe that it only counts on rising clock edges when INC is true. Increment it enough times so that it rolls back to 0 after the count reaches F.

<span style="color:red">Provide a copy of your Tcl script you used to simulate the 4-bit counter.</span>

<span style="color:green">
Attach a screenshot of your 4-bit counter simulation waveform. Show that your counter works as desired. Be sure to show it clears and increments when requested and doesn't do either when not requested. Also show that the value of NXT precedes the value of Q.
</span>

## Exercise #4 - Synthesize, Implement, and Test in Hardware
You are now ready to test your counter in hardware.

First, you will need to make a top module (Counter_Top) for this exercise. Instantiate your counter module in the top-level module. Then, use the seven-segment decoder module you designed in the previous lab to decode the Q outputs of your counter and show its value on the right most digit of the seven-segment display. To do this, copy the seven-segment decoder module source (seven_segment.sv) to your current project directory. Then click on the "plus" icon in the "Sources" window to add the file to your project. Create an instance of your seven_segment module and connect the data signals to the Q outputs of your counter. Finish by connecting the remaining signals to the top-level port signals as described in the following table. The anode signals and the digit point (segment[7]) can be set with a constant value.

| Module Name: Counter_Top ||||
| Port Name | Direction | Width | Function |
|------------------------------------------|
| btnc | Input | 1 | Use the center button to simulate the CLK signal |
| sw | Input | 2 | Use sw[1] for INC and sw[0] for CLR signals |
| segment | Output | 8 | Cathode signals for 7-segment display |
| anode | Output | 4 | Anode signals for 7-segment display |
| led | Output | 4 | Show binary value of NXT |

Based on the top-level module description above, create an XDC file to map the top-level port signals to the respective board components. Remember, the easiest way to create this file is to start with the [master .xdc]({% link resources/design_resources/basys3_220.xdc %}) file and modify it.

**Note**: In your top-level module, you will connect the clock signal (CLK) of your counter to a button (btnc); however, Vivado knows that this is not a true clock pin and will report an error. In order to get Vivado to ignore this, you will need to add the following line to your constraints file, which you can add immediately after the btnc constraint:
```tcl
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets btnc];
```

Even with this inserted, you will still get a warning, which you can ignore (at least it is now a warning and not an error). This is the only lab where you will tie the CLK input to a button. In all later labs, it will be tied to a 100MHz clock on your board.

Perform the steps of Synthesis, Implementation, and Bitstream Generation. Download your design and demonstrate that it is working properly.

When you turn on CLR (sw[0]) you should immediately see that NXT (led[3:0]) is 0. When you then push the CLK (the center button) the flip-flop will actually load that 0 value to Q and you will see it on the right most digit of the 7-segment display. Then, when you then deassert CLR (sw[0]) and assert INC (sw[1]) you should see that NXT becomes Q+1. When you push the CLK (the center button) you should see the counter increment and then immediately NXT (led[3:0]) will become the new value of Q+1.

### Bouncing Buttons - Huh?
You may notice that, in actuality, your counter may increment more than once when you push the CLK button. Why? It is because the CLK input is tied directly to a button. In the real-world, buttons and switches don't transition cleanly from open to closed or from closed to open. As they are opening or closing they may "bounce", meaning they may open and close rapidly in succession just due to the mechanics of them being spring loaded switches.

Thus, when you push your CLK button and then let go, the circuit might actually get multiple clock edges like this: 0-1-0-1-0-1-0. In that case your circuit would see 3 rising clock edges and your counter would increment by 3. At other times it might just go 0-1-0 and your counter will increment by 1. Experiment with it to see just how "bouncy" the button is on the board you are using. It might be pretty bad or it might hardly ever bounce. In a later lab you will design a circuit to clean up the button signal by ignoring the bouncing. But, for now we have to live with it.

AWESOME! You have designed your first sequential circuit.

<span style="color:red">
For 20 pushes of the center button, record how many times the counter increments by more than one count per push. When it counts by more than one, how far does it jump? What does this tell you about the bouncing behavior of your button?
</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Show your counter circuit working on the board. As you demonstrate your circuit, explain what button is being pressed or what switch is being moved. Be sure to show that the counter can be cleared at various points in its count sequence. Be sure to show what happens when both CLR and INC are asserted at the same time and that it matches the function you were told to implement. Be sure to show that you can do any of the following: nothing, CLR, INC.
</span>

# Final Questions
<span style="color:red">Paste your 4-bit counter SystemVerilog module.</span>

<span style="color:red">Paste your top-level SystemVerilog module.</span>

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Describe any problems you had on this lab.</span>

<!--

# Personal Exploration

Choose one of the following for personal exploration in this laboratory:
* Make your counter wider and wire up to additional LEDs.
* Wire in a copy of your 7-segment decoder from last week and have the 4-bit counter value displayed on the 7-segment display. By the way, this is way cooler than just making your counter wider... :-)

<span style="color:red">Describe your personal exploration activities.</span>

= Lab Report =

* **Header**
  * Class
  * Lab
  * Name
  * Section
* **Preliminary**
  * Q waveform
* **Exercise 1**
  * Simulation screenshot
  * 4-bit register Verilog
* **Exercise 2**
  * Tcl script
  * Register file Verilog
* **Exercise 3**
  * Top-level Verilog
* **Exercise 4**
  * Synthesis warnings
  * Number of LUTs and FFs
* Personal exploration description
* Hours spent on lab
* Feedback
-->