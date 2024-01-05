---
layout: page
toc: true
title: Using Constraint Files (XDC)
lab: 3
---

A Xilinx Design Constraints file or **XDC** file is needed to interface between your SystemVerilog modules and the Basys 3. It hooks up the inputs and outputs of your module to pins, buttons, LEDs, switches, etc. on the board. An XDC file is _required_ to generate configuration bit file.

An XDC file is simply a Tcl file with Tcl commands. These Tcl commands add properties to the ports of your SystemVerilog file (properties that indicate where the port should be hooked up). The file is then executed before bitstream generation so that these properties are attached to the design.

To add an XDC file to your project, follow the [Adding a Constraints File to your Project]({% link tutorials/lab_03/06_adding_an_xdc_file.md %}) tutorial. Each lab project should have its own XDC file.

# Mapping Pins to Ports
Most of the commands in a constraint file simply assign pin locations to top-level ports. Your XDC files will have many commands that follow the format below.

`set_property -dict { PACKAGE_PIN <PIN_NAME> IOSTANDARD LVCMOS33 } [get_ports { <PORT_NAME> }];`

You will need to make sure that the \<PIN_NAME\> and \<PORT_NAME\> match for every top-level port.

The following example command demonstrates assigning the **A** port of a Verilog design to pin **W16** on the FPGA. Below is explained each part of the command.

`set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { A }];`

The **set_property** command is used to attach properties to design elements. Type `help set_property` in the Tcl console to learn more. Two options are being passed to this command, **-dict** and **get_ports**. These are explained in further detail in the following sections.

## -dict
This argument provides a _dictionary_, a set of name/value property pairs, all in a single command. In this example, two pairs are being added to the port:

| Property Name | Property Value |
|--------------------------------|
| PACKAGE_PIN | W16 |
| IOSTANDARD | LVCMOS33 |

* **PACKAGE_PIN** indicates which pin the signal should be assigned to. In this example, the signal is attached to the **W16** pin (this pin is attached to switch 2 on the FPGA).
* **IOSTANDARD** configures the pin to operate a specific voltage standard. In this case, we are configuring the the pin as **LVCMOS33** which translates to _Low-Voltage CMOS using 3.3V supply_. You must assign values to these two properties for all pins you use on the FPGA.

## get_ports
This argument actually executes the command `get_ports{A}`, meaning find the top-level port named **A**. The result of this command is used as the second argument of the **set_property** command, allowing it to connect the pins from **dict** to the ports in **get_ports**.

# Master XDC file
Creating XDC files is tedious and repetitive. To make things easier, you're provided with a [master XDC file]({% link resources/design_resources/basys3_220.xdc %}) that contains all the XDC constraints for each pin on the Basys 3 that you will use in these labs.

Rather than typing in all of the constraints, you can copy this file for each lab and modify it as needed. You need to perform these two steps to modify the master XDC file for your top-level design:
1. Uncomment the lines in the XDC file that correspond to pins that your design uses. Do this by removing the "#" character at the beginning of the line.
2. Modify the port names to match the top-level input and output ports of your design. Do this by changing the values inside the curly braces "{}" of the "get_ports {  }" portion of the command.
3. In some labs, the top level port names will match what is already in the XDC file ("sw[0]" for example) and so you won't have to change them. In other labs, the top level port names will not match what is already in the XDC file and you will have to change them in the XDC file.

<!--
====Clock====

For future reference, the line in the master XDC file that you should use for your clock in later labs is the first one, or the line that starts with this: \\ ''#set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 }''

You **do not** need to use the following line that begins with ''#create_clock''.

*/

----

[[ta:tutorials#xdc_files|TA Feedback]]
-->