---
layout: page
toc: true
title: Codebreaker
lab: Codebreaker
---

# Overview
In this lab you will be given a secret message that has been encrypted with a secret key. You will create a circuit that tries every possible key until you find out which key successfully decrypts the message.

Your design will start searching for the key after the center button is pressed. The current key being tried is displayed on the LEDs, and your stopwatch from a previous lab is used to time how long it takes for you to find the correct key. Once you have discovered the secret message, you will display this secret message on the VGA monitor.

<iframe width="768" height="432" src="https://www.youtube.com/embed/ZjhpsU0QUYY?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The progression of the exercises is:
* Exercise 1: Set up your project, and draw a message of your choosing on the screen.
* Exercise 2 and 3: You will be given an encrypted message, and the decryption key. You will decrypt the message, and display the decrypted message.
* Exercise 4: You will be given an encrypted message, but not the decryption key. You will search through all keys to find the key that properly decrypts a given message, and then display the decoded message.

# Learning Outcomes
* Implement a state machine using behavioral SystemVerilog
* Build a system in SystemVerilog that contains several interacting modules.

# Preliminary

## ASCII Character Values
In computer systems, we typically use an 8-bit number to represent different characters, including uppercase (A, B, C, ...) and lowercase (a, b, c, ...) alphabet characters, digits (0, 1, 2, ...), symbols ($, %, ^, ...) and special characters (space, tab, new line). Online, you can easily find an [ASCII Table](http://www.asciitable.com/) that lists the integer values we use for each of these characters. Almost all computers and electronics you will encounter use these same standardized ASCII values. When you consult this table, be mindful that the values are typically listed in both decimal and hexadecimal, so be sure you are looking at the correct column!
* <span style="color:red">What is the hexadecimal ASCII value for character `D`?</span>
* <span style="color:red">What is the hexadecimal ASCII value for character `d`?</span>
* <span style="color:red">What character is represented by the ASCII value `0x09`?</span>

## Encryption
This lab is all about **encryption** and **decryption**, but it may be the first time you've learned about these things. At the most basic level, an encryption process takes two inputs: a message (we call **plaintext**) and a secret key (we call the **key**). It produces an encrypted message, called the **cyphertext**. Decryption is the reverse process. It takes the cyphertext and the same original key, and produces the original plaintext.

In this lab we will be using the [RC4](https://en.wikipedia.org/wiki/RC4) encryption algorithm. It's an old encryption algorithm, and don't worry, you don't need to understand how it works. What's important to know for our system is that we are going to use __messages that are 16 bytes long (128 bits), and a 24 bit key__.
* <span style="color:red">How many different key values can our system have?</span>

As an example, we may have a 16 byte message, "WE LOVE ECEN 220", which we can assign to `logic` in SystemVerilog like this:
```verilog
logic [127:0] plaintext;
assign plaintext = {8'h57, 8'h45, 8'h20, 8'h4C, 8'h4F, 8'h56, 8'h45, 8'h20, 8'h45, 8'h43, 8'h45, 8'h4E, 8'h20, 8'h32, 8'h32, 8'h30};
// The above is split up to show the individual bytes, we could also store it like this:
assign plaintext = 128'h5745204C4F5645204543454E20323230;
// Or like this:
assign plaintext = {"W", "E", " ", "L", "O", "V", "E", " ", "E", "C", "E", "N", " ", "2", "2", "0"};
// Or like this:
assign plaintext = {"WE LOVE ECEN 220"};
// All of the above assign the plaintext to an identical value
```

If we encrypt this message using the following key:
```verilog
logic [23:0] key;
assign key = 24'h010203;
```
then the resulting cyphertext will be equal to `128'h5c057e9fd5458ec36d7ef9cc4d23ea3e`. If you look up these values in the ASCII table, you will see that the cyphertext is not a readable message. For example, the first byte, `5c` is for character `\`, and some of the bytes (such as `ea`) aren't even valid ASCII character values.

If we decrypt this cyphertext with the same key, we will get back the original message. If we use the wrong key, we will get another unreadable message.

(If you're interested, you can try this out on [https://cryptii.com/pipes/rc4-encryption](https://cryptii.com/pipes/rc4-encryption). Just keep in mind you need to reverse the bytes of the key. If you choose `key = 24'h010203;`, then enter `03 02 01` for the key on the website).

**In this lab you will be given the cyphertext, and then you need to try all of the keys until you find one that produces a readable message. Then you will have hacked the system and figured out the key!**

You might be worried that you will find a key that produces a readable message, but it is not the correct key. Don't worry, the odds of this are extremely unlikely (and we've double checked that this won't happen with the encrypted messages we give you).

<!-- For example, suppose we randomly choose some cyphertext in the hopes of decrypting it into a valid message. Since each byte has 37 valid characters, out of a possible 256, the odds that a specific key value will produce a valid 16-byte message is (37/256)<sup>16</sup> = 3.63e-14. If we try all possible values for the 24-bit key, the odds become 2<sup>24</sup>⋅(37/256)<sup>16</sup>, which is about 1 in 1.6 million. As you see, even for our small message and key size, it is very unlikely that we can find a valid message by luck. In the last exercise of the lab you will be given some cyphertext that //will// decrypt into a valid message, you just need to find the correct key. -->

## Modules
Once you've figured out the key and decrypted the secret message, you will want to display it. Unfortunately there's no easy way to display messages like this on the board, so you are given some modules that can be used to display text on the monitor using the VGA connection.

You can download the following modules and add them to your Vivado project:
* The [decrypt_rc4]({% link resources/modules/rc4.md %}) module. This module performs the decryption. You will provide a 128-bit message, a 24-bit key, and a start signal. It will take some time to perform the decryption, and then it will raise its `done` output and provide the decrypted message.
* The [BitmapToVga]({% link resources/modules/vga_drawer.md %}) module. This module draws pixels to the VGA monitor. You won't have to interact with this module directly in this lab.
* The [CharDrawer_vga]({% link resources/modules/char_drawer_vga.md %}) module. You provide this module with a 128-bit ASCII message, a starting (x, y) coordinate, and a `start` signal. It will output (x,y) pixel values that when connected to the `BitmapToVga` module, will draw the message on the screen. You will be given a top-level module that connects these two modules together, so you only need to worry about sending the correct inputs to the this module.
* A [clk_generator]({% link resources/modules/clk_generator.v %}) module that generates two clocks for this design. THIS IS A VERILOG FILE -- don't add it to your project as a SystemVerilog file or you will get errors.
* The [SevenSegmentControl]({% link resources/modules/seven_seg.md %}) module. As in other labs, this will drive the 7-segment display.

From a previous lab, you will also need the following added to your project:
* The stopwatch module. You will use this module to time how long it takes to crack the code.

# Exercises
A significant portion of the modules needed for this lab have been provided for you or were created in a previous lab. For this lab, you only need to create the `Codebreaker` module. Almost everything you design will be contained in the `Codebreaker` module that you will implement shortly.

## Exercise #1 - Draw a message on the screen
In this first exercise, your `Codebreaker` module will be very simple. Rather than break any codes, you will just hardwire a plaintext message to be displayed through the CharDrawer_vga module. The full system for this lab is shown below.

### Top-Level Module
The top-level module is `Codebreaker_vga_top`. Download it here: [codebreaker_vga_top.sv]({% link resources/modules/codebreaker_vga_top.sv %}). You shouldn't need to modify it (except perhaps for your personal exploration).

Look over the code and the block diagram to make sure you understand how it works. Top-level ports tie to things on the board that you should already be familiar with (LEDs, buttons, seven segments, ...).

<img src="{% link media/lab_10/codebreaker_diagram_vga.png %}" width="1200">

The module contains:
* A `clk_generator` instance, that generates two clocks (only one of which is being used in this design). **NOTE: this is a complex circuit which is able to synthesize multiple other clocks from a single input clock. As such, it REQUIRES at least 400ns simulation time before it will output valid clock signals to the rest of your circuit.**
  - Before you proceed, go back and re-read the previous paragraph. What it is saying is that in your .tcl file, once you start the clock going you should simulate 400ns without doing anything else just so the clock generator can initialize itself. Only then should you start resetting or doing anything else with your circuit.
* A `BitmapToVga` instance, that controls the VGA outputs and has inputs that allow you to modify the pixel colors of the bitmap that is displayed over VGA.
* A `CharDrawer_vga` instance, that is connected to `BitmapToVga` and is used to draw messages to the bitmap, and thus the VGA display.
* The `SevenSegmentControl` and `stopwatch` instances, configured like the Stopwatch lab.
* The `Codebreaker` instance.

**Pass-off:** Once you have drawn the block diagram, meet with a TA and review it. Be sure you can explain how it all hangs together. It is very important you do this before you proceed. If you don't understand how all the pieces work together, you will likely be lost for the rest of the lab (and may, unfortunately, spend a lot of time spinning your wheels).

Next, to implement the design, complete each of the following steps:
1. [Create a Vivado project]({% link tutorials/lab_03/00_vivado_project_setup.md %}) (remember to run the commands to configure the error messages).
2. Add the top-level module to your project.
3. Create an appropriate constraints file for all of the top-level ports.
4. Add all other necessary modules to your project. You will need to expand the modules in the Design Sources list and look to see what sub-modules are expected and make sure you have included all necessary modules. ***ERROR ALERT: clk_generator.v is a Verilog file, NOT a SystemVerilog file. If you mistakenly tell Vivado it is a SystemVerilog file you will get errors about undeclared signal types.***

Now create a `Codebreaker` module (ports listed below). Note, you do not need to include the decrypt module for this exercise since you won't be decrypting anything.

Do the following in your `Codebreaker` module:
1. Drive the `key_display` output to a 0 and drive the `stopwatch_run` output to 1.
2. Connect the `draw_plaintext` output to the `start` input (which is connected to `btnc`).
3. Drive the `plaintext_to_draw` output with a message of your choice.
4. Generate the bitstream and program the board.
5. Verify that your message is displayed after you press `btnc` on the board. Note you will then need to reset your design before it will respond a second time to a `btnc` press.

| Module Name = Codebreaker||||
| Port Name | Direction | Width | Description |
|---|
| clk | Input | 1 | 100 MHz Input Clock |
| reset | Input | 1 | Active-high reset |
| start | Input | 1 | Begin searching for the secret key |
| key_display | Output | 16 | Display portion of current key value being tested |
| stopwatch_run | Output | 1 | Active-high enable of stopwatch |
| draw_plaintext | Output | 1 | Raise this signal to display your message |
| done_drawing_plaintext | Input | 1 | This input goes high when the message is displayed |
| plaintext_to_draw | Output | 128 | The ASCII message to display |

Once this works, you may want to save a copy of the code and associated bitfile before proceeding (since you will now modify and overwrite them).

## Exercise #2 - Decrypt and Display a Single Message (SM design)
The next step of this lab is to actually decrypt and display a message. To do this, you will have to instance the `decrypt_rc4` module in your `Codebreaker` module. Before you start modifying your SystemVerilog, you will design the state machine that interacts with the decryption module.

This exercise is entirely done on paper. Design and draw a finite state machine that:
* Waits for the start button.
* Decrypts the cyphertext and obtains the plaintext.
* Displays the plaintext message on the VGA display.
* Stays in a terminating state until reset.

Inputs to your state machine:
* `Codebreaker` input `start`.
* `Codebreaker` input `done_drawing_plaintext`.
* A new signal you create connected to the `done` output of the `decrypt_rc4` module.

Outputs of your state machine:
* A new signal you create that you should connect to the `enable` input of the `decrypt_rc4` module.
* `draw_plaintext` output of `Codebreaker`.

Remember, the `decrypt_rc4` module takes some time to perform the decryption, so you will need to wait for the `done` output to be high before moving on to display the message on the display.

Tips:
* You can implement this in about 4 states.
* It is good to choose meaningful state names (not S1, S2, etc.) This will help you reason about and debug your state machine.

**Pass-off:** Share your state machine with a TA and get feedback. This is strictly to keep you from wasting a lot of time implementing a state machine which has obvious problems.

## Exercise #3 - Decrypt and Display a Message
Implement your state machine in the `Codebreaker` module. Test your design with the following 128-bit cyphertext and 24-bit key. You should get a readable message in your simulation. You should be simulating `Codebreaker_vga_top` and using your own Tcl file.
```verilog
assign key = 24'h79726a;
assign cyphertext = 128'h93a931affae622e10a029bd3d4bd6ced;
```

In order to make the decoded message be in ASCII instead of hex, change the radix of the `plaintext_to_draw` signal to be ASCII (right click it in the simulation waveform window to see the radix menu).

Use simulation to debug your design when necessary. As mentioned above, **a reset time of at least 400 ns is required** to allow the clk_generator module to begin functioning properly and get a clk signal to your `Codebreaker` module. Remember to use the signals of `Codebreaker_vga_top` and not `Codebreaker` in your Tcl script (for example, use 'btnu' and not 'reset').

<span style="color:red">Include a screenshot of the simulation showing the decoded message in the lab report. Show the `plaintext_to_draw` signal in ASCII instead of hex.</span>

## Exercise #4 - Brute-Force Key Search
<img src="{% link media/lab_10/00_codebreaker_flow.png %}" width="750">

The final object of the lab is to modify your state machine to complete the above flow diagram. This consists of a system that tries every possible key value until the input cyphertext is correctly decrypted.

**You know you have located the correct key when the produced plaintext only contains the characters A-Z, 0-9 or space.**

Changes from the last exercise:
* You will need to add a state that checks the decrypted message and decides whether it is readable. If it is readable, you can display the message and stop, otherwise, you should continue on to the next key.
* The **upper** 16 bits of the key should be output on the LEDs. Although this will not show the precise key you found (since the real key is 24 bits), it will help you see that your search is progressing.
* Your state machine should have a new output that is connected to the `stopwatch_run` output of `Codebreaker`. Run the stopwatch after the user presses the button and stop once a valid plaintext message is found.

Checking that each of the 16 bytes in the plaintext is valid may require writing a very long logic expression. To save yourself some typing, we will give it to you:

```verilog
// Check that each byte of the plaintext is A-Z,0-9 or space.
logic plaintext_is_ascii;
assign plaintext_is_ascii = ((plaintext_to_draw[127:120] >= "A" && plaintext_to_draw[127:120] <= "Z") || (plaintext_to_draw[127:120] >= "0" && plaintext_to_draw[127:120] <= "9") || (plaintext_to_draw[127:120] == " ")) &&
                            ((plaintext_to_draw[119:112] >= "A" && plaintext_to_draw[119:112] <= "Z") || (plaintext_to_draw[119:112] >= "0" && plaintext_to_draw[119:112] <= "9") || (plaintext_to_draw[119:112] == " ")) &&
                            ((plaintext_to_draw[111:104] >= "A" && plaintext_to_draw[111:104] <= "Z") || (plaintext_to_draw[111:104] >= "0" && plaintext_to_draw[111:104] <= "9") || (plaintext_to_draw[111:104] == " ")) &&
                            ((plaintext_to_draw[103:96] >= "A" && plaintext_to_draw[103:96] <= "Z") || (plaintext_to_draw[103:96] >= "0" && plaintext_to_draw[103:96] <= "9") || (plaintext_to_draw[103:96] == " ")) &&
                            ((plaintext_to_draw[95:88] >= "A" && plaintext_to_draw[95:88] <= "Z") || (plaintext_to_draw[95:88] >= "0" && plaintext_to_draw[95:88] <= "9") || (plaintext_to_draw[95:88] == " ")) &&
                            ((plaintext_to_draw[87:80] >= "A" && plaintext_to_draw[87:80] <= "Z") || (plaintext_to_draw[87:80] >= "0" && plaintext_to_draw[87:80] <= "9") || (plaintext_to_draw[87:80] == " ")) &&
                            ((plaintext_to_draw[79:72] >= "A" && plaintext_to_draw[79:72] <= "Z") || (plaintext_to_draw[79:72] >= "0" && plaintext_to_draw[79:72] <= "9") || (plaintext_to_draw[79:72] == " ")) &&
                            ((plaintext_to_draw[71:64] >= "A" && plaintext_to_draw[71:64] <= "Z") || (plaintext_to_draw[71:64] >= "0" && plaintext_to_draw[71:64] <= "9") || (plaintext_to_draw[71:64] == " ")) &&
                            ((plaintext_to_draw[63:56] >= "A" && plaintext_to_draw[63:56] <= "Z") || (plaintext_to_draw[63:56] >= "0" && plaintext_to_draw[63:56] <= "9") || (plaintext_to_draw[63:56] == " ")) &&
                            ((plaintext_to_draw[55:48] >= "A" && plaintext_to_draw[55:48] <= "Z") || (plaintext_to_draw[55:48] >= "0" && plaintext_to_draw[55:48] <= "9") || (plaintext_to_draw[55:48] == " ")) &&
                            ((plaintext_to_draw[47:40] >= "A" && plaintext_to_draw[47:40] <= "Z") || (plaintext_to_draw[47:40] >= "0" && plaintext_to_draw[47:40] <= "9") || (plaintext_to_draw[47:40] == " ")) &&
                            ((plaintext_to_draw[39:32] >= "A" && plaintext_to_draw[39:32] <= "Z") || (plaintext_to_draw[39:32] >= "0" && plaintext_to_draw[39:32] <= "9") || (plaintext_to_draw[39:32] == " ")) &&
                            ((plaintext_to_draw[31:24] >= "A" && plaintext_to_draw[31:24] <= "Z") || (plaintext_to_draw[31:24] >= "0" && plaintext_to_draw[31:24] <= "9") || (plaintext_to_draw[31:24] == " ")) &&
                            ((plaintext_to_draw[23:16] >= "A" && plaintext_to_draw[23:16] <= "Z") || (plaintext_to_draw[23:16] >= "0" && plaintext_to_draw[23:16] <= "9") || (plaintext_to_draw[23:16] == " ")) &&
                            ((plaintext_to_draw[15:8] >= "A" && plaintext_to_draw[15:8] <= "Z") || (plaintext_to_draw[15:8] >= "0" && plaintext_to_draw[15:8] <= "9") || (plaintext_to_draw[15:8] == " ")) &&
                            ((plaintext_to_draw[7:0] >= "A" && plaintext_to_draw[7:0] <= "Z") || (plaintext_to_draw[7:0] >= "0" && plaintext_to_draw[7:0] <= "9") || (plaintext_to_draw[7:0] == " "));
```

Simulate your brute-force design on the cyphertext below. HINT: the key is 000005 -- be sure your circuit finds that one.
```verilog
assign cyphertext = 128'hca7d05cd7e096d91acaf6fd347ef4994;
```

<span style="color:red">Include a screenshot of your simulation waveform demonstrating that your simulation works and finds the correct key (be sure both the key and resulting decoded text are visible in the simulation).</span>

## Exercise #5 - Synthesize and Implement
Now, synthesize and run the design you just simulated in hardware to verify that you get the right message printed to the VGA display. Note: since the key is only '5' it won't show on the LEDs because they are only displaying the top 16 bits of the 24-bit keyspace. Getting the message printed will be your sign that it is working.

Finally, you seem to have a working brute-force code breaker -- congratulations!

Your last step is to choose one of the cyphertexts below, add it to your design, and re-synthesize/implement/bitgen and run in hardware to demonstrate that it is working. Each of these cyphertexts has a different key and will produce a different message. You are required to demonstrate your codebreaker breaking just one of them. But, you may try several to see how your design works.
```verilog
assign cyphertext = 128'ha13a3ab3071897088f3233a58d6238bb;
assign cyphertext = 128'hb8935bbf5f819bcfec46da11d5393d4f;
assign cyphertext = 128'h396d6e70500754ff726bd5fb963998ce;
assign cyphertext = 128'h189f2800aac06ce4a74292bffe33fd2c;
assign cyphertext = 128'h19b39b044dc39c4e98f9dfb44a0b7c11;
```

<!--
"BRUTE FORCE  RC4" key = 24'hAAAAAA;
"EZ KEY IS 000300" key = 24'h000300;
"THAT TOOK FORVER" key = 24'hFFFFFF;
" I PICKED NUM 4 " key = 24'h123456;
"YOU CRACK ME UP " key = 24'h6DB6DB;
-->

<!--
```verilog
assign cyphertext = 128'hca91b1577f34443894de1001885d6aa5;
assign cyphertext = 128'h57e967f1e86498a1eedc596a84f1fa26;
assign cyphertext = 128'h5b99cbef5dffe0f58c3e81df23ba858f;
assign cyphertext = 128'h77c58ceb8e5b342a583db6be53f8097c;
assign cyphertext = 128'hbd6a2012369d963f18802a8a70ca7ec7;
```
-->
<!-- Small keys for simulation:
"BRUTE FORCE  RC4" key = 24'h000009;
"EZ KEY IS 000003" key = 24'h000003;
"THAT TOOK FORVER" key = 24'h000013;
" I PICKED NUM 4 " key = 24'h000004;
"YOU CRACK ME UP " key = 24'h000007;
-->

<span style="color:red">Paste your synthesis logs to Learning Suite to demonstrate that you had no errors or critical warnings. If you do have any CRITICAL WARNINGS, explain the source of them and why they are OK (they likely are not OK).</span>

A few WARNINGS do sometimes appear and they are often OK, but there is no guarantee. Carefully read them and, if in question, ask about them.

<span style="color:red">Paste your `Codebreaker` SystemVerilog module.</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">
Choose one of the Exercise #5 cyphertexts and demonstrate how your circuit design running on the FPGA board breaks the code. When the key is found, your system should stop with the key value showing on the LEDs and the decoded message showing on the screen. Be sure to state which cyphertext you chose (of the 5) and show precisely what key was found.
</span>

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>
