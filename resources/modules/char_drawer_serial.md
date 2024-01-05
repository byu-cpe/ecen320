---
layout: page
toc: false
title: The CharDrawer_serial Module
lab: CharDrawer_serial
---

This module is used to draw strings of characters to the serial output port, one character at a time. The module accepts only upper-case characters (A-Z), digits (0-9) and space (" "). A null character (0) will not be drawn, and all other ASCII values are drawn as a solid rectangle.

There are several different ways to construct strings in SystemVerilog. For example, the following are all equivalent:

```verilog
logic [39:0] char_string;
assign char_string = "HELLO";
```

```verilog
logic [39:0] char_string;
assign char_string = 40'h48454C4C4F;
```

```verilog
logic [39:0] char_string;
assign char_string = {"H", "E", "L", "L", "O"};
```

```verilog
logic [39:0] char_string;
assign char_string = {8'h48, 8'h45, 8'h4C, 8'h4C, 8'h4F};
```

| Module Name = CharDrawer_serial ||||
| Parameter | Default Value | Description ||
|---|
| MAX_CHARS | 16 | The length of the string that the module can display. ||

| Port Name | Direction | Width | Description |
|---|
| clk | Input | 1 | 100 MHz Clock. |
| reset | Input | 1 | Active-high reset. |
| enable| Input | 1 | Raise this signal to start drawing. The drawing will continue until finished. To draw a new string you must lower and then raise this signal. |
| done | Output | 1 | Active-high, indicating that the string is done drawing. |
| tx | Output | 1 | The serial out signal. |
| string_in | Input | MAX_CHARS \* 8 | ASCII character string to draw, most-significant byte is drawn first. |

Click the link below to download the CharDrawer_serial.sv file.

[CharDrawer_serial.sv]({% link resources/modules/CharDrawer_serial.sv %})

```verilog
`default_nettype none

module CharDrawer_serial #(
    parameter MAX_CHARS = 16
    ) (
    input wire logic                         clk,        // Clock
    input wire logic                         reset,      // Active-high reset
    input wire logic                         enable,     // Start drawing
    output logic                             done,       // Done drawing
    output logic                             tx,         // Serial out
    input wire logic [(MAX_CHARS * 8) - 1:0] string_in   // ASCII character string to draw
                                                         // MSB is drawn first
    );

    logic setCnt, decCnt, send, sent;
    logic[$clog2(MAX_CHARS)-1:0] cnt;
    logic[7:0] din;

    // State Machine
    typedef enum logic[1:0] {ST_IDLE, ST_REQ, ST_ACK, ST_DONE} StateType;
    StateType cs, ns;

    assign din = string_in[cnt * 8 +: 8];

    ////////////////////// Counter ////////////////////
    always_ff @(posedge clk)
        if (setCnt)
            cnt <= MAX_CHARS-1;
        else if (decCnt)
            cnt <= cnt - 1;

    ////////////////////////////////// State Machine //////////////////////////////////
    always_ff @(posedge clk)
        cs <= ns;

    always_comb begin
        ns = cs;
        send = 0;
        setCnt = 0;
        decCnt = 0;
        done = 0;
        if (reset)
            ns = ST_IDLE;
        else case (cs)
            ST_IDLE: begin
                if (enable) ns = ST_REQ;
                setCnt = 1;
            end
            ST_REQ: begin
                if (sent) ns = ST_ACK;
                send = 1;
            end
            ST_ACK: begin
                if (~sent) begin
                    if (cnt == 0)
                        ns = ST_DONE;
                    else begin
                        ns = ST_REQ;
                        decCnt = 1;
                    end
                end
            end
            ST_DONE: begin
                if (~enable) ns = ST_IDLE;
                done = 1;
            end
            endcase
    end

    // The UART Tx
    tx TX(.clk(clk), .Reset(reset), .Send(send), .Din(din), .Sent(sent), .Sout(tx));

endmodule
```
