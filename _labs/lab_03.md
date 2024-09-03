---
layout: page
toc: true
title: Structural SystemVerilog
lab: Structural_SV
---

<!--
Basically keep this the same. The synthesis and download process should be familiar. Instead, focus on simulation and design.
-->

In this lab you will implement several logic functions using the SystemVerilog **HDL** (Hardware Description Language). You will simulate your SystemVerilog designs using commercial simulation tools and synthesize them into circuits. You will then download the resulting circuit data onto the Basys 3 board so you can test your design in hardware.

<span style="color:red;">The average time to complete this lab is 3.5 hours.</span>

# Learning Outcomes
* Describing circuits using SystemVerilog.
* Use the Vivado Design Suite for project creation.
* Use Vivado simulation and synthesis tools.
* Learn to create Tcl simulation scripts.

# Preliminary
* Review Chapter 8 of the textbook (you will need to be familiar with SystemVerilog before starting this lab).
* This laboratory will involve a _lot_ of tutorials. You may want to start working through these tutorials before you arrive at the laboratory to get a head start.

# Exercises

## Exercise #1 - Creating a Vivado Project
Many software tools are needed to convert your SystemVerilog file into a configuration bit file that you can download onto an FPGA device. We will be using a set of tools called **Vivado** developed by Xilinx, the manufacturer of the FPGA devices in the lab. You will use Vivado throughout the rest of the semester.

1. Create a new Vivado project by following the instructions in the [Creating a new Vivado Project]({% link tutorials/lab_03/00_vivado_project_setup.md %}) tutorial. __Make sure you follow the steps in the Project Configuration section to properly configure the error messages and other settings in your project.__
2. Now, create a new SystemVerilog file to hold a module by following the instructions in the [Adding a SystemVerilog design module to a project]({% link tutorials/lab_03/01_creating_a_new_module.md %}) tutorial. Your module will be called "FourFunctions". Do not add any ports to it in this exercise, you just want an empty module definition.

## Exercise #2 - Implement Logic Functions in Structural SystemVerilog
In this exercise you will create the _structural_ SystemVerilog description of four logic functions. Note that you must use structural SystemVerilog rather than Dataflow SystemVerilog to complete this assignment. Follow the steps below to begin this exercise.

1. Open up the FourFunctions.sv module you created in Exercise #1 by double-clicking it in the figure you just saw above.
2. Start your file by creating a **header** in your SystemVerilog file that conforms to this class's [SystemVerilog Coding Standards]({% link _pages/03_coding_standard.md %}). If Vivado has pre-populated the file with header information you are free to remove that or modify it (do not delete the first line that contains \`timescale 1ns / 1ps, however. Either way, your design must have a **header** that conforms to the class's [SystemVerilog Coding Standards]({% link _pages/03_coding_standard.md %}).
3. NOTE: the coding standards are very specific on how to declare the inputs and outputs of modules. If you read carefully, you will note that they require the inclusion of the word "wire" in certain places. This is not reflected in the textbook examples. The need to include this is due to specific requirements of Vivado when the \`default_nettype none macro directive is included.)
4. Now, define a module named "FourFunctions" with the following ports. Make sure to match everything described below exactly (including the port names).

NOTE: if you are fuzzy on module declarations, consult the textbook. In particular, review Sections 8.3, 8.4, and 8.6.1 in the textbook. And, just remember that due to our using Vivado, you also need to include the word "wire" in certain places. Consult the [SystemVerilog Coding Standards]({% link _pages/03_coding_standard.md %}) for details on that.

Finaly, at this point remember there is no reason to get creative - just copy the structure and syntax (including indentation) of the code examples in the book sections noted. And, carefully follow the coding standard. This goes for this lab as well as all future labs.

<span style="color:blue">
A word to the wise: you will see that we have told you to follow the class's SystemVerlog Coding Standards <u>4 times in a row</u>. Need we say more?
</span>

**Module Name**: FourFunctions

| Port Name | Size (bits) | Direction |
|-------------------------------------|
| A | 1 | Input |
| B | 1 | Input |
| C | 1 | Input |
| O1 | 1 | Output |
| O2 | 1 | Output |
| O3 | 1 | Output |
| O4 | 1 | Output |

Implement the following _four_ logic functions inside of this module.

* **O1**: O1 = AC+A'B

* **O2**: O2 = (A+C')(BC)

* **O3**: The logic function below:

<img src="{% link media/lab_03/00_simpleschem.png %}" width="500">

* **O4**: The logic function below:

<img src="{% link media/lab_03/01_hwb.png %}" width="370">

If these functions require intermediate signals (signals that are not module ports), you will need to declare them using the 'logic' keyword (see text for details). Also, choose meaninful names or (probably better yet) put a comment above them to tell what they are used for.

You do not need to minimize these functions, just implement the logic functions directly using basic gates (AND, NAND, OR, NOR, NOT, etc).

As you type and save your SystemVerilog code, Vivado will identify syntax errors in the code. Edit the code until there are no syntax errors.

With no syntax errors in your HDL code you can perform **elaboration** and generate a notional schematic of the circuit. Follow the [Viewing SystemVerilog as a Schematic]({% link tutorials/lab_03/02_viewing_design_elaboration.md %}) tutorial to view a schematic of your code.

Although it is difficult to find logic errors in the schematic view, it is easy to see problems such as missing connections between the gates, inputs, and outputs. Look for unconnected top-level ports or missing connections in your gates (missing connections are annotated with **n/c** on the schematic).

**Exercise 2 Pass-off:** Review your code with a TA as well as your circuit schematic (the schematic under "RTL Analysis"). Be able to explain what each of the components are and how Vivado has implemented your four functions. Remember - the purpose of reviewing your code with the TA is to avoid problems later in the lab.

<span style="color:red">
Attach a screenshot of the resulting (elaboration) schematic to Learning Suite.
</span>

## Exercise #3 - SystemVerilog Simulation
<!--
**If you are using Option #2: before beginning this step, you need to do the following just once to set up the tools:**
1. Open a terminal in your Linux VM
2. Type the following at a command prompt: sudo apt install gcc
3. It will ask for your password
4. It will install the needed C compiler for the simulator to work
**If you are running Option #1 or Option #3 you should not have to do the above step.**
-->

Simulating your design is _the most important phase of digital logic design_. You will do extensive simulations of all your digital circuits and it is very important that you learn how to use the logic simulation tools.

Why? Finding errors in your design in simulation may take seconds or minutes, whereas finding those same errors in your physical circuit after it is running on the FPGA board may take HOURS!!! The greater skill you have at using these simulation tools, the easier and more successful you will be in all future labs and not waste a lot of time.

Complete the following steps for this exercise:

1. Begin the simulation process by following the [Starting the Vivado HDL Simulation Tool]({% link tutorials/lab_03/03_starting_vivado_simulation_tool.md %}) tutorial.

2. Read through [Tcl Tutorial]({% link tutorials/lab_03/04_tcl_tutorial.md %}) to get a feel for the Tool Command Language (Tcl) commands you will be using. Then, create a .tcl file and simulate your module by issuing a number of **add_force** commands.

The following .tcl code snippet demonstrates one way to simulate two of the eight input combinations. In your own .tcl file you will need to make sure to test all possible input combinations.

```tcl
# Comments are written with the '#' character instead of // or /**/.

# Simulate A=0, B=0, C=0 for 10 ns
add_force A 0
add_force B 0
add_force C 0
run 10 ns

# Simulate A=0, B=0, C=1 for 10 ns
add_force A 0
add_force B 0
add_force C 1
run 10 ns
```

3. Compare the resulting waveform with a truth table for your four functions. Verify that your simulation outputs match the expected outputs. If there are errors, fix your SystemVerilog file and simulate again until your circuit operates as intended.

4. What if it doesn't simulate correctly? It could be that (a) your code is wrong or (b) there is something wrong with the simulation. Yes, we have found times when you can get the simulator in a weird state, where re-simulating doesn't seem to reflect your most recent code changes. On the wiki, there is a item on the left side near the top called [Taming Vivado]({% link resources/tool_resources/taming_vivado.md %}). If the simulator is just not making sense you may need to follow the steps in [Taming Vivado]({% link resources/tool_resources/taming_vivado.md %}) to fix it (under "Resources" in side-bar of this web page). You should learn how to do those steps so you are not totally stuck when you can't get help from a TA.

In fact, go read through the "Taming Vivado" information right now.

<span style="color:red">
What are the steps, in order, to fix a "simulator-is-wedged" problem?
</span>

<span style="color:red">
Paste your Tcl file commands to Learning Suite.
</span>

<span style="color:red">
Attach a screenshot of your simulation results that show how your circuit works as intended. In order to receive full credit on this (and all simulations for the rest of the semester), you must enter into the Learning Suite response box a description of how you went about verifying your simulation. Point out the important times in the simulation waveform, what was happening there, what the inputs were, what the outputs were, and why they are the correct outputs, etc.
</span>

**Exercise 3 Pass-off:** Show a TA your simulation and explain it to him. The TA will also check your Tcl commands to see if you have tested all possible input combinations.

## Exercise #4 - Synthesis and Implementation
During this exercise you will translate your SystemVerilog HDL file into an actual digital circuit that can operate on the FPGA device. There are three specific steps you must complete in order to perform this translation. These steps include:
1. HDL Synthesis,
2. Implementation, and
3. Bitfile Generation:
This exercise will describe each of these steps and guide you through the process of completing these steps for your design.

### Creating a Constraints File
Before proceeding with the first "HDL synthesis" step, you must create a constraints file, or **XDC** (Xilinx Design Constraints) file. This tells the synthesis tool which pins on the FPGA board are being connected to which inputs and outputs of your circuit. **Without this file, your design will not be able to synthesize even if your circuit is logically correct.** This table shows the mapping we will use for this module.

| Port Name | Pin | Basys 3 |
|---------------------------|
| A | W16 | Switch 2 (SW2) |
| B | V16 | Switch 1 (SW1) |
| C | V17 | Switch 0 (SW0) |
| O1 | V19 | LED 3 (LD3) |
| O2 | U19 | LED 2 (LD2) |
| O3 | E19 | LED 1 (LD1) |
| O4 | U16 | LED 0 (LD0) |

For example, this table indicates that the "A" input to your logic circuit should be mapped to pin "W16" of the FPGA on the Basys 3 board. The table also indicates that the "W16" pin is attached to Switch 2 on the board. To make an XDC file, follow the instructions in the [Using Constraint Files (XDC)]({% link tutorials/lab_03/05_making_an_xdc_file.md %}) tutorial. Your constraints file should have seven different constraint commands, one for each of the inputs and outputs of your circuit. Remember that it is easier to include the Master XDC File (found on the "Resources" page) and uncomment the lines you need rather than making the file yourself.

<span style="color:red">Paste the text of your XDC file to Learning Suite.</span>

After creating your XDC file, you need to add it to your project. Follow the [Adding a Constraints File to your Project]({% link tutorials/lab_03/06_adding_an_xdc_file.md %}) tutorial to learn how to add this to your project.

### HDL Synthesis
HDL synthesis (also called logic synthesis) is the process of converting your HDL code into an intermediate circuit netlist of gates and logic primitives. Synthesis tools are complex and use a lot of sophisticated algorithms to perform this translation. Follow the [Running the HDL Synthesis Tool]({% link tutorials/lab_03/07_synthesis.md %}) tutorial to run the synthesis tool on your design.

During the synthesis process you may encounter synthesis warnings from the synthesis tool. It is common to receive many warnings especially for large circuits. It is essential that you review the warnings of the synthesis step before proceeding to the implementation step. In most cases these warnings can be ignored, but it is essential to review them since subtle warnings in the logic synthesis tool are often the cause of complex problems later in the design process. And, like the comment about simulation you saw earlier, errors overlooked because you ignored the synthesis log may take a LONG time to figure out. The errors and warnings are there for a reason -- don't proceed until you have checked them -- it will save you time.

<span style="color:red">
List the warnings in your synthesis report. If you have a warning, please comment on the following: 1) What is the warning? 2) Why might you be getting it? The point of this question is to help you understand what your code is doing, and assist in debugging your own code. If you have multiple warnings that fall into the same general idea, you do not need to mention them all independently, just mention that you have (for example) 5 of the same warning. If you have no warnings, just say none.
</span>

Warnings can be found in the **Messages** tab at the bottom of the screen. They can also be found in the **Reports** tab at the bottom of the screen under **Vivado Synthesis Report**.

<span style="color:red">Summarize some of the differences between the schematic you captured earlier and the synthesis schematic.</span>

The synthesis schematic is found under **Open Synthesized Design** > **Schematic**, as explained in the [Running the HDL Synthesis Tool]({% link tutorials/lab_03/07_synthesis.md %}) tutorial video.

### Implementation
The Implementation step will map the circuit netlist created in the synthesis step onto specific resources of the FPGA. This involves placement of your circuit resources and routing of your logic signals. Follow the [Running the Implementation Design Step]({% link tutorials/lab_03/08_implementation.md %}) tutorial to complete the implementation process on your design.

Open the **Project Summary** tab, which should be near the tab for your SystemVerilog file. If you closed the Project Summary earlier, it can be opened with the following icon in the tool bar.

<img src="{% link media/lab_03/02_project_summary_icon.png %}" width="500">

Review the **Utilization** box within the Project Summary to determine the size of your design in terms of logic resources. Use the **Post-Implementation** and **Table** tabs.

<span style="color:red">Indicate the number of LUTs (Look-up Tables) and I/O (Input/Output) pins for your design.</span>

These are in the **Utilization** column of the table.

## Exercise #5 - Generate Bitstream and Download to FPGA Board
The "Bit File Generation" step will convert your design that has been placed and routed to a binary file that can be downloaded onto the FPGA. Follow the [Running the bitgen Design Step]({% link tutorials/lab_03/09_bitgen.md %}) tutorial to generate your bitstream.

Now that you have a bit file, you can configure the FPGA and test your circuit on the board. Since you have a Vivado project, see the section on the [Downloading Bitfile]({% link tutorials/lab_01/05_downloading_bitfile.md %}) page specific to having a Vivado project.

Test all four functions of your circuit on the board to make sure that it works correctly. When you are convinced that your circuit is correct, proceed to the final pass off.

<span style="color:red">Paste the SystemVerilog code for your FourFunctions module to Learning Suite. Make sure your SystemVerilog conforms to the lab SystemVerilog coding standards. For example, Requirement R4: make sure your code has a header with a description in comments.</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Show that your board is programmed and demonstrate that the design is operating correctly. Be sure to show how all 4 functions are working correctly on the board (you need to try all combinations of the 3 switches, not just a few).
</span>

If you make a video, it must be right-side up, large enough to see, high enough quality to understand, and with sound that can be understood. If your video is longer than 2-3 minutes then you need to figure out how to cut it back a bit --- A 10 minute video is far too long.

# Final Questions
<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

<!--
# Personal Exploration

Choose one of the following tasks to do as a personal exploration:
* Compare and contrast the difference between the circuit you specified in your original SystemVerilog file and the schematic that is generated from your file. Are there differences? What is similar and what is different?
* Add an additional fifth logic function to your SystemVerilog file and synthesize it using the steps described in the laboratory instructions.

<span style="color:red">Describe your personal exploration activities</span>
-->

<!--
===== Lab Report =====

* **Header**
  * Class
  * Lab
  * Name
  * Section
* **Exercise 2**
  * Schematic screenshot
* **Exercise 3**
  * Simulation command list
  * Simulation screenshot
* **Exercise 4**
  * XDC file
  * Synthesis warnings
  * Summary of schematic changes,
  * Number of LUTs and I/O pins
* **Exercise 5**
  * Final Verilog code
* Personal exploration description
* Hours spent on lab
* Feedback

*/
-----

[[labs:ta:structural_verilog|TA Notes and Feedback]]

[[testDev]]
-->
