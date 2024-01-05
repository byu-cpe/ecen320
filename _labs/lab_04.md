---
layout: page
toc: true
title: Arithmetic
lab: Arithmetic
---

In this lab you will implement a two's complement binary adder and an overflow detector in a hierarchical design and demonstrate the ability to perform binary addition and subtraction and overflow detection..

<span style="color:red;">The average time to complete this lab is 4.5 hours.</span>

# Learning Outcomes
* Demonstrate understanding of two's complement addition, subtraction, and overflow detection
* Develop a hierarchical design with three levels of hierarchy
* Validate the circuit with a testbench

# Preliminary
In this preliminary exercise, you will work through some binary arithmetic examples. Answer the following questions to demonstrate your understanding of two's complement representation, sign extension, negation, addition, subtraction, and overflow detection. You may want to refer to Chapter 3 of the textbook specifically as you complete this preliminary work.

<span style="color:red">
Determine the decimal value for the following eight-bit _two's complement_ binary numbers:
</span> (See Section 3.3)
```
10000100
00011001
```
<span style="color:red">
Extend each of the following numbers to nine bits using _sign-extension_. Include leading zeros in the binary result:
</span> (See Section 3.3.1)
```
10000100
00011001
```
<span style="color:red">
_Negate_ each of the following eight-bit two's complement numbers. Include leading zeros in the binary result:
</span> (See Section 3.3.2)
```
10000100
00011001
```
Overflow can be detected by inspecting the sign bit of the operands and the result. The sign bit is the MSB. If the sign bit of the two operands are different, then overflow can not occur. If the sign bit of the result is opposite the two operands, two's complement overflow has occurred.

<span style="color:red">
Perform _addition_ with the following eight-bit two's complement numbers. Include leading zeros in the binary result. Indicate if overflow occurs with a '#' sign at the beginning of the 8-bit result:
</span> (See Sections 3.3.3 and 3.5.1)
```
1)   10000100
   + 01100100

2)   01111111
   + 10011001

3)   01111111
   + 01100111

4)   00011010
   + 01001001

5)   11100110
   + 10110111

6)   10000100
   + 10011001
```
Subtraction can be performed with an adder circuit if the second operand is inverted before the operation and the carry-in is set to one. This method is equivalent to negation of the second operand followed by addition. In the following cases, you should negate the second number and then use two's complement addition to calculate the result.

<span style="color:red">
Perform _subtraction_ with the following eight-bit two's complement numbers. Include leading zeros in the binary result. Indicate if overflow occurs with a '#' sign at the beginning of the 8-bit result:
</span> (See Sections 3.3.2, 3.3.3, and 3.5.1)
```
1)   10000100
   - 01100100

2)   01111111
   - 10011001

3)   01111111
   - 01100111

4)   00011010
   - 01001001

5)   11100110
   - 10110111

6)   10000100
   - 10011001
```
# Exercises
## Exercise #1 - 8-bit Binary Adder

In this exercise, you will create an 8-bit two's complement full adder for implementing arithmetic. You will do this with two SystemVerilog files:
1. A single-bit full adder module (FullAdd.sv)
2. A multi-bit adder that combines eight single-bit adders (Add8.sv)

This is a classical ***hierarchical design***: you will create a simple 1-bit full adder module and you will then create a new module and instance 8 of your 1-bit adders inside it to build up your circuit.

### 1-bit Full Adder
Start by creating a [new Vivado project]({% link tutorials/lab_03/00_vivado_project_setup.md %}) for this lab. Make sure you follow the steps in the Project Configuration section to properly configure the error messages and other settings in your project. Next, create an empty SystemVerilog file named "FullAdd.sv" and add the following ports to this module as described in the table below:

| Module Name: FullAdd |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| a | Input | 1 | 'a' operand input |
| b | Input | 1 | 'b' operand input |
| cin | Input | 1 | Carry in |
| s | Output | 1 | Sum output |
| co | Output | 1 | Carry out output |

Once you have created the empty module with the ports outlined above, create the single-bit **full adder** cell as shown in Figure 9.2 of the text. Like the diagram, your circuit should include a 3-input XOR gate, three 2-input AND gates, and a 3-input OR gate. **Note** that you must use _structural_ SystemVerilog to create this full adder cell. Although there are easier ways to create adder circuits using dataflow SystemVerilog, you are required to use structural SystemVerilog for this lab.

And, remember, the coding standard says you must either use meaningful signal names or add comments to describe what the local signals you declare with the 'logic' keyword are. For structural designs like this, coming up with meaningful signal names can be klunky (some students use names like aANDb, aANDcin, bANDcin, ...). In later labs this can be come totally unwieldy and is not recommended.

You might just consider using comments like this (less typing, more clear):
```verilog
// The outputs of the 3 AND gates in the full adder
logic a1, a2, a3;
```

Once you have created your circuit, simulate the full adder by testing all possible input conditions. Create a Tcl file to provide the stimulus for this simulation. The Tcl code below simulates two of the eight conditions.
```tcl
# Simulate a=0, b=0, cin=0 for 10 ns
add_force a 0
add_force b 0
add_force cin 0
run 10 ns

# Simulate a=1, b=1, cin=1 for 10 ns
add_force a 1
add_force b 1
add_force cin 1
run 10 ns
```

<span style="color:red">Paste your full adder SystemVerilog code.</span>

<span style="color:red">Paste your full adder Tcl simulation script.</span>

### 8-Bit Adder
As mentioned above, this lab will involve **hierarchy**. This is covered in-depth in Chapter 11, but will be briefly explained here.

A circuit with hierarchy is a circuit that contains modules within modules. In many complex digital logic circuits there are many levels of hierarchy. In this circuit you will have three levels of hierarchy - your FullAdd, your Add8, and a top-level module. For this step you will create the Add8 module which will **instance** 8 FullAdd modules. Program 11.1.1 in your textbook gives an example of instancing modules. In this case, three "mux21" modules are instanced to build a "mux41" module. NOTE: when you instance a module as shown in Program 11.1.1, there is an extra identifier required between the module name and the open parentheses to start the port list. The discussion below Program 11.1.1 in the textbook explains what it is for - do read it and follow it.

Begin the creation of an 8-bit ripple-carry adder by making a new SystemVerilog file named Add8.sv and add the following ports as shown in the table below:

| Module Name: Add8 |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| a | Input | 8 | 'a' operand input |
| b | Input | 8 | 'b' operand input |
| cin | Input | 1 | Carry in |
| s | Output | 8 | Sum output |
| co | Output | 1 | Carry out of last stage |

After creating the empty module, create the needed local wires (you will need some, figure out where). For example, the carry signals that go between the various adder stages is one place where you will need them. You could declare each such carry signal individually with names like c3, c4, ... Or, you could declare a multi-bit wire and use indexing with square brackets to get at the various bits. It is your choice.

Insert 8 instances of your **FullAdd** module into your Add8 module (as described in Section 9.1 of the textbook and as shown in the figure below). You should use the .port(wire) way of mapping ports on instances to your wires (see Program 11.1.2 in the textbook). Note that the **co** (1 bit) output of your Add8 is the carry-out of the last FullAdd instance.

<img src="{% link media/lab_04/00_add8.png %}" width="1000">

Simulate the behavior of your 8-bit adder by creating a Tcl script of your own. Provide at least one input condition for each of the following cases to test your adder. You could use the examples for addition in the Preliminary section above. Note that this 8-bit adder does not implement overflow detection. You will have to examine the simulation output to determine if there is overflow.

1. Add a positive binary number to a negative binary number.
2. Add two positive binary numbers without overflow.
3. Add two positive binary numbers with overflow.
4. Add two negative binary numbers without overflow.
5. Add two negative binary numbers with overflow.

Rather than assigning each bit of an input with a single Tcl command, you can assign all 8 bits of an input with a single "add_force" command as shown in the following example:
```tcl
add_force a 11000101
```
Read the following [Tcl Tutorial 2]({% link tutorials/lab_04/00_tcl_tutorial_2.md %}). This tutorial contains additional examples and instruction for creating Tcl files.

The default display format for signals in the simulation window is binary. It may be inconvenient to examine your simulation result in binary. You can click on the _Setting_ icon (It is the gear icon on the far right) and click on the _General_ tab to set the format (or radix) for display. For this exercise, _Signed Decimal_ is the best choice.

<span style="color:red">Paste your 8-bit adder Tcl file contents.</span>

**Exercise 1 Pass-off:** Show a TA that your simulation for the Add8 module tested the 5 required cases. Explain how you know your circuit is correct and how you know whether or not overflow occurred.

## Exercise #2 - Top-Level Design
For this exercise you will create a top-level design that instances your 8-bit adder and connects your adder to a button, the switches and LEDs. Both operands to the adder will be interpreted as two's complement numbers. Begin your design by creating a top-level module with the following name and ports.

| Module Name: arithmetic_top |
| Port Name | Direction | Width | Function |
|------------------------------------------|
| sw | Input | 16 | Switches (sw[15:8] = 'b', sw[7:0] = 'a' operand) |
| btnc | Input | 1 | Center button (subtract when pressed)
| led | Output | 9 | LEDs (led[8] = overflow, led[7:0] = sum) |


**NOTE: the name of the module and the ports are crucial -- use what is in the table above.**

The reason for using the exact names is that the testbench you will use below to prove your circuit works relies on the top-level module being called 'arithmetic_top' and on the ports having the specified names. And, for the sake of uniformity, call your file 'arithmetic_top.sv' --- the convention is to have the module be named the same as the file to minimize confusion.

A block diagram of the overall design is shown below. It has an input signal called sub (refer to Figure 9.4). The top-level circuit will perform addition when sub is 0.  It will perform subtraction when sub is 1.  The carry in of your Add8 adder needs to be tied to the input signal sub.  We will use the center button (btnc) to select between addition (sub = 1'b0) and subtraction (sub = 1'b1). 

<img src="{% link media/lab_04/01_lab4top_sub.png %}" width="1000">


Inside your top-level module, the carry out of your Add8 adder is not used, but you do need to connect something to it. So, declare a local signal in your top-level module and attach it to the carry out of your adder. But, do not connect it to anything else - the synthesis tool will recognize that it is unused and throw it away.

<!--Similarly, the carry in of your adder needs to be tied to a '0' value. You have two ways of doing this. The first is to simply pass 1'b0 as the carry-in signal to your Add8 module when you instance it in 'arithmetic_top'. The second is to declare a local signal for this purpose and use an 'assign' statement to assign it to a constant '0' and then wire that signal into Add8. It is your choice of how to do this.-->


The center button (btnc) is used as sub signal to control whether addition or subtraction is performed. The top-level circuit will perform subtraction when the center button is pressed and addition when not pressed. The input 'btnc' is connected to a local signal 'sub', which is also connected to the carry in of your Add8 adder. Inversion of the 'b' input to the adder is also controlled by the 'sub' signal.


As can be seen from the block diagram, the top-level module will also contain logic to implement overflow detection. The output from the overflow detector is connected to led[8].

Overflow can be detected by looking at the signals a[7], b[7], and s[7]. It occurs if a and b are both positive (a[7] and b[7] are both 0) but s is negative (s[7] is 1) or if a and b are both negative (a[7] and b[7] are both 1) but s is positive (s[7] is 0). Overflow should be set to 0 if no overflow is detected and set to 1 if overflow is detected. This overflow logic can be expressed in a Boolean equation:
```
overflow = (a[7]' b[7]' s[7]) + (a[7] b[7] s[7]')
```
You must use built-in gates (e.g. not, and, or) to implement this circuit.

### Simulating with a Testbench
Simulating your logic is very important and there are a variety of techniques you can use to simulate your modules. Tcl files are a good way to find errors by providing simple scripts with a few test cases and can be used to find obvious problems early in the simulation phase. However, it is difficult to fully test complex digital circuits with Tcl files.

Digital circuits are often tested with special SystemVerilog modules called **testbenches**. Testbenches are special (non-synthesizable) SystemVerilog files that are used to _test_ your design. Testbenches are written differently than synthesizable SystemVerilog and are used to provide more thorough testing of digital circuits than is possible with Tcl files. In this lab, and future labs, you will be given a SystemVerilog testbench file that will test your circuit. A requirement to completing the lab is to get your circuit to pass the testbench test with 0 errors.

When you have completed your top-level design and removed all syntax errors, simulate your design manually to convince yourself that your circuit is working properly. Once you believe your circuit is working properly, download the following [tb_arithmetic.sv]({% link resources/testbenches/tb_arithmetic.sv %}) file and simulate your module with this testbench. Read through the [testbench tutorial]({% link tutorials/lab_04/01_testbench_tutorial.md %}) to learn how to add and use a testbench for your verification.

A key idea in all this is the notion of a top-level module for simulation or synthesis. It is the module that the tools believe is the top of your hierarchy. When you synthesize, the top-level module should be the one that has inputs and outputs that wire to the board's switches and lights. But, when you simulate, the top-level module will be the testbench with your design connected inside the testbench as the unit under test. So, pay careful attention in the tutorial on using a testbench to both how you add the testbench to your design and how you set it as the top-level module (if Vivado doesn't do it automatically).

The testbench will run automatically, but you might need additional run time for it to finish. To do this, simply type a "run all" command into the Tcl command line. The simulation will stop when the testbench ends.

The testbench will simulate your circuit's operation to make sure that the output of your circuit is correct for each case. The testbench will continue until it prints out a **Simulation done** message indicating the number of errors that were found. Make sure you have 0 errors before proceeding to the next exercise. If you have more than 0 errors, look above in the console log for error messages to indicate where your design failed.

**What should I do if it doesn't work? How do I debug it?**

When you simulate a top-level module, all you see are the top-level ports and top-level local signals. What if you want to see signals inside a sub-module (like your 8-bit adder)?
* Once simulation is running, look in the left-center of the screen for a _Scope_ tab. Click it.
* You can now navigate the hierarchy to find the submodule with the internal signals of interest.
* Drag that submodule into the bottom left of the waveform view window, below the other signal names.
* If you now re-run the simulation you will see all the submodule's signals as well, _and should be able to nearly instantly figure out_ what signals are not doing what you want. This is infinitely better than guessing or just scratching your head or waiting to ask a TA to tell you the answer (because the TA likely will make you do this anyway)...
* And, you can save this new waveform window for later use using the menu. DO IT!!!

**Exercise 2 Pass-off:** Show a TA your top-level code and explain how you connected the inputs to your Add8 module. Also, show that the testbench did not report any errors.

<span style="color:green">Copy the testbench output from the Tcl console to show that there were no errors.</span>

## Exercise #3 - Synthesize, Implement and Download
For this final exercise, you can proceed with the implementation and downloading of your design. Begin this process by [creating]({% link tutorials/lab_03/05_making_an_xdc_file.md %}) and [adding]({% link tutorials/lab_03/06_adding_an_xdc_file.md %}) an XDC constraints file. Your file should have entries for all 16 switches and 9 led outputs. The easiest way to create this file is to start with the [master .xdc]({% link resources/design_resources/basys3_220.xdc %}) file and modify it for the signals you will use by uncommenting the needed lines and making sure  your top-level signal names match those in the constrains file (they should if you followed the instructions above).

The top-level port names in this lab are sw and led. This is different from how we did things in the last lab, why? If you recall, in the last lab you took a copy of the master .xdc file for the board, uncommented the switches and lights you wanted to use and then changed the names of the signals mapped to those switches and lights so it would match your design (A, B, C, O1, O2, ...). This week's lab represents an alternate approach. Here, your top-level SystemVerilog module will have port names (sw and led) that match what is in the .xdc file and so all you have to do is uncomment the appropriate lines in the .xdc file. This has the advantage that your SystemVerilog code uses names like 'sw' and 'led' for the signal names, making it clear during the design and simulation stage what the top-level signals are connected to on the board.

Once you have added the XDC file to your project, [synthesize]({% link tutorials/lab_03/07_synthesis.md %}) your project.

<span style="color:red">Summarize your synthesis warnings. If you have a warning, please comment on the following: 1) What is the warning? 2) Why might you be getting it? The point of this question is to help you understand what your code is doing, and assist in debugging your own code. If you have multiple warnings that fall into the same general idea, you do not need to mention them all independently, just mention that you have (for example) 5 of the same warning. If you have no warnings, just say none.</span>

Perform the [Running the Implementation Design Step]({% link tutorials/lab_03/08_implementation.md %}).

<span style="color:red">Summarize the size of your circuit (LUTs and I/Os).</span>

Perform the [Running the Bitgen Design Step]({% link tutorials/lab_03/09_bitgen.md %}). Download your circuit and verify that it works as expected.

**Exercise #3 Pass-Off:** No specific pass-off, just answer the questions above.

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Show that your circuit works on the Basys 3 board for a variety of values. Show that all the bit positions work (don't just choose small numbers to add). Demonstrate each of the following cases:
</span>

1. <span style="color:green">Add a positive and a negative number.</span>
2. <span style="color:green">Add two positive numbers without overflow.</span>
3. <span style="color:green">Add two positive numbers with overflow.</span>
4. <span style="color:green">Add two negative numbers without overflow.</span>
5. <span style="color:green">Add two negative numbers with overflow.</span>

<span style="color:green">
In the end, if the TA is convinced that you have demonstrated that all parts of your adder work, you will get full credit.
</span>

# Final Questions
Make sure your SystemVerilog conforms to the lab SystemVerilog coding standards.

<span style="color:red">Paste your Add8 module code.</span>

<span style="color:red">Paste your arithmetic_top module code.</span>

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>
