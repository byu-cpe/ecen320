---
layout: page
toc: true
title: UART Receiver
lab: UART_RX
---

In this laboratory you will create and test the receiver part of a UART. Your design will closely follow the serial transmitter you previously did. That is, you will have handshaking with a host (but the signals are called Receive and Received). And, the receiver has similar components -- a state machine, a bit counter, and a timer.

<span style="color:red;">The average time to complete this lab is 5 hours.</span>

# Learning Outcomes
* Implement an asynchronous receiver
* Strengthen behavioral SystemVerilog skills

# Preliminary
What was discussed in class lecture, along with the textbook section on UART receivers will form the basis for the lab. However, you will note that far less of the design is provided to you this week.

In this lab we will operate the receiver at a baud rate of 19200. We will receive using ODD parity and 8 bits of data.

<span style="color:red">Using a 100 MHz clock, how many clock cycles are in half of a bit period for a baud rate of 19200? (see Figure 28.15)</span>

# Exercises

## Exercise #1 - Asynchronous Receiver Module
Begin your laboratory assignment by creating a receiver module that has the following parameters and ports:

| Module Name = rx ||||
| Port Name | Direction | Width | Function |
|---|
| clk | Input | 1 | 100 MHz System Clock |
| Reset | Input | 1 | System reset active high |
| Sin | Input | 1 | Receiver serial input signal |
| Receive | Output | 1 | Indicates that the receiver now has a byte to hand off on the Dout pins. Receive serves as REQ in Figure 28.7.  |
| Received | Input | 1 | Indicates that the host has accepted the byte on the Dout pins. Received serves as ACK in Figure 28.7. |
| Dout | Output | 8 | 8-bit data received by the module. Valid when Receive is high. |
| parityErr | Output | 1 | Indicates that there was a parity error. Valid when Receive is high. |

Next, complete the full design of the receiver. See the textbook for more information. You will need:
* Baud timer
* Bit counter
* Shift register
* Parity checker
* Finite State Machine

### Baud Timer
This is very similar to your timer in the transmitter except it needs to be able to tell you when a whole bit time has passed as well as when a half bit time has passed. Both are needed at some point in your state machine's operation. One way to implement this is to simply add a second output to the timer to signify when it has reached its half-count. It need not roll over when it reaches its half-count -- it can simply raise this second output and keep counting until it reaches the full count.

### Shift Register
The purpose of the shift register is to collect the serially received bits as they come in. It is recommended that you shift all 8 data bits plus the parity bit (and possibly the stop bit) into the shift register. But, you will only output the 8 data bits on the Dout pins.

### Parity Checker
Once you have shifted all bits into the shift register, you should check that the parity bit is correct (ODD parity). If this is not true, you should raise the parityErr signal.

The parityErr signal can be implemented with combinational logic that computes the parity on incoming data in the shift register and tests to see if it does not match the expected parity (ODD in this case). The error signal will thus transition as things are shifted into the shift register, and it will only be accurate once you have shifted in the last bit. That is OK -- the host logic will only look at the parityErr signal when Receive == 1.

You need to think carefully -- given the order that bits arrive -- do you want the register to shift right or shift left? The textbook explicitly states which bit is transmitted first. Given that, should you feed the bits in from the left of the shift register and right shift each time, or the other way around? All you care about is that when you are done, you can assign the bits to Dout for output.

### Finite State Machine
You get to design this yourself from scratch. However, we suggest you pattern it somewhat after the transmitter state machine. Note that your timer will need to delay sampling the serial input signal Sin until you get over into the middle of each bit period. Because of this requirement, your timer may have additional output signals. Furthermore, your state machine will need to control when the shift register shifts so that you collect the 8 data bits and parity bit. Finally, your state machine will need to handshake using the Receive and Received signals at the end of each byte reception. You may assume that a new byte will not start to arrive on the Sin signal before the Receive/Received handshake has completed.

Think carefully about when you want your state machine to tell the host that it has received some data. Is there any harm in *immediately* signaling to the host that you have received a byte and its parity bit as soon as you get to the middle of the parity bit? Think through this carefully -- it is the source of common student errors. The best way to think through this is to draw what the received waveform should look like (similar to Figure 28.15 in the textbook). Then mark on the waveform what state your machine is in at specific points in time. Like a simulation, indicate with parallel waveforms where outputs would go high. Hopefully this is enough of a hint to help you avoid making a common design error.

<!--What about the timing of the parityErr signal? When a parity error occurs, raise the parityErr signal while the Receive signal is being raised and lower it when the Receive signal is lowered. -->

**Exercise 1 Pass-off:** Discuss with a TA the state graph of your state machine.

## Exercise #2 - Simulation
After creating your rx module, create a Tcl file and simulate your receiver module to make sure that there are no major errors.

<span style="color:red">Attach a screenshot of your working simulation to Learning Suite.</span>

Then simulate your module with the following testbench file:

[tb_rx.sv]({% link resources/testbenches/tb_rx.sv %})

<span style="color:red">Paste the console output from the testbench simulation, showing no errors.</span>

## Exercise #3 - Test Receiver
In this exercise you are going to test your receiver in hardware.

Download the following top-level module. Just click the link below to download the file, then add it to your project. Also download a copy of the [7-segment controller]({% link resources/modules/SevenSegmentControl.sv %}) and add it to your project as done in previous lab exercises.

[rx_top.sv]({% link resources/modules/rx_top.sv %})

```verilog
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: rx_top.sv
//
//  Author: Scott Lloyd
//
//  Description: UART Receiver top-level design
//
//
//////////////////////////////////////////////////////////////////////////////////

module rx_top (
    input wire logic  clk,   // system clock
    input wire logic  btnu,  // reset
    input wire logic  rx_in, // serial input
    output logic[15:0] led,
    output logic[3:0] anode,
    output logic[7:0] segment);

    logic reset, req, ack, perr;
    logic[7:0] data0, data1, data2;

    assign reset = btnu;

    // Data history on seven-segment display
    always_ff @(posedge clk)
        if (reset) begin
            data1 <= 0;
            data2 <= 0;
        end else if (req & ~ack) begin
            data1 <= data0;
            data2 <= data1;
        end

    // Parity error history on LEDs
    always_ff @(posedge clk)
        if (reset) begin
            led <= 0;
        end else if (req & ~ack) begin
            led <= led << 1;
            led[0] <= perr;
        end

    // Handshake
    always_ff @(posedge clk)
        if (reset) ack <= 0;
        else ack <= req;

    // Receiver
    rx rx_inst(
        .clk(clk),
        .Reset(reset),
        .Sin(rx_in),
        .Receive(req),
        .Received(ack),
        .Dout(data0),
        .parityErr(perr)
    );

    // Seven-Segment Display
    SevenSegmentControl SSC(
        .clk(clk),
        .reset(reset),
        .dataIn({data2, data1}),
        .digitDisplay(4'hf),
        .digitPoint(4'h4),
        .anode(anode),
        .segment(segment)
    );

endmodule
```

Next, create or modify an .xdc file that contains the pin locations of each port in your design. Most of the pins used in this design are the same as pins used in previous designs (buttons, switches, 7-segment display, etc.). However, you will be using a new FPGA pin to connect to the UART/USB transceiver on your board.

```tcl
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { rx_in }];
```

Synthesize, implement, and generate a bitstream for your design. Test it in hardware with PuTTY. Anything you type in PuTTY will be sent down the line. Typed characters will NOT be mirrored to the PuTTY screen, but will go down the serial line where your receiver will receive it and show the hex representation on the 7-segment display. The right two digits show the most recent character received. When a new character is received, the previous one is shifted over and displayed on the left two digits. The LEDs show when a parity error occurs. The right most LED lights up if the most recent character received had a parity error. As new bytes come into the receiver, a history of parity errors is kept by shifting the parity status to the next LED on the left.

Through PuTTY, make sure the serial device is configured for 19200 baud, 8 bits, 1 stop bit, ODD parity, and NO flow control. Type some characters on the keyboard. You should see the hex representation of the characters show up on the 7-segment display. None of the LEDs should be on, indicating that no parity errors occurred.

Now, change the serial configuration in PuTTY to send characters with EVEN parity. Type some more characters. You should now see that all characters are received with parity errors.

### Some Thoughts on Testing
* Upon startup when your shift register has all 0's in it, what would you expect the value of your parityErr signal to be? Check it to be sure.
* This design can be difficult to debug if it is not working. For example, if you set up PuTTY and type a character with no response, then what should you do? One common strategy would be to bring your state machine bits out to output pins and wire them to LEDs. That way, if your FSM is just stuck in some state, you will have a hint.

<span style="color:red">Paste your receiver SystemVerilog code.</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Demonstrate that your final design receives ASCII letters, punctuation, and digits and can display the hex representation on the 7-segment display. After demonstrating that you have no parity errors with PuTTY configured for ODD parity, change to EVEN parity in PuTTY and show that you always have parity errors displayed in the LEDs on your board.
</span>

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>

<!--
Make a new top-level module with the following ports:

| Module Name = rx_top ||||
| Port Name | Direction | Width | Function |
|---|
| clk | Input | 1 | 100 MHz System Clock |
| reset | Input | 1 | Reset signal, wired to a button |
| ser_in | Input | 1 | The serial signal coming from PuTTY, wired to the receive rx_in signal on the FPGA |
| Receive | Output | 1 | Receive handshake: character has been received by UART, tied to an LED |
| Received | Input | 1 | Receive handshake: host acknowledge receipt of character, tied to a button |
| rxData | Output | 8 | Data that was received by receiver, wired to LEDs |
| parityErr | Output | 1 | Parity error signal, wired out to an LED |

Next, create or modify an .xdc file which maps your top-level signal names to pins on the FPGA. In this case, your top-level signal names don't match what is in the .xdc file, so you will have to edit it to make them match like you have done in some previous labs. What to wire your top level ports to are given above. If any additional signals are needed, add them to the module and .xdc file as well.
-->

<!--
<img src="{% link media/lab_11/img_0065.jpg %}" width="750">

Here, there is a transmitter (with its host) located in Boston that is going to transmit bytes to a receiver (with its host) located in San Francisco. But, to mimic that you are going to put your transmitter from Lab 10 and your receiver from Lab 11 into the same top module.

Your Tcl file will act as //both// the Boston host and the San Francisco host. That is, it will handshake with the transmitter to send a byte like in Lab 10. But, that byte will be transmitted to your receiver which will then receive it like in this lab and so your Tcl file will also have to do handshaking with the receiver to acknowledge that.

The actual serial data transmission, rather than actually traveling from Boston to San Francisco will travel a few nanometers on a wire inside the FPGA from the transmitter's output to the receiver's input.
-->

<!--
Inside the top-level module, instance both your tx and rx modules. Then, connect the serial out data signal of the transmitter to the serial in data signal of the receiver. This is called a "loop back" and allows you to test your transmitter and receiver together - whatever the transmitter sends serially will be received by the receiver and presented back to the host as an 8-bit received data word.
-->

<!--
Now, write a Tcl file and do the simulation of your complete circuit. A complete transmission consists of applying txData and the Send signal and waiting for a Sent signal to be returned and then lowering the Send signal. That handles the transmit handshaking.

But, there will also be receive handshaking once the byte has been received by the receiver. That is, once a byte has been received, your receiver will raise the Receive signal. Your Tcl file can then respond by raising the Received signal, waiting until the Receive signal has been lowered, and then lowering the Received signal.

Your simulation should show that whatever byte was requested to be transmitted by your transmitter is what was received by your receiver.
-->

<!--
**Exercise 3 Pass-off:** Show a TA your top level module and explain how we will know when the rx module has received a byte.

<span style="color:red">
Attach your Tcl file to Learning Suite.
</span>

<span style="color:red">
Attach a screenshot showing the complete handshaking and transmission of the character 'Y'.
</span>

<span style="color:red">
Attach a screenshot showing the complete handshaking and transmission of the character 'Y' but with bad parity. For this you will need to purposely break your transmitter to send the wrong parity so you can demonstrate how your receiver raises the parityErr as a part of the handshaking.
</span>
-->
