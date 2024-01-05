`default_nettype none

module CharDrawer_vga #(
    parameter MAX_CHARS = 16
) (
    input wire logic                            clk,        // Clock
    input wire logic                            reset,      // Active-high reset
    input wire logic                            enable,     // Start drawing
    output logic                                done,       // Done drawing
    input wire logic    [8:0]                   x_in,       // Top-left (x,y)
    input wire logic    [7:0]                   y_in,
    input wire logic    [(MAX_CHARS * 8) - 1:0] string_in,  // ASCII character string to draw
                                                            // MSB is drawn first
    output logic        [8:0]                   x_out,      // Output (x,y) of pixel to draw
    output logic        [7:0]                   y_out,
    output logic                                draw_en     // Active-high enable of drawing
);

localparam CHAR_COLS = 5;
localparam CHAR_ROWS = 5;

logic   [8:0]               x;                  // Track top-left (x,y) of current character to draw
logic   [7:0]               y;

// ROM to lookup pixel map of each character, row by row
logic   [8:0]               pixel_rom_addr;     // { 5 bits of char_id, see table below, 3 bits for row #}
logic   [4:0]               pixel_rom_out;      // row of pixel data, output from ROM
logic   [4:0]               pixel_row;          // Shift register populated with row of pixel data, then shifted out as it is drawn

// ROM to lookup width of each character
logic   [5:0]               width_rom_addr;     // char_id
logic   [2:0]               width_rom_out;      // width of character
logic   [2:0]               char_width;         // width of character, saved to register

// char_id
// -------
// 0-25     = A-Z
// 26-35    = 0-9
// 36       = " " (space)
// 37       = all unsported characters, except null (0) which is not printed

logic   [7:0]               char_idx;           // Index of character being drawn, starts at MAX_CHARS-1, decrements to 0
logic   [2:0]               col_idx;            // Current column being drawn
logic   [2:0]               row_idx;            // Current row being drawn

logic                       col_done;           // High when on the last column of the row
logic                       row_done;           // High when on the last row of the character
logic                       char_done;          // High when on the last row and col

// State Machine
typedef enum {S_INIT, S_NEXT_CHAR, S_READ_ROW, S_SAVE_ROW, S_DRAW_ROW, S_DONE} StateType;
StateType cs;

logic                       char_is_null;
logic   [7:0]               curr_char;
logic   [7:0]               char_select;


////////////////////////////////// Output Logic ////////////////////////////////////
assign x_out = x + col_idx;
assign y_out = y + row_idx;
assign draw_en = pixel_row[CHAR_COLS - 1];
assign done = (char_done && char_idx == 0) || (cs == S_NEXT_CHAR && char_is_null && char_idx == 0);

////////////////////////////////// State Machine //////////////////////////////////
always_ff @(posedge clk) begin
    if (reset) begin
        cs <= S_INIT;
    end else begin
        case (cs)
            S_INIT:
                if (enable)
                    cs <= S_NEXT_CHAR;
            S_NEXT_CHAR:
                if (~char_is_null)
                    cs <= S_READ_ROW;
                else if (char_idx == 0)
                    cs <= S_DONE;
            S_READ_ROW:
                cs <= S_SAVE_ROW;
            S_SAVE_ROW:
                cs <= S_DRAW_ROW;
            S_DRAW_ROW: begin
                if (col_done) begin
                    if (row_done) begin
                        if (char_idx == 0) begin
                            cs <= S_DONE;
                        end else begin
                            cs <= S_NEXT_CHAR;
                        end
                    end else begin
                        cs <= S_READ_ROW;
                    end
                end
            end
            S_DONE:
             if (!enable)
                cs <= S_INIT;
        endcase
    end
end

////////////////////////////////// Row/Col/Char Counting //////////////////////////////////
assign col_done = (cs == S_DRAW_ROW) && (col_idx == (char_width - 1));
assign row_done = (cs == S_DRAW_ROW) && (row_idx == (CHAR_ROWS - 1));
assign char_done = col_done && row_done;

assign char_select = string_in[char_idx * 8 +: 8];
assign char_is_null = (char_select == 0);

always_ff @(posedge clk) begin
    if (cs == S_NEXT_CHAR)
        curr_char <= char_select;
end

// char_idx
always_ff @(posedge clk) begin
    if (cs == S_INIT)
        char_idx <= MAX_CHARS - 1;
    else if (char_done)
        char_idx <= char_idx - 1;
    else if (cs == S_NEXT_CHAR && char_is_null)
        char_idx <= char_idx - 1;
end

// col_idx
always_ff @(posedge clk) begin
    if (cs == S_READ_ROW)
        col_idx <= 0;
    else if (cs == S_DRAW_ROW)
        col_idx <= col_idx + 1;
end

// row_idx
always_ff @(posedge clk) begin
    if (cs == S_NEXT_CHAR)
        row_idx <= 0;
    if (col_done)
        row_idx <= row_idx + 1;
end

// x,y
always_ff @(posedge clk) begin
    if (cs == S_INIT) begin
        x <= x_in;
        y <= y_in;
    end else if (char_done) begin
        x <= x + char_width + 1;
    end
end

// Shift register of current row of pixels being drawn
always_ff @(posedge clk) begin
    if (cs == S_INIT)
        pixel_row <= 0;
    if (cs == S_SAVE_ROW)
        pixel_row <= pixel_rom_out;
    else if (cs == S_DRAW_ROW)
        pixel_row <= {pixel_row[CHAR_COLS - 2:0], 1'b0};
end

////////////////////////////////// Character ROM Lookups //////////////////////////////////
always_comb begin
    if (curr_char >= "A" && curr_char <= "Z") begin
        pixel_rom_addr = {curr_char - "A", row_idx};
        width_rom_addr = {curr_char - "A"};
    end else if (curr_char >= "0" && curr_char <= "9") begin
        pixel_rom_addr = {curr_char - "0" + 26, row_idx};
        width_rom_addr = {curr_char - "0" + 26};
    end else if (curr_char == " ") begin
        pixel_rom_addr = {8'd36, row_idx};
        width_rom_addr = 8'd36;
    end else begin
        pixel_rom_addr = {8'd37, row_idx};
        width_rom_addr = 8'd37;
    end
end

always_ff @(posedge clk) begin
    if (cs == S_SAVE_ROW)
        char_width <= width_rom_out;
end

always_ff @(posedge clk) begin
     case(pixel_rom_addr)
        {"A" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"A" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"A" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"A" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"A" - "A", 3'd4}: pixel_rom_out = 5'b10100;

        {"B" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"B" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"B" - "A", 3'd2}: pixel_rom_out = 5'b11110;
        {"B" - "A", 3'd3}: pixel_rom_out = 5'b10010;
        {"B" - "A", 3'd4}: pixel_rom_out = 5'b11110;

        {"C" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"C" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"C" - "A", 3'd2}: pixel_rom_out = 5'b10000;
        {"C" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"C" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"D" - "A", 3'd0}: pixel_rom_out = 5'b11000;
        {"D" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"D" - "A", 3'd2}: pixel_rom_out = 5'b10100;
        {"D" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"D" - "A", 3'd4}: pixel_rom_out = 5'b11000;

        {"E" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"E" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"E" - "A", 3'd2}: pixel_rom_out = 5'b11000;
        {"E" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"E" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"F" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"F" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"F" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"F" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"F" - "A", 3'd4}: pixel_rom_out = 5'b10000;

        {"G" - "A", 3'd0}: pixel_rom_out = 5'b11110;
        {"G" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"G" - "A", 3'd2}: pixel_rom_out = 5'b10110;
        {"G" - "A", 3'd3}: pixel_rom_out = 5'b10010;
        {"G" - "A", 3'd4}: pixel_rom_out = 5'b11110;

        {"H" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"H" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"H" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"H" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"H" - "A", 3'd4}: pixel_rom_out = 5'b10100;

        {"I" - "A", 3'd0}: pixel_rom_out = 5'b10000;
        {"I" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"I" - "A", 3'd2}: pixel_rom_out = 5'b10000;
        {"I" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"I" - "A", 3'd4}: pixel_rom_out = 5'b10000;

        {"J" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"J" - "A", 3'd1}: pixel_rom_out = 5'b00100;
        {"J" - "A", 3'd2}: pixel_rom_out = 5'b00100;
        {"J" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"J" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"K" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"K" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"K" - "A", 3'd2}: pixel_rom_out = 5'b11000;
        {"K" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"K" - "A", 3'd4}: pixel_rom_out = 5'b10100;

        {"L" - "A", 3'd0}: pixel_rom_out = 5'b10000;
        {"L" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"L" - "A", 3'd2}: pixel_rom_out = 5'b10000;
        {"L" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"L" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"M" - "A", 3'd0}: pixel_rom_out = 5'b10001;
        {"M" - "A", 3'd1}: pixel_rom_out = 5'b11011;
        {"M" - "A", 3'd2}: pixel_rom_out = 5'b10101;
        {"M" - "A", 3'd3}: pixel_rom_out = 5'b10001;
        {"M" - "A", 3'd4}: pixel_rom_out = 5'b10001;

        {"N" - "A", 3'd0}: pixel_rom_out = 5'b10010;
        {"N" - "A", 3'd1}: pixel_rom_out = 5'b11010;
        {"N" - "A", 3'd2}: pixel_rom_out = 5'b10110;
        {"N" - "A", 3'd3}: pixel_rom_out = 5'b10010;
        {"N" - "A", 3'd4}: pixel_rom_out = 5'b10010;

        {"O" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"O" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"O" - "A", 3'd2}: pixel_rom_out = 5'b10100;
        {"O" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"O" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"P" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"P" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"P" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"P" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"P" - "A", 3'd4}: pixel_rom_out = 5'b10000;

        {"Q" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"Q" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"Q" - "A", 3'd2}: pixel_rom_out = 5'b10100;
        {"Q" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"Q" - "A", 3'd4}: pixel_rom_out = 5'b11110;

        {"R" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"R" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"R" - "A", 3'd2}: pixel_rom_out = 5'b11000;
        {"R" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"R" - "A", 3'd4}: pixel_rom_out = 5'b10100;

        {"S" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"S" - "A", 3'd1}: pixel_rom_out = 5'b10000;
        {"S" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"S" - "A", 3'd3}: pixel_rom_out = 5'b00100;
        {"S" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"T" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"T" - "A", 3'd1}: pixel_rom_out = 5'b01000;
        {"T" - "A", 3'd2}: pixel_rom_out = 5'b01000;
        {"T" - "A", 3'd3}: pixel_rom_out = 5'b01000;
        {"T" - "A", 3'd4}: pixel_rom_out = 5'b01000;

        {"U" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"U" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"U" - "A", 3'd2}: pixel_rom_out = 5'b10100;
        {"U" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"U" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"V" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"V" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"V" - "A", 3'd2}: pixel_rom_out = 5'b10100;
        {"V" - "A", 3'd3}: pixel_rom_out = 5'b11100;
        {"V" - "A", 3'd4}: pixel_rom_out = 5'b01000;

        {"W" - "A", 3'd0}: pixel_rom_out = 5'b10001;
        {"W" - "A", 3'd1}: pixel_rom_out = 5'b10001;
        {"W" - "A", 3'd2}: pixel_rom_out = 5'b10101;
        {"W" - "A", 3'd3}: pixel_rom_out = 5'b11011;
        {"W" - "A", 3'd4}: pixel_rom_out = 5'b10001;

        {"X" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"X" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"X" - "A", 3'd2}: pixel_rom_out = 5'b01000;
        {"X" - "A", 3'd3}: pixel_rom_out = 5'b10100;
        {"X" - "A", 3'd4}: pixel_rom_out = 5'b10100;

        {"Y" - "A", 3'd0}: pixel_rom_out = 5'b10100;
        {"Y" - "A", 3'd1}: pixel_rom_out = 5'b10100;
        {"Y" - "A", 3'd2}: pixel_rom_out = 5'b11100;
        {"Y" - "A", 3'd3}: pixel_rom_out = 5'b01000;
        {"Y" - "A", 3'd4}: pixel_rom_out = 5'b01000;

        {"Z" - "A", 3'd0}: pixel_rom_out = 5'b11100;
        {"Z" - "A", 3'd1}: pixel_rom_out = 5'b00100;
        {"Z" - "A", 3'd2}: pixel_rom_out = 5'b01000;
        {"Z" - "A", 3'd3}: pixel_rom_out = 5'b10000;
        {"Z" - "A", 3'd4}: pixel_rom_out = 5'b11100;

        {"0" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"0" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10100;
        {"0" - "0" + 26, 3'd2}: pixel_rom_out = 5'b10100;
        {"0" - "0" + 26, 3'd3}: pixel_rom_out = 5'b10100;
        {"0" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"1" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11000;
        {"1" - "0" + 26, 3'd1}: pixel_rom_out = 5'b01000;
        {"1" - "0" + 26, 3'd2}: pixel_rom_out = 5'b01000;
        {"1" - "0" + 26, 3'd3}: pixel_rom_out = 5'b01000;
        {"1" - "0" + 26, 3'd4}: pixel_rom_out = 5'b01000;

        {"2" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"2" - "0" + 26, 3'd1}: pixel_rom_out = 5'b00100;
        {"2" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"2" - "0" + 26, 3'd3}: pixel_rom_out = 5'b10000;
        {"2" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"3" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"3" - "0" + 26, 3'd1}: pixel_rom_out = 5'b00100;
        {"3" - "0" + 26, 3'd2}: pixel_rom_out = 5'b01100;
        {"3" - "0" + 26, 3'd3}: pixel_rom_out = 5'b00100;
        {"3" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"4" - "0" + 26, 3'd0}: pixel_rom_out = 5'b10100;
        {"4" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10100;
        {"4" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"4" - "0" + 26, 3'd3}: pixel_rom_out = 5'b00100;
        {"4" - "0" + 26, 3'd4}: pixel_rom_out = 5'b00100;

        {"5" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"5" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10000;
        {"5" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"5" - "0" + 26, 3'd3}: pixel_rom_out = 5'b00100;
        {"5" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"6" - "0" + 26, 3'd0}: pixel_rom_out = 5'b10000;
        {"6" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10000;
        {"6" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"6" - "0" + 26, 3'd3}: pixel_rom_out = 5'b10100;
        {"6" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"7" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"7" - "0" + 26, 3'd1}: pixel_rom_out = 5'b00100;
        {"7" - "0" + 26, 3'd2}: pixel_rom_out = 5'b00100;
        {"7" - "0" + 26, 3'd3}: pixel_rom_out = 5'b00100;
        {"7" - "0" + 26, 3'd4}: pixel_rom_out = 5'b00100;

        {"8" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"8" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10100;
        {"8" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"8" - "0" + 26, 3'd3}: pixel_rom_out = 5'b10100;
        {"8" - "0" + 26, 3'd4}: pixel_rom_out = 5'b11100;

        {"9" - "0" + 26, 3'd0}: pixel_rom_out = 5'b11100;
        {"9" - "0" + 26, 3'd1}: pixel_rom_out = 5'b10100;
        {"9" - "0" + 26, 3'd2}: pixel_rom_out = 5'b11100;
        {"9" - "0" + 26, 3'd3}: pixel_rom_out = 5'b00100;
        {"9" - "0" + 26, 3'd4}: pixel_rom_out = 5'b00100;

        {8'd36, 3'd0}: pixel_rom_out = 5'b00000;
        {8'd36, 3'd1}: pixel_rom_out = 5'b00000;
        {8'd36, 3'd2}: pixel_rom_out = 5'b00000;
        {8'd36, 3'd3}: pixel_rom_out = 5'b00000;
        {8'd36, 3'd4}: pixel_rom_out = 5'b00000;

        {8'd37, 3'd0}: pixel_rom_out = 5'b11110;
        {8'd37, 3'd1}: pixel_rom_out = 5'b11110;
        {8'd37, 3'd2}: pixel_rom_out = 5'b11110;
        {8'd37, 3'd3}: pixel_rom_out = 5'b11110;
        {8'd37, 3'd4}: pixel_rom_out = 5'b11110;
    endcase
end

always_ff @(posedge clk) begin
    case(width_rom_addr)
        // A-Z
        {"A" - "A"}: width_rom_out = 3;
        {"B" - "A"}: width_rom_out = 4;
        {"C" - "A"}: width_rom_out = 3;
        {"D" - "A"}: width_rom_out = 3;
        {"E" - "A"}: width_rom_out = 3;
        {"F" - "A"}: width_rom_out = 3;
        {"G" - "A"}: width_rom_out = 4;
        {"H" - "A"}: width_rom_out = 3;
        {"I" - "A"}: width_rom_out = 1;
        {"J" - "A"}: width_rom_out = 3;
        {"K" - "A"}: width_rom_out = 3;
        {"L" - "A"}: width_rom_out = 3;
        {"M" - "A"}: width_rom_out = 5;
        {"N" - "A"}: width_rom_out = 4;
        {"O" - "A"}: width_rom_out = 3;
        {"P" - "A"}: width_rom_out = 3;
        {"Q" - "A"}: width_rom_out = 4;
        {"R" - "A"}: width_rom_out = 3;
        {"S" - "A"}: width_rom_out = 3;
        {"T" - "A"}: width_rom_out = 3;
        {"U" - "A"}: width_rom_out = 3;
        {"V" - "A"}: width_rom_out = 3;
        {"W" - "A"}: width_rom_out = 5;
        {"X" - "A"}: width_rom_out = 3;
        {"Y" - "A"}: width_rom_out = 3;
        {"Z" - "A"}: width_rom_out = 3;

        // 0-9
        {"0" - "0" + 26}: width_rom_out = 3;
        {"1" - "0" + 26}: width_rom_out = 2;
        {"2" - "0" + 26}: width_rom_out = 3;
        {"3" - "0" + 26}: width_rom_out = 3;
        {"4" - "0" + 26}: width_rom_out = 3;
        {"5" - "0" + 26}: width_rom_out = 3;
        {"6" - "0" + 26}: width_rom_out = 3;
        {"7" - "0" + 26}: width_rom_out = 3;
        {"8" - "0" + 26}: width_rom_out = 3;
        {"9" - "0" + 26}: width_rom_out = 3;

        // Space
        36: width_rom_out = 4;

        // non-supported, non-null
        37: width_rom_out = 4;
    endcase
end

endmodule
