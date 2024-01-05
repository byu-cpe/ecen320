/***************************************************************************
* Module: top_object_drawer
*
* Author: Jeff Goeders
* Date: May 13, 2019
*
* Description: Top-level module for drawing Pong objects.
****************************************************************************/
`default_nettype none

module top_object_drawer (
    input wire logic            clk,     // 100 MHz input clock
    input wire logic            btnc,    // Active-high reset

    output logic        [3:0]   VGA_R,   // Red
    output logic        [3:0]   VGA_G,   // Green
    output logic        [3:0]   VGA_B,   // Blue
    output logic                VGA_HS,  // Horizontal Sync
    output logic                VGA_VS   // Vertical Sync
);

localparam START_DELAY = 4; // Start pulse delay after reset
logic[START_DELAY:0] sreg;  // Shift register

logic           clk_100;
logic           clk_25;
logic           reset;
logic           start;

logic   [2:0]   vga_color;
logic   [8:0]   vga_x;
logic   [7:0]   vga_y;
logic           vga_wr_en;

assign reset = btnc;
assign start = sreg[START_DELAY];

always_ff @(posedge clk_100)
    if (reset)
        sreg <= 1;
    else
        sreg <= {sreg[START_DELAY-1:0], 1'b0};

BallDrawer BallDrawer_inst (
    .clk(clk_100),
    .reset(reset),
    .start(start),
    .draw(vga_wr_en),
    .done(),
    .x_in(50),
    .y_in(50),
    .x_out(vga_x),
    .y_out(vga_y)
);

/*VLineDrawer VLineDrawer_inst (
    .clk(clk_100),
    .reset(reset),
    .start(start),
    .draw(vga_wr_en),
    .done(),
    .x_in(100),
    .y_in(100),
    .x_out(vga_x),
    .y_out(vga_y),
    .height(40)
);*/

clk_generator clk_generator_inst (
    .clk_100(clk_100),
    .clk_25(clk_25),
    .clk_in_100(clk)
);

BitmapToVga BitmapToVga_inst (
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .clk(clk_100),
    .clk_vga(clk_25),
    .VGA_hsync(VGA_HS),
    .VGA_vsync(VGA_VS),
    .reset(reset),
    .wr_en(vga_wr_en),
    .x(vga_x),
    .y(vga_y),
    .color(3'b110)
);

endmodule
