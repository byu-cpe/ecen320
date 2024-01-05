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
