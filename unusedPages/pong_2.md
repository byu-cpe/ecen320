---
layout: page
toc: true
title: "Pong: Part 2"
lab: Pong2
---

In this **two-week** lab, you will use your ball and line modules to make a Pong game.
* Exercise 1: You will use your modules from Part 1 to draw a ball and two paddles on the screen.
* Exercise 2: Make the ball bounce around the screen. (This exercise is the largest part of the lab)
* Exercise 3: Make the paddles move, and make the ball bounce off of the paddles.
* Exercise 4: Keep score.
* Exercise 5: Extend the basic game with a new feature.

# Learning Outcomes
* Learn how to implement more complex digital systems that combine several modules using state machines, sequential and combinational circuitry.

# Preliminary
This video shows an implementation of the Pong game for this lab. Your implementation does not need to look exactly like this. Feel free to change colors, object sizes, paddle positions, etc. Note that the video shows a wide-screen monitor, so there are "black bars" on the left and right that aren't part of the drawable space.

<iframe width="768" height="432" src="https://www.youtube.com/embed/cUQDCrGownw?rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

As you can see in the video above, the Pong game consists of drawing and moving around three objects: the ball, the left paddle and the right paddle. The animation is done by continuously drawing the objects, waiting some time, erasing them, moving them, and then immediately redrawing them and repeating the process. Erasing is done by drawing the objects black. The buttons are used to move the paddles, and the score is displayed using the seven segment controller.

## State Machine
The diagram below provides the state machine that will control most of the Pong game. Rather than have separate states for drawing and erasing, the state machine is designed to use the same three states to draw the objects. Thus, the state machine will continuously repeat the state ordering (PADDLE_L->BALL->PADDLE_R->WAIT_TIMER->) to draw the objects and wait for some time, then (PADDLE_L->BALL->PADDLE_R->MOVE->) to erase the objects, and move them before repeating the same sequence again.

<img src="{% link media/lab_pong/pong_sm.png %}" width="768">

Some explanation of the state machine:
* `ballStart` and `lineStart` will trigger the drawing of the ball and line objects, and are connected to the `start` inputs of the modules you created last lab. `ballDone` and `lineDone` are connected to the `done` ports of these modules.
* `initGame` will reset the appropriate registers (ball location, ball direction, paddle locations, score, etc.)
* Although not shown in the state diagram, a 1-bit flip-fop named `erasing` will control whether the BALL, PADDLE_L and PADDLE_R states draw the objects in color or black. It is also used to determine whether the state machine should wait, or move the objects after drawing them. The `invertErasing` signal output by the state machine will cause this flip-flop to invert its value.
* You are free to choose how long to wait in the WAIT_TIMER state. Somewhere between 0.1s and 0.001s is a good choice, depending on how fast you want the game to play.

<span style="color:red">Given your 100 MHz system clock, how many cycles do you need to wait for a 0.01 second delay?</span>

<span style="color:red">Given your 100 MHz system clock, how many bits wide does your counter need to be to implement a 0.01 second delay?</span>

<span style="color:red">Why is `invertErasing` a mealy output when leaving state `PADDLE_R` instead of just having it be a Moore output in that state?</span>

## Module Design
Within the `Pong` module, the state machine is connected to a number of other components that implement the game loop timer, manage the ball location and direction, paddle locations, and score. This is shown below. These blocks **are not submodules**, but rather represent different sequential and combinational blocks that will make up your `Pong` module.

The `Pong` module will also instance the `BallDrawer` and `VLineDrawer` modules, although for simplicity, this is not shown in the diagram.

<img src="{% link media/lab_pong/pong_system_diagram.png %}">

# Exercises

## Exercise #1 - Drawing the objects
**In this exercise, you will implement just enough of the above system to draw the ball and two paddles on the screen, without any movement or user interaction.**

Review the state machine and system diagrams above, and make sure you understand how the Pong game will work. In this exercise you will implement a limited set of features: simply drawing the ball and two paddles.

What to do in this exercise:

1. Create a new Vivado project, add your `BallDrawer` and `VLineDrawer` modules, as well as the `BitmapToVga`, `clk_generator` and `SevenSegmentControl` modules. Also add the top-level module provided here: [top_pong.sv]({% link resources/modules/top_pong.sv %})

2. Inspect the top-level module, and note how the modules are connected. The module instantiates the `BitmapToVga` module and the `clk_generator` module needed to draw graphics on the VGA monitor. It also instantiates a `Pong` module (which you will create in a later step), which controls the inputs to the `BitmapToVga` module. The four buttons are provided as inputs to the `Pong` module to control the paddle movements. **Note: You shouldn't change the top-level file**.

3. Add a constraints file to your project that is configured appropriately.

4. Create a `Pong` module and add it to your project (a starting file is provided below). The `Pong` module is where you will add all of your code for this lab. It instantiates a copy of your `BallDrawer` and `VLineDrawer`, and will include the state machine and other module components shown in the diagram above.

Your `Pong` module contains the ports described here:

| Module Name = Pong ||||
| Port Name | Direction | Width | Description |
| --- ||||
| clk | Input | 1 | 100 MHz Clock |
| reset | Input | 1 | Active-high reset |
| LPaddleUp| Input | 1 | When high, move left paddle up |
| LPaddleDown| Input | 1 | When high, move left paddle down|
| RPaddleUp| Input | 1 | When high, move right paddle up |
| RPaddleDown| Input | 1 | When high, move right paddle down |
| vga_x | Output | 9 | BitmapToVga X-Coordinate |
| vga_y | Output | 8 | BitmapToVga Y-Coordinate |
| vga_color | Output | 3 | BitmapToVga Color |
| vga_wr_en | Output | 1 | BitmapToVga Write Enable |
| P1score | Output | 8 | Player 1 score (player 1 controls the left paddle) |
| P2score | Output | 8 | Player 2 score |

Here is a file to get started:

[Pong.sv]({% link resources/modules/Pong.sv %})
```verilog
// Add your header here
`default_nettype none

module Pong (
    input wire logic        clk,
    input wire logic        reset,

    input wire logic        LPaddleUp,
    input wire logic        LPaddleDown,
    input wire logic        RPaddleUp,
    input wire logic        RPaddleDown,

    output logic    [8:0]   vga_x,
    output logic    [7:0]   vga_y,
    output logic    [2:0]   vga_color,
    output logic            vga_wr_en,

    output logic    [7:0]   P1score,
    output logic    [7:0]   P2score
);

localparam              PADDLE_H = 40; // paddle height
localparam              BALL_W = 4; // ball width and height
localparam              BALL_H = 4;
localparam              VGA_W = 320; // screen width and height
localparam              VGA_H = 240;

// ball drawer signals
logic           [8:0]   ballDrawX;
logic           [7:0]   ballDrawY;
logic                   ballStart;
logic                   ballDone;
logic                   ballDrawEn;

// line drawer for paddles
logic           [8:0]   lineX, lineDrawX;
logic           [7:0]   lineY, lineDrawY;
logic                   lineStart;
logic                   lineDone;
logic                   lineDrawEn;

// location of ball, paddles
logic           [8:0]   ballX;
logic           [7:0]   ballY;
logic           [7:0]   LPaddleY;
logic           [7:0]   RPaddleY;

// velocity of ball
logic                   ballMovingRight;
logic                   ballMovingDown;

// delay counter
logic           [31:0]  timerCount;
logic                   timerDone;
logic                   timerRst;

logic                   initGame;
logic                   moveAndScore;
logic                   erasing;
logic                   invertErasing;

////////////////// Game Loop Timer //////////////////
// Added in exercise 2

////////////////// Erasing //////////////////
// Added in exercise 2

////////////////// Ball Location //////////////////
// Added in exercise 1, updated in exercise 2

////////////////// Paddle Locations //////////////////
// Added in exercise 1, updated in exercise 3

////////////////// Player Score //////////////////
// Added in exercise 1, updated in exercise 4

////////////////// Ball Direction //////////////////
// Added in exercise 2, updated in exercise 3

////////////////// State Machine //////////////////
// Added in exercise 1, updated in exercise 2

////////////////// Drawing Submodules //////////////////
BallDrawer BallDrawer_inst (
    .clk(clk),
    .reset(reset),
    .draw(ballDrawEn),
    .start(ballStart),
    .done(ballDone),
    .x_in(ballX),
    .y_in(ballY),
    .x_out(ballDrawX),
    .y_out(ballDrawY)
);

VLineDrawer VLineDrawer_inst (
    .clk(clk),
    .reset(reset),
    .start(lineStart),
    .draw(lineDrawEn),
    .done(lineDone),
    .x_in(lineX),
    .y_in(lineY),
    .x_out(lineDrawX),
    .y_out(lineDrawY),
    .height(PADDLE_H)
);

endmodule
```

5. Create the above state machine with just the states needed to start the game and draw the objects: INIT, BALL, PADDLE_L and PADDLE_R. For this exercise you might want to create a DONE state that the state machine stays in once it is done drawing the right paddle.

6. Implement the other components as follows:
   * **Ball Location:** You should create a new `always_ff` block to manage the ball location. Create two registers, `ballX` and `ballY` that are reset to the center of the screen when `initGame` is true. This is sufficient for this exercise.
   * **Paddle Locations:** You should create a new `always_ff` block to manage the paddle locations. Create two registers, `LPaddleY` and `RPaddleY` that position the paddles halfway down the screen when `initGame` is true. This is sufficient for this exercise.
   * **Player Scores:** You should create a new `always_ff` block to manage the player scores. For this exercise, just assign the `P1score` and `P2score` registers to 0 when `initGame` is true.
   * **Ball Direction:** Not needed in this exercise.
   * **Game Loop Timer:** Not needed in this exercise.
   * **Erase Switch:** Not needed in this exercise.

7. Update your state machine to also output the other outputs shown in the system diagram:
   * `vga_x`, `vga_y`, and `vga_wr_en` should be connected to either `ballDrawX`, `ballDrawY`, and `ballDrawEn` or the corresponding signals from the `VLineDrawer`, depending on the state.
   * Assign `vga_color` to values of your choice in each state.
   * Assign `lineX` to appropriate values of your choice in the two states that draw the paddles. Don't place the paddles right at the edge of the screen (x=0 or x=319), as sometimes the first/last few columns/rows of pixels may be cut off.
   * Assign `lineY` to the appropriate paddle signal, `LPaddleY` or `RPaddleY`, depending on the state.

*You may notice that the `Pong` module includes one instantiation of the `BallDrawer` and one instantiation of the `VLineDrawer`. You SHOULD NOT add any more instantiations of these module. Even through you are drawing multiple paddles, drawing and erasing balls multiple times, only one instance of each module will be used.*

8. Generate a bitstream and program your board. Simulate your design to debug.

** Exercise #1 Pass-off:** Show that your implementation draws the paddles and ball on the display.

----

## Exercise #2 - Bouncing Ball
In this exercise you will modify your `Pong` module to make the ball bounce around the screen. You don't need to interact with the paddles or keep score yet.

Suggested approach:

1. Add the remaining two states of the state machine.

2. Update the following components:
   * **Game Loop Timer:** Implement this as a counter using the `timerRst` and `timerDone` signals.
   * **Ball Location:** Add more logic to your ball location component. When in the move state (`moveAndScore` is high), update the ball location according to its direction. Consider the values of `ballMovingRight` and `ballMovingDown` and either add 1 or subtract 1 from `ballX` and `ballY` accordingly.
   * **Ball Direction: ** You should create a new `always_ff` block to manage the ball directions (`ballMovingRight` and `ballMovingDown` registers). On `initGame`, you should reset these registers to values of your choice. When the ball hits a wall (check the ball location), you should update these registers appropriately.
   * **Erase Switch:** Create a flip-flop, `erasing` that is reset to 0 on `initGame` and flips its value if `invertErase` is high.

** A note on debugging:** You will likely need to debug your design to get it working properly. The best way to do this is to set up a simulation Tcl file. Consider how you can change your design to make it easier to simulate and debug. For example, you could make the timer delay small to make it faster to simulate, or change the values assigned to registers on `initGame`. For example, you could initialize the ball close to a wall so that you don't need much simulation time in order to see if it bounced off of the wall correctly.

** Exercise #2 Pass-Off:** Show that your implementation can move the ball around the screen and bounce it off the walls. You don't need to worry about paddle collisions yet.

----

## Exercise #3 - Moving the Paddles and Collisions
In this exercise you will implement the logic to move the paddles when the user presses the buttons.

Update the following components:
* **Ball Direction:** Detect if the ball is located on a player paddle, and update the ball direction appropriately. To keep things simple, you can assume the ball only bounces off of the front of the paddle.
* **Paddle Locations:** In the move state (`moveAndScore` is high), move the paddles appropriately based on the button inputs (`LPaddleUp`, `RPaddleUp`, etc.) Because we have a wait state in our game loop, you don't need to worry about any button debouncing, it is sufficient to just check the button values, and modify the paddle locations as necessary. You may want to move the paddles by 2 or 3 pixels, so that the paddles can move faster than the ball. The logic to do this is a bit tricky, so think about it carefully. You don't want the paddles to be able to move off of the screen.

** Exercise #3 Pass-Off:** Demonstrate that the buttons move the paddles up and down, and that the ball collides and bounces off the paddles consistently.

----

## Exercise #4 - Keeping Score
In this exercise you will complete the game by adding score keeping. The player scores are already shown on the seven segment displays, you just need to update the registers you created earlier when a player scores a point.

Add logic that looks at the ball location in the move state (`moveAndScore` is high), and updates the player scores appropriately.

** Exercise #4 Pass-Off:** Demonstrate your basic game.

----

## Exercise #5 - Creative Extension

After the basic game is working, extend it with a new feature. Some ideas are given below.
* Shrink a player's paddle when a point is scored to make the game more challenging
* Speed up the game play when a point is scored to make the game more challenging
* Flash the ball or paddles after a collision or when a point is scored
* Score more points if the last ball-paddle collision was in the center of a paddle

For more extension ideas, match an action with an event or input.

### Event or Input
* Switch settings, static (at startup) or dynamic (during game play)
* A point is scored (ball bounces off a side wall)
* A ball bounces off any wall
* Any ball-paddle collision
* A ball-paddle collision occurs at the center of a paddle
* A score threshold is reached

### Actions
* Change the color of an object (ball, paddle)
* Change the size or shape of an object
* Flash an object
* Change the speed of an object or game play overall
* Introduce more than one ball
* Change background color
* Increment score by more than one point
* Signal the end of the game or the winner
* Pause/Resume the game

** Exercise #5 Pass-Off:** Demonstrate your extended game.

<span style="color:red">Paste your Pong SystemVerilog module to Learning Suite.</span>

----

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Demonstrate your completed game with all the required features, that is, bouncing ball, moving paddles, collisions with paddles, keeping score, and creative extension. Clearly describe your extension.</span>

# Final Questions
<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Please provide any suggestions for improving this lab in the future.</span>
