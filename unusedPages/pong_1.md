---
layout: page
toc: true
title: "Pong: Part 1"
lab: Pong1
---

This lab and the next lab work together to build a Pong game on the VGA display. In this lab you will create two modules, a ball drawer and a vertical line drawer.
* Exercise 1: Designing a BallDrawer state machine on paper.
* Exercise 2: Implementing the BallDrawer state machine in SystemVerilog, and verify with simulation.
* Exercise 3: Testing that your BallDrawer state machine correctly displays a ball on the VGA display.
* Exercise 4: Create a VLineDrawer module that draws vertical lines, simulate, and test with the VGA display.

<!--**Note:** Exercise 4 is optional. You might not have time to complete it in this lab. You will still get full points for pass-off without it, but if you want to complete a full Pong game next lab you will need it. If you choose not to complete it, next week you will make a ball bounce around the screen (but without paddles and user interaction).-->

# Learning Outcomes
* Learn how to implement state machines using behavioral SystemVerilog.

# Preliminary
In this lab you will be using the [BitmapToVga]({% link resources/modules/vga_drawer.md %}) module. Make sure you know how this module works.

<span style="color:red">What 3-bit binary value would you provide to the BitmapToVga module to set the color of a pixel to cyan?</span>

<span style="color:red">Assuming you can write 1 pixel per clock cycle, what is the minimum number of cycles required to update the entire image?</span>

<span style="color:red">Assuming you can write 1 pixel per clock cycle at 100 MHz, how many microseconds would it take to clear the entire image?</span>

# Exercises

## Exercise #1 - BallDrawer State Machine
Design a state machine (on paper) that can be used to draw a ball. The module interface is described below:

| Module Name = BallDrawer ||||
| Port Name | Direction | Width | Description |
| --- ||||
| clk | Input | 1 | 100 MHz Input Clock |
| reset | Input | 1 | Reset |
| start| Input | 1 | High to start drawing a ball, must go back low before drawing another ball |
| draw | Output | 1 | High when the module is outputting a valid pixel location to draw |
| done | Output | 1 | High on cycle that last pixel location is output |
| x_in | Input | 9 | Leftmost x-Coordinate of ball to be drawn |
| y_in | Input | 8 | Topmost y-Coordinate of ball to be drawn |
| x_out | Output | 9 | x-Coordinate to be drawn |
| y_out | Output | 8 | y-Coordinate to be drawn |

The following shows a diagram of a ball with 5 pixels, and a corresponding waveform for drawing this ball at (100,50).

<img src="{% link media/lab_pong/ball_drawing_5.png %}">
<img src="{% link media/lab_pong/ball_drawing2.png %}">

Your state machine does not need to produce the exact same timing as the waveform above, but it does need to obey a few rules:
* The state machine should wait for the `start` signal before starting to draw a ball.
* For each pixel that needs to be drawn, the state machine should output an (x,y) coordinate using the `x_out` and `y_out` outputs, and assert the `draw` signal to indicate that a valid pixel is being output.
* The `done` signal should be asserted for exactly 1 cycle after the ball is done being drawn (or during the last pixel).
* The state machine should wait for the `start` signal to go low before allowing another ball to be drawn.

Here are some other ball shapes you can use, or you can design your own. Your ball needs to have at least 4 pixels.

<img src="{% link media/lab_pong/ball_drawing_4.png %}">
<img src="{% link media/lab_pong/ball_drawing_grid.png %}">

** Exercise #1 Pass-off:** Verify that your state machine meets the requirements described above.

----

## Exercise #2 - BallDrawer SystemVerilog Module
Create the `BallDrawer` SystemVerilog module that implements your state machine.

```verilog
module BallDrawer (
    input wire logic            clk,
    input wire logic            reset,
    input wire logic            start,
    output logic                draw,
    output logic                done,
    input wire logic    [8:0]   x_in,
    input wire logic    [7:0]   y_in,
    output logic        [8:0]   x_out,
    output logic        [7:0]   y_out
);

endmodule
```

Simulate your `BallDrawer` module. You can use the following Tcl script. It will test drawing your Ball in two different locations. Make sure your state machine doesn't draw the second ball until the `start` signal goes low and then back high the second time. (Remember that on the waveform you can select multiple signals and right-click to change the radix. It may be helpful to display the x,y coordinates as unsigned decimal).

```tcl
restart

add_force clk {0 0} {1 5ns} -repeat_every 10ns
add_force reset 1
add_force start 0
run 10ns
add_force reset 0
run 10ns

# Draw ball at 100, 200
add_force x_in -radix dec 100
add_force y_in -radix dec 200
add_force start 1
run 120ns

# Lower start signal
add_force start 0
run 20ns

# Draw ball at 150, 20
add_force x_in -radix dec 150
add_force y_in -radix dec 20
add_force start 1
run 120ns
```

** Exercise #2 Pass-off:** Show the simulation of your `BallDrawer` module and explain how you tested its functionality.

----

## Exercise #3 - Drawing Pong Objects on the VGA Display
In this exercise you will verify that your `BallDrawer` module works correctly, by drawing a ball to the VGA display. The following top-level module can be used. Look it over and make sure you understand it.

The module works by connecting up the appropriate signals from your `BallDrawer` module to the `BitmapToVga` module. You shouldn't have to change this file to get it to work properly; however, you may decide to change it later to modify the ball location or color.

[top_object_drawer.sv]({% link resources/modules/top_object_drawer.sv %})

Add the above file to your Vivado project and make sure it is configured as the top-level module. Add a constraints file to your project that is configured appropriately.

**Exercise #3 Pass-Off:** Verify that you are successfully drawing a ball on the screen.

<span style="color:red">Paste your BallDrawer SystemVerilog module.</span>

----

## Exercise #4 - Line Drawer
<!-- ** You only need to complete this exercise if you want to complete the full Pong game next lab.**-->

Now that you have created a module to draw a ball, you will follow the same process to create a module that can draw vertical lines of arbitrary height.

Create the following module. Use a state machine to implement the described behavior.

| Module Name = VLineDrawer ||||
| Port Name | Direction | Width | Description |
| --- ||||
| clk | Input | 1 | 100 MHz Input Clock |
| reset | Input | 1 | Reset |
| start | Input | 1 | High to start drawing a line |
| draw | Output | 1 | High when the module is outputting a valid pixel location to draw |
| done | Output | 1 | High on cycle that last pixel is drawn |
| x_in | Input | 9 | x-Coordinate of line to be drawn |
| y_in | Input | 8 | y-Coordinate of top of the line |
| height | Input | 8 | Height of line in pixels |
| x_out | Output | 9 | x-Coordinate to be drawn |
| y_out | Output | 8 | y-Coordinate to be drawn |

This module should work very similarly to your `BallDrawer` module, except now there is a `height` input that dictates the height of the line. Since the height can be changed, you can't use one state per pixel being drawn. Instead, your state machine will need to interact with a counter to keep track of how many pixels you need to draw.

The following shows a diagram of a line 6 pixels tall, and a waveform for drawing this line at (100, 50).

<img src="{% link media/lab_pong/line_drawing.png %}">
<img src="{% link media/lab_pong/line_drawing_waveform.png %}">

Simulate your `VLineDrawer` module to ensure it is working correctly. You can probably re-use the Tcl above with minimal changes. Make sure to set the `height` input, and test drawing two lines of different height.

<span style="color:red">Paste your VLineDrawer Tcl simulation file.</span>

Modify the top-level from the last exercise to draw a vertical line instead of a ball.

** Exercise #4 Pass-off:** Verify that you are successfully drawing a line on the screen.

<span style="color:red">Paste your VLineDrawer SystemVerilog module.</span>

----

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Show your display with a ball correctly drawn by your BallDrawer module.</span>

<span style="color:green">Show your display with a line correctly drawn by your VLineDrawer module.</span>

# Final Questions
<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>
