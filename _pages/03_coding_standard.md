---
title: SystemVerilog Coding Standard
layout: page
toc: true
icon: fas fa-check
---

<!--


A few comments on BYU’s coding guidelines: https://ecen220wiki.groups.et.byu.net/03-coding-standard/
 
I strongly disagree with R5. `default nettype none was one of the worst “enhancements” to Verilog 2001. Once you add this line of code, any other module that you compile after this file will give errors if it did not include wire declarations for every signal and for most inputs. This is a good way to kill backward compatibility with third party modules compiled into your design. R5 is a terrible recommendation, and I would be happy to debate it with BYU profs.
 
R6 – I use either input signame (wire is the default) or input logic signame. I tell engineers, use logic for everything unless you have multiple drivers, then use the wire type. The wire type allows resolution of multiple drivers. I tell engineers that logic is their near-universal RTL data type. Nobody that I know uses input wire logic. Logic is roughly equivalent to std_ulogic while wire is roughly equivalent to std_logic in VHDL.
 
R19 is a bad recommendation. Synthesis typically works best if modules have registered outputs. Combinational outputs use part of the next cycle, which makes it harder to meet timing in the receiving block. I teach 7 different FSM coding styles and 6 of them have registered outputs.
 
R20 I would like to see more fully what BYU recommends for FSM design.
 
R22 – Camel case (correct). Underscores between words is called snake-case. Google “software snake-case”
 
R23 - is not done in industry. We use all lowercase for module names and R2 is absolutely correct (match filename to module name) so that we can automatically pick up referenced module-files while compiling.
 
R23 – we generally use upper case for both macro definitions and parameters. Macros in the code have a leading ` and parameters do not.

-->

**HDL**s (Hardware Description Languages) like SystemVerilog can be difficult to understand. To make SystemVerilog code more readable and maintainable, you are required to follow coding standards. These standards are explained below. Each *and every* lab will be graded against this coding standard.

# Files
* ***R1:*** A new **.sv** file will be created for every SystemVerilog module you create.
* ***R2:*** The name of any SystemVerilog file you create must match the name of the module it contains. For example, if you have a SystemVerilog file with a module named `FourFunctions`, the filename will be **FourFunctions.sv**.
* ***R3:*** You will create multiple modules in some of the labs. Submit these individually as requested.

## File Header
* ***R4:*** When Vivado creates a new .sv file it will place a `` `timescale 1ns / 1ps `` directive as the top line and then fill in its own comment header block. DO NOT remove the timescale line, but replace the comment header block with:

  ```verilog
  /***************************************************************************
  *
  * Module: <module Name>
  *
  * Author: <Your Name>
  * Class: <Class, Section, Semester> - ECEN 220, Section 1, Winter 2020
  * Date: <Date file was created>
  *
  * Description: <Provide a brief description of what this SystemVerilog file does>
  *
  *
  ****************************************************************************/
  ```

* ***R5:*** Each file should also include the `` `default_nettype none `` macro directive.

# Signals
* Signal types:
  - ***R6:*** Declare module inputs as `input wire logic`
  - ***R7:*** Declare module outputs as `output logic`
  - ***R8:*** Declare internal signals as `logic`
  - ***R9:*** The keywords `reg`, and `var` are not allowed to be used, and `wire` can only be used for inputs as described above.
* Signal names:
  - ***R10:*** Use descriptive names (e.g. `clrTimer` instead of `n7`).
  - ***R11:*** Use an `_n` suffix for active low signals (e.g. `write_n`).
* ***R12:*** When signals are declared, they will not use an initializer. For example, this is incorrect: `logic nextState = 0;`. Rather, signals will be declared as in `logic nextState;`. If you want a signal to initialize to some known value, provide a control signal (like `clr`) which will set it to that value.

# Comments and Indenting
* ***R13:*** Indentation will be used in the code to show its structure.
* ***R14:*** Each `always_ff` block and every `always_comb` block will be preceded by a comment describing its function and how it should operate.
* ***R15:*** If the name of a signal is expressive enough (e.g. `clrTimer`) then a comment describing may not be needed. Otherwise, all signal declarations will have an associated descriptive comment. *Be careful -- what is considered "descriptive enough" is subjective. Every semester students lose points because they think that `n5` is descriptive but the TA does not. Err on the side of descriptive names or just always add a comment that tells what each signal is for.*

# Design Requirements
* ***R16:*** The only assignment operator allowed in an `always_ff` block is the \<= operator. The only assignment operator allowed in `assign` statements and `always_comb blocks` is the = operator.
* ***R17:*** Every `always_comb` block must begin by assigning default values to all signals being driven in the block.
* ***R18:*** Every `always_ff` block will include functionality allowing the registers within the block to be set to known values via the assertion of a `clr` or `load` signal. The exception to this may be something like a shift register which will eventually shift in known data and therefore which does not necessarily require an explicit `clr` or `load` signal.
* ***R19:*** Outputs from counters, state machines, etc. will be combinational except in very rare cases.
* ***R20:*** Finite state machines will be coded using the style of the textbook including the use of an enumerated type for the state type (with an ERR state), an `always_comb` for the combined IFL/OFL, and an `always_ff` for the state register.

# Style
* ***R21:*** The code for the different sub-modules in a module will be grouped together. For example, the statements associated with the timer circuitry will appear together, followed by the statements associated with the bit counter circuitry, followed by the state machine. Each such section of circuitry will have comments delimiting it.
* ***R22:*** Local signal declarations will come just after the module definition and its port declarations.
  - In programming (as well as HDL-based design) there are two common ways of naming signals so that their meaning is obvious.
  - One way is called camel case and consists of starting the signal name with a lower case letter and then capitalizing subsequent words as in: clearTimer, resetConfigurationRegisters, or launchMissile.
  - The second way is to make everything lower case and use underscores to separate the pieces as in: clear\_timer, reset\_configuration\_registers, and launch\_missile.
  - Choose one of these two styles, be consistent, and use descriptive signal names.
* ***R23:*** Similarly, there are common ways of naming modules and constants. Modules will start with a capital letter as in: EventCounter or InitializationRegisters. For constants (sometimes called parameters in SystemVerilog), they will be uppercase as in INITVAL, THRESHOLD, or DATAWIDTH.

# Conclusion
Why would any of this be important? This is *the way* that design is done in industry (except their style rules are much more extensive and may take many pages to describe). In a large design with millions of signals and thousands of modules, this adds uniformity to the design to help make the code more readable, understandable, and maintain-able.
