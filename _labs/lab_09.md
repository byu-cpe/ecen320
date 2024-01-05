---
layout: page
toc: true
title: UART Transmitter
lab: UART_TX
---

# Introduction
In this laboratory you will create an asynchronous serial transmitter that will allow you to send ASCII characters from the Basys 3 board to your computer. Here is an introductory video:

<iframe width="768" height="432" src="https://www.youtube.com/embed/X_IYmf57wJs?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<span style="color:red;">The average time to complete this lab is 4 hours.</span>

# Learning Outcomes
* Learn how to implement state machines using behavioral SystemVerilog
* Understand how asynchronous communication works

# Preliminary
Chapter 28 discusses the asynchronous transmitter in detail. You will want to review this chapter before beginning this lab and refer back to it when you have questions. Note that we will be using the method described in Section 28.3 (note there are at least two methods described in this section, we are doing the one reflected in Figures 28.8, 28.9, 28.11, 28.12, and programs 28.3.1).

In this lab we will operate the transmitter at a baud rate of 19,200 bits per second. We will transmit using ODD parity and 8 bits of data.

<span style="color:red">How many clock cycles of the 100 MHz clock used on the FPGA board does it take to provide one bit of data using this baud rate?</span>

<span style="color:red">How many bits are needed to count the clock cycles for each bit of data?</span>

<span style="color:red">What is the maximum number of 8-bit ASCII characters that can be transmitted per second using your transmitter at a baud rate of 19,200? Make sure you consider the presence of the start bit, parity bit, and stop bit.</span>

# Exercises

## Exercise #1 - Asynchronous Transmitter Module
Begin your laboratory assignment by creating a module that has the following parameters and ports:

| Module Name = tx ||||
| Port Name | Direction | Width | Function |
|---|
| clk | Input | 1 | 100 MHz System Clock |
| Reset | Input | 1 | Reset signal that is active high |
| Send | Input | 1 | Control signal to request a data transmission (corresponds to the 'REQ' signal in Figure 28.7) |
| Din | Input | 8 | 8-bit data in to send over transmitter |
| Sent | Output | 1 | Acknowledge that transmitter is done with the transmission (corresponds to the 'ACK' signal in Figure 28.7) |
| Sout | Output | 1 | Transmitter serial output signal |

The transmitter consists of a control section and a data path section as shown in Figure 28.9 of the text. The code for the data path is given in Program 28.3.1.

The control section is outlined in Figure 28.11. As you can see, it requires two counters - one to time each bit period and one to count the bits.

### Baud Rate Timer
Your transmitter will need a counter that counts the number of clock cycles needed for a single baud period. Create a counter using behavioral SystemVerilog with the following specifications:
* The size of the counter (in bits) is based on the baud rate and your system's 100MHz clock rate. The counter must have enough bits to represent the largest count value as determined by your calculations above.

The counter has an output signal that indicates when the counter has reached the last clock cycle of the baud period ('timerDone' in the system diagram). This signal is used as an input in the FSM. When the timer reaches this point, it must roll over to 0 on its own; the state machine design relies upon this.

SUGGESTION: many students try to re-use their mod-counter from the stopwatch lab for this timer. Can you see how the description of the baud-rate timer above is different from the mod-counter? For example, the baud-rate timer only has one input -- `clrTimer`. If it is not being cleared it is incrementing. And, its output is *not* the same as the rolling over signal from your mod-counter. Why? Your mod-counter rolling over signal was asserted when the count was at its mod value minus one *AND* the counter was being incremented. Here, the baud-rate timer is free-running, meaning it continuously increments except when it is being reset. The output signal, `timerDone`, simply signifies when the counter has reached its max value. The code for such a counter is 6 lines of code. It will be good practice for you to simply create such a counter in your design.

### Parity Generator
The parity calculation is actually embedded in the code of Program 28.3.1 -- can you see where it is being done and how it is being done? Make sure you understand this.

### Bit Counter
Create the Bit Counter which is responsible for counting the number of bits that have been transmitted. You can see in Figure 28.11 the signals used by the state machine to interact with the bit counter. The bit-counter can be cleared and incremented. And, it will generate a `bitDone` signal when its count is 7. Once again, this output is *not* the same as the rolling over signal from your mod-counter, this one simply signifies that its count has reached a value of 7. So, code it according to this description rather than trying to re-purpose your mod-counter (which had a different description). It is very few lines of code and it will be good practice to write new code for it.

### Datapath
Note that the data path outputs the correct bits needed in response to state machine outputs. Note that it is an always_ff block to ensure that the final output signal (Sout) is registered to avoid glitching. The datapath code is outlined in Program 28.3.1.

### FSM
Create the FSM as outlined in the following figure.

<img src="{% link media/lab_09/00_uart_tx_sm.png %}" width="670">

**Use the following Tcl script to simulate your ''tx'' module:**
```tcl
restart

# Start clock
add_force clk {0} {1 5} -repeat_every 10
run 10ns

# Reset design
add_force Reset 1
add_force Send 0
run 10ns
add_force Reset 0
run 10ns

# Run for some time
run 50us

# Send a byte
add_force -radix hex Din 47
add_force Send 1
run 10ns
add_force Send 0
run 1ms

# Send another byte
add_force -radix hex Din 4F
add_force Send 1
run 10ns
add_force Send 0
run 1ms
```

Look at the waveform and make sure your module is operating correctly. Verify the following points in the simulation:
* For each byte sent, Check that the 8 data bits are output correctly in the correct order.
* Check that the parity output is correct.
* Check that the start and stop output is correct.
* Check that both of your timers are operating correctly; that they reset and increment in the correct conditions.

**Exercise 1 Pass-off:** Show a TA your waveform and discuss how the waveform demonstrates the above points.

## Exercise #2 - Testbench Validation
When it looks like your tx module is working properly use the following testbench file to test it.

[tb_tx.sv]({% link resources/testbenches/tb_tx.sv %})

<span style="color:red">Paste the testbench simulation output text to your laboratory report when it is error free.</span>

**Exercise 2 Pass-off:** You don't need a TA to pass-off this exercise, but __make sure the testbench is working before moving on__.

## Exercise #3 - Top-Level TX Module
After simulating your module and verifying it operates, download the following top-level module. Just click the link below to download the file, then add it to your project.

[tx_top.sv]({% link resources/modules/tx_top.sv %})
```verilog
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tx_top.sv
//
//  Author: Jeff Goeders
//
//  Description: UART Transmitter top-level design
//
//
//////////////////////////////////////////////////////////////////////////////////

module tx_top(
    input wire logic            clk,
    input wire logic            btnu, //reset
    input wire logic    [7:0]   sw,
    input wire logic            btnc,
    output logic        [3:0]   anode,
    output logic        [7:0]   segment,
    output logic                tx_out,
    output logic                tx_debug);

    logic reset;
    assign reset = btnu;
    assign tx_debug = tx_out;

    logic   btnc_r;
    logic   btnc_r2;
    logic   send_character;

    // Button synchronizer
    always_ff@(posedge clk)
    begin
       btnc_r <= btnc;
       btnc_r2 <= btnc_r;
    end

    // Debounce the start button
    debounce debounce_inst(
        .clk(clk),
        .reset(reset),
        .noisy(btnc_r2),
        .debounced(send_character)
    );

    // Transmitter
    tx tx_inst(
        .clk    (clk),
        .Reset  (reset),
        .Send   (send_character),
        .Din    (sw),
        .Sent   (),
        .Sout   (tx_out)
    );

    // Seven-Segment Display
    SevenSegmentControl SSC (
        .clk(clk),
        .reset(reset),
        .dataIn({8'h00, sw}),
        .digitDisplay(4'h3),
        .digitPoint(4'h0),
        .anode(anode),
        .segment(segment)
    );

endmodule
```

Look over the top-level file. You will see that it uses your debounce circuit from a previous lab, which ensures that when you hit the send button, only a single character is sent. The seven-segment controller displays the current value of the switches to help quickly determine the hexadecimal value and compare it to an ASCII table.

<!--
begin a new top-level module with the following ports:

| Module Name = tx_top ||||
| Port Name | Direction | Width | Function |
| clk | Input | 1 | 100 MHz System Clock |
| sw | Input | 8 | 8 Slide switches to specify character to send |
| btnc | Input | 1 | Send character control signal |
| btnd | Input | 1 | Reset control signal |
| tx_out | Output | 1 | Transmit signal |
| segment | Output | 8 | Cathode signals for seven-segment display |
| anode | Output | 8 | Anode signals for each of the eight digits |
| tx_debug | Output | 1 | TX Debug signal |

Instance your tx module and make the following connections to your tx module:
* Connect the sout output of your tx module to your top-level tx_out output
* Connect the sout output of your tx module to your top-level tx_debug output (yes, the same signal)
* Connect an unused signal to the 'sent' signal of your tx module (while we will not use it, the sent signal is normally important for handshaking protocol)
* Connect the 8 switches to the 'din' input of your tx module
* Connect the top-level clock to the clk input of your tx module
* Create a signal named 'send' and attach it to the 'send' input of your tx module. We will discuss what logic will be used to drive this input later.
* Create a signal named 'reset' and attach it to the 'reset' input of your tx module. This will be created the same way as the 'send' signal.

Instance your seven-segment display controller and connect the inputs to your controller as follows:
* Attach the 8 switches to the lower 8-bits of the data in of the seven-segment controller. Assign the upper 24 bits of the data in to '0'.
* Only display the bottom two digits of the seven-segment display
* Do not use any of the digit points
* Attach the anode and segment signals of the controller to the top-level outputs of the top-level module

Create debounced 'send' and 'reset' signals as follows:
* Using the debouncer done in a previous lab, debounce the 'btnc' input to create the 'send' signal and feed into your design.
* Using another debouncer instance, debounce the 'btnd' input to create the 'reset' signal.

**Exercise 3 Pass-off:** Show a TA your top level module and explain why we need to debounce the button inputs.
-->

Before synthesizing your design, you will need to create an .xdc file that contains the pin locations of each port in your design. Most of the pins used in this design are the same as pins used in previous designs (buttons, switches, seven-segment display, etc.). However, you will be using new FPGA pins to connect to the UART/USB transceiver and debug ports.

The following example code demonstrates how these I/O pins can be attached to your top-level FPGA pins:
```tcl
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports { tx_out }];
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports { tx_debug }];
```

The tx_debug signal is a copy of the transmitter output, and on the Basys 3 board, it is routed to Pin 1 of the JA connector. The signal can be captured with a logic analyzer to see the serial waveform.

After completing your .xdc file, proceed to generate your bitstream.

<span style="color:red">
Paste a copy of and then explain in words any ERRORS or CRITICAL WARNINGS that are in the synthesis report from above. For each one, explain the following: What does this ERROR or CRITICAL WARNING refer to and do you understand why it was flagged? Is it OK (or not) for you to ignore it and assume the design will work in hardware? Please explain why.
</span>

**Exercise 3 Pass-off:** There is no pass-off for this exercise.

## Exercise #4 - Test Transmitter
Once the bitstream has been generated, download your bitstream to the FPGA. To test the transmitter, you will need to run a terminal emulator program. This is a program that can receive and send bytes on a serial port attached to your computer. We use it to communicate with the FPGA board over a serial port embedded in the USB cable you connect between your computer and the board.

### Configuring PuTTY
PuTTY is a terminal emulation program installed on lab machines. Characters sent from your FPGA can be seen by running PuTTY and connecting to the USB serial device (/dev/ttyUSB1 on lab machines). Configure the serial device for 19200 baud, 8 bits, 1 stop bit, ODD parity, and NO flow control. Run PuTTY from the command line by typing `putty` or launch it from the application menu. From the PuTTY Configuration dialog, click on "Serial" in the "Category:" window on the left side to set the serial port options. You may need to scroll down to see it. Click "Open" to start a session.

<!--
### Installing PuTTY
If you are using either Windows or a Mac+Linux VM combination, you should use "PuTTY". Follow the [PuTTY tutorial]({% link tutorials/other/00_putty_personal_machine.md %}) to set it up if you are running on your own machine. Note that if you are running on a lab machine it should already be installed.

After installing, specifically, follow the testing procedures outlined to ensure that PuTTY is working on your machine. That way, if your downloaded circuit design doesn't work you will know that PuTTY is not the reason.

### Installing CoolTerm (Mac)
If you are using a Mac with LabConnect and OpenOCD you will use CoolTerm instead of PuTTY. Follow the [CoolTerm Tutorial]({% link tutorials/other/02_coolterm_setup.md %}) to set this up.
-->

### Using the Terminal Emulator Program
Once the terminal emulator program is configured properly you should be able to send characters to the terminal by selecting the [ASCII](http://www.asciitable.com/) value of the character to send on the switches and pressing the center button.

Interesting control commands:
* 8'h07 - Bell (a sound, not a character)
* 8'h09 - Tab
* 8'h0C - Clear screen
* 8'h0A - Move cursor down (Line Feed)
* 8'h0D - Carriage Return

The above are called "control characters" since they control the screen rather than draw characters. They are typed on normal keyboards using the "Control" key pressed concurrently with another key. This is similar to how a shift key is used. Thus, when you hit Control-C to kill a program on a computer, you are sending (or at least with older computers were sending) the ASCII character 8'h03.

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Demonstrate that the transmitter circuit works. Test it against a variety of characters from the ASCII table at the end of your textbook -- digits, punctuation, and both upper and lowercase letters. Show what happens when you send some of the special characters mentioned above -- do you get interesting or meaningful stuff? How about for characters with values 8'h80 and above?</span>

<span style="color:red">Paste your tx.sv SystemVerilog module to Learning Suite.</span>

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>
