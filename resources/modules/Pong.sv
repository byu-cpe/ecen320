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
