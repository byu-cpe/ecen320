`default_nettype none

module codebreaker_vga_top (
    input wire logic            clk,     // 100 MHz input clock
    input wire logic            btnu,    // Active-high reset

    output logic        [3:0]   VGA_R,   // Red
    output logic        [3:0]   VGA_G,   // Green
    output logic        [3:0]   VGA_B,   // Blue
    output logic                VGA_HS,  // Horizontal Sync
    output logic                VGA_VS,  // Vertical Sync

    input wire logic            btnc,    // Start Codebreaker
    output logic        [15:0]  led,

    output logic        [3:0]   anode,
    output logic        [7:0]   segment
);

logic           clk_100;                //  System Clock
logic           clk_25;                 //  VGA Monitor clock
logic           reset;                  //  Active-high reset

logic   [2:0]   vga_color;              //  Color value to write to VGA bitmap (red, green, blue)
logic   [8:0]   vga_x;                  //  X-coordinate to write to VGA bitmap (0 to 319)
logic   [7:0]   vga_y;                  //  Y-coordinate to write to VGA bitmap (0 to 239)
logic           vga_wr_en;              //  Enable signal to write to VGA bitmap

logic   [15:0]  seven_seg_data;         //  Value to display on the 4 seven-seg displays

logic           stopwatch_run;          //  Active-high enable for stopwatch

logic           enable_drawing_plaintext;
logic           done_drawing_plaintext;
logic   [127:0] plaintext;

assign reset = btnu;

// VGA module needs 25MHz clock, so use this module to generate
// a 25MHz clock, based on the 100MHz input clock.
clk_generator clk_generator_inst (
    .clk_100(clk_100),
    .clk_25(clk_25),
    .clk_in_100(clk)
);

// Module to send bitmap image to VGA outputs, with inputs to
// modify pixel colors in bitmap image.
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
    .color(3'b010)
);

CharDrawer_vga CharDrawer_inst (
    .clk(clk_100),
    .reset(reset),
    .enable(enable_drawing_plaintext),
    .done(done_drawing_plaintext),
    .x_out(vga_x),
    .y_out(vga_y),
    .x_in(50),
    .y_in(50),
    .string_in(plaintext),
    .draw_en(vga_wr_en)
);

// Seven-Segment Controller used for the stopwatch
SevenSegmentControl SSC (
    .clk(clk_100),
    .reset(reset),
    .dataIn(seven_seg_data),
    .digitDisplay(4'hF),
    .digitPoint(4'b0100),
    .anode(anode),
    .segment(segment)
);

// Stopwatch module from previous lab, used to track how
// long it takes to find the correct key.
stopwatch stopwatch_inst (
    .clk(clk_100),
    .reset(reset),
    .run(stopwatch_run),
    .digit3(seven_seg_data[15:12]),
    .digit2(seven_seg_data[11:8]),
    .digit1(seven_seg_data[7:4]),
    .digit0(seven_seg_data[3:0])
);

// Module for this lab, responsible for cracking the key, and
// displaying the decoded message.
Codebreaker Codebreaker_inst (
    .clk(clk_100),
    .reset(reset),
    .start(btnc),
    .key_display(led),
    .stopwatch_run(stopwatch_run),
    .draw_plaintext(enable_drawing_plaintext),
    .done_drawing_plaintext(done_drawing_plaintext),
    .plaintext_to_draw(plaintext)
);

endmodule
