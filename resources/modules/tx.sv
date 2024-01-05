/***************************************************************************
*
* Module: tx
*
* Author: Instructor
* Class: ECEN 220, Section 1, Spring 2021
* Date: June 1, 2021
*
* Description: UART transmitter.
*
*
****************************************************************************/
`timescale 1ns / 1ps
`default_nettype none

module tx (
	input wire logic clk,   // System clock
	input wire logic Reset, // Active-high reset
	input wire logic Send,  // Request transmission
	input wire logic[7:0] Din, // Data to send
	output logic Sent, // Acknowledge transmission is done
	output logic Sout  // Transmitter serial output
);

// Define states
typedef enum logic[2:0] {IDLE, START, BITS, PAR, STOP, ACK} StateType;
StateType ns, cs;

localparam TIMER_MAX = 5208; // 52.083 us bit time for 19200 baud
logic clrTimer, timerDone; // Bit timer
logic[12:0] timer;

localparam DATA_BITS = 8;
logic clrBit, incBit, bitDone; // Bit counter
logic[2:0] bitNum;

logic startBit, dataBit, parityBit; // Control signals into datapath

// Bit timer
assign timerDone = (timer == TIMER_MAX-1) ? 1'b1 : 1'b0;

always_ff @(posedge clk)
	if (Reset || clrTimer || timerDone)
		timer <= 0;
	else
		timer <= timer+1;

// Bit counter
assign bitDone = (bitNum == DATA_BITS-1) ? 1'b1 : 1'b0;

always_ff @(posedge clk)
	if (Reset || clrBit)
		bitNum <= 0;
	else if (incBit)
		bitNum <= bitNum+1;

// The IFL and OFL is in one always_comb block
always_comb
begin
	// Assign default values to the next state and output signals
	ns = cs;
	clrTimer = 1'b0;
	incBit = 1'b0;
	clrBit = 1'b0;
	startBit = 1'b0;
	dataBit = 1'b0;
	parityBit = 1'b0;
	Sent = 1'b0;

	// IFL/OFL
	if (Reset)
		ns = IDLE;
	else
		case (cs)
		IDLE: begin
			if (Send) ns = START;
			clrTimer = 1'b1;
		end
		START: begin
			if (timerDone) begin
				ns = BITS;
				clrBit = 1'b1;
			end
			startBit = 1'b1;
		end
		BITS: begin
			if (timerDone)
				if (bitDone) ns = PAR;
				else incBit = 1'b1;
			dataBit = 1'b1;
		end
		PAR: begin
			if (timerDone) ns = STOP;
			parityBit = 1'b1;
		end
		STOP: begin
			if (timerDone) ns = ACK;
			// stop bit sent by default
		end
		ACK: begin
			if (~Send) ns = IDLE;
			Sent = 1'b1;
		end
		endcase
end

// State register
always_ff @(posedge clk)
	cs <= ns;

// Datapath
always_ff @(posedge clk)
	if (startBit)
		Sout <= 0;
	else if (dataBit)
		Sout <= Din[bitNum];
	else if (parityBit)
		Sout <= ~^Din; // Odd parity calculation
	else
		Sout <= 1;

endmodule
