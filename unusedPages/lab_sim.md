---
layout: page
toc: true
title: FF Simulation
lab: Sim
---

**Originally written by Prof Brent Nelson**

In this lab you will do some experimentation with simulation of latches and flip-flops to learn how they operate. NOTE: you will not generate any bitstreams and you will not download anything to your FPGA board. This is strictly a simulation lab.

# Learning Outcomes
* Learn how to dig deeper into a simulation to find bugs in your designs (Part 1).
* Learn about the timing of latches and flip-flops (Part 2).

# Preliminary

## Part 1 - Simulation
One of the truisms of digital systems design is that the later in the design/deployment cycle you find bugs in your design, the more difficult and expensive it is to find and fix those bugs. Applying that to what we are doing in the lab, you could say it this way: if it takes `x` amount of effort to find a bug during simulation it will take `10-100x` the effort to find it once you have programmed your FPGA with the bitstream and started testing.

Why?
* Well, in simulation you have full visibility of every signal in your design and can see what it is doing at every point in time during the simulation.
* In contrast, once you start testing your design in hardware you can only:
  * See signals that come out to top-level pins (like LEDs).
  * The signals change so quickly you have no hope of understanding really what they are doing.

Thus, simulation is an indispensable tool for finding bugs in your design in the shortest possible time frame. Sadly, some students view simulation as a distraction and impediment to getting their lab finished. This is sad because, actually, simulation can save you hours and hours of debug time on your labs.

Simulators, such as the Vivado simulator, contain many different features to make it easy for you to debug your design. You will investigate and learn how to use some of these in this lab.

## Part 2 - Timing Simulation of Latches and Flip-Flops
With the move to the study of latches and flip-flops in class, the way you need to look at how circuits behave has changed. That is, for combinational (gate level) circuits you were mostly concerned with ***static*** analysis - the question was always ***what is the output of a function given a certain combination of inputs***?

With latches and flip-flops we now add timing to the mix, making your analysis a ***dynamic*** analysis. That is, you need to be concerned with the output of the circuit as a function of time. And, in the case of latches and flip-flops, there are ***feedback*** paths in the logic which makes tracing their behavior more complicated than for simple combinational circuits where the signals flow strictly from inputs to output.

When we simulate, we normally do what we call ***0-delay*** simulations of our SystemVerilog code. That means, that all gate delays have a delay of 0ns and so you won't see the effect of actual gate delays in your simulation waveforms. The reason for this is twofold.
* First, what we really care about is the high-level behavior of our circuit -- what do the outputs do as a function of the inputs and the clock signal?
* Second, even if we specified a delay for each gate, the fabricated circuit would not necesssarily reflect those delays. Why?
  * You may specify that an AND gate has a 2ns delay in your SystemVerilog code but the synthesizer will ignore that and just make the fastest AND gate it can. This is all part of our ***design methodology*** -- by following a ***globally synchronous*** design methodology we eliminate the need to carefully verify every gate delay. Rather, we care only about the ***slowest paths*** in our design since that will limit the performance of our circuit.

That said, in order to help you visualize the behavior of latches and flip-flops, in this lab you will be simulating circuits that ***do*** have delays attached. But, the purpose of these delays is simply to help you visualize and better understand how those circuits work in a ***dynamic*** sense.

# Exercises

## Exercise #1 - Interactive Simulation Technique
On [this page]({% link resources/tool_resources/simulation_hints.md %}), there is an entry called "Interactive Simulation". Read it. It explains that you need not always simulate 30,000ns every time you restart. Rather, it suggests you may simulate a bit, and then if things aren't looking good (maybe the circuit didn't reset the way you want), you can interactively type additional commands into the Tcl Console to control the simulation.

In this exercise you are to simulate a simple design. But, you are to do it 100% by typing [Tcl commands]({% link tutorials/lab_03/04_tcl_tutorial.md %}) into the Tcl Console (you will not use a Tcl file). There are only 4 combinations of inputs and so it won't be much typing.

Here is the circuit:
```verilog
module MyAnd (input wire logic a, b, output logic q);
  assign q = a & b;
endmodule
```
Create a design that includes this circuit and then simulate it by typing the needed commands into the Tcl console.

<span style="color:red">
Explain how you might use interactive typing in combination with a Tcl file in a real simulation and debugging activity.
</span>

<span style="color:green">
Attach a screen shot of an interactive simulation that shows: (1) the waveform viewer window zoomed so the 4 input combinations are visible as well as the corresponding output values, and (2) the Tcl console window with the commands you typed to simulate the circuit.
</span>

## Exercise #2 - Seeing Internal Signals During Simulation
On [this page]({% link resources/tool_resources/simulation_hints.md %}), there is another entry called "Visibility is EVERYTHING!!!". Read it.

It explains how you can go into your design hierarchy (scope) and pull out signals internal to sub-modules and view them on the waveform viewer.

For this exercise:

1. Re-open your previous lab's Seven-Segment Lab project in Vivado. That design has a top-level module which instances your seven-segment decoder design inside it.
2. Using the techniques in the web page above, go into your design hierarchy and find the 'c' and 'f' segment signals and add them to your waveform viewer.
3. Then, re-start the simulation to verify that their values are now being shown in the waveform viewer.
4. Be sure to put a divider between the top level signals and the section of new signals you have added to the waveform viewer. Name the divider (call it "my7segments").
5. Now, save the waveform to a file (the default name Vivado suggests will be fine).
6. Then, exit Vivado, open the project again, and then start up a simulation to verify that your "modified waveform" window still has those signals in it.

That's it -- you can now create a customized waveform view for your design and you can save it for later simulation runs.

Each time you re-start a simulation it will use this new waveform view instead of the detault one. And, if you ever want to get rid of the modified waveform configuration file and go back to the default one, you just delete it out of simulation sources.

<span style="color:green">
Attach a screenshot showing your modified waveform view with these new signals. Be sure the screenshot also clearly shows that the waveform configuration file has been saved in your project under "Simulation Sources".
</span>

## Exercise #3 - Timing Simulation of a Latch
The textbook details the behavior of an SR latch consisting of 2 NOR gates in a fair amount of detail. For this exercise you are going to code up such a latch using SystemVerilog and simulate it. But, the code you write will be unique in that you will actually model gate delays (which we don't normally do).

First, complete the timing diagram of Problem 15.1 from the Exercises Section of the book. Do this on paper (you will be submitting it). Problem 15.1 asks you to use *approximate timing* to show the waveforms. Read the book (Section 15.5) to understand what that means if you haven't yet done so.

This will require that you figure out, for a given input transition, which output changes first and which one changes second. Work through a few input transitions until you understand the sequence, and then draw your answer.

Now go back to your hand-drawn diagram, and label the various signal transitions with actual time values, under the assumption that a NOR gate delay is 2ns and each division in the timing diagram is 10ns.

<span style="color:green">
Turn in a photo of your hand-drawn timing diagram from Problem 15.1.
</span>

Next, you are going to simulate the latch. First, you already know the syntax of a signal assignment statement in SystemVerilog:
```verilog
assign f = a & b;
```

You can add a delay to the gate it represents simply in this way:
```verilog
assign #3ns f = a & b;
```

Using this syntax, create a SystemVerilog design for the latch circuit (Figure 15.1) you analyzed previously on paper.

Normally in the port list for modules you would do something like this:
```verilog
module Latch (input wire logic r,
             input wire logic s,
             output logic q,    // Our coding standard says to not put 'wire' on outputs
             output logic qbar  // Our coding standard says to not put 'wire' on outputs
          );
```

However, for your latch circuit you must do it this way (due to simulation issues):
```verilog
module Latch (input wire logic r,
             input wire logic s,
             output wire logic q,    // This output must have the 'wire' specifier
             output wire logic qbar  // This output must have the 'wire' specifier
          );
```

<span style="color:red">
Paste your SR latch module source code.
</span>

Now, write a Tcl file and do a simulation of this circuit (just the way it happens in the timing diagram of Problem 15.1). The only difference is that the circuit will initialize with X's on both Q and QBAR and you will need to first reset it to get it to do anything. Below is the Tcl file to initialize the latch. Add stimulus commands to complete the simulation script. The rest of your simulation (starting at 10ns) should follow what is in Problem 15.1 exactly. Again, assume that a NOR gate delay is 2ns and each division in the timing diagram is 10ns.
```tcl
restart

# Initialize the latch with a reset pulse
add_force s 0
add_force r 1
run 6ns
add_force r 0
run 4ns

# Starting here, add stimulus to match the diagram in Problem 15.1
```

<span style="color:red">
Explain how your SR latch simulation matches or does not match the waveform you drew for Problem 15.1. Does the simulation match your understanding? What is the transition ordering of the output signals in response to an input change? Did you draw the waveform correctly by hand? If not, how did you do it wrong?
</span>

<span style="color:green">
Attach a screenshot of the SR latch simulation. Be sure the actual transition times for the outputs are clearly visible. You will probably need to zoom in on the portion of the waveform time scale that shows where the latch signals are changing.
</span>

Once you really understand how a latch works, then the operation of the master/slave flip-flop of Chapter 15 is much more understandable. That is the topic of the next exercise.

## Exercise #4 - Timing Simulation of a Master/Slave Flip-Flop
Create a gate level design of a master/slave flip-flop in Figure 15.17 from the book. Use one dataflow `assign` statement per gate in the diagram, each with the proper delay. For gate delays, use NOT = 1ns, AND = 3ns, NOR = 2ns. Note that on the master latch, the signals Q1 and Q1BAR are in the opposite spots as compared to the slave latch (see Figure 15.17 and Figure 15.7). Not noticing this is a common error.

Now, create a timing simulation of that flip-flop. The .tcl file to use is here:
```tcl
restart
add_force clk 0
add_force d 0
run 20ns

# First propagation to Q and QBAR
add_force clk 1
run 20ns

# Raise d
add_force d 1
run 10ns

# Load master latch
add_force clk 0
run 20ns

# Transfer master value to slave latch
add_force clk 1
run 20ns

# Lower d
add_force d 0
run 20ns

# Load master latch
add_force clk 0
run 20ns

# Transfer master value to slave latch
add_force clk 1
run 20ns

# # # # # # Second set of stimulus
# First propagation to Q and QBAR
add_force clk 1
run 20ns

# Drop clock
add_force clk 0
run 10ns

# Raise d and load master latch
add_force d 1
run 20ns

# Transfer master value to slave latch
add_force clk 1
run 20ns

# Drop clock
add_force clk 0
run 10ns

# Lower d and load master latch
add_force d 0
run 20ns

# Transfer master value to slave latch
add_force clk 1
run 20ns
```

<span style="color:red">
Paste your master/slave flip-flop module source code.
</span>

Answer the following questions while considering only the waveform from time 0 to 160ns:

1. <span style="color:red">From the flip-flop simulation, what do you deduce the tCLK-Q time to be?</span>
2. <span style="color:red">Do you get the same delay for when Q rises vs. when Q falls? You should not. Explain why this is.</span>
3. <span style="color:red">So, if there are different values, which one would you use and why?</span>
4. <span style="color:red">How does this compare to the tCLK-Q you would calculate from the book and its analysis? Are they the same? If not, does your simulation have a bug? Explain any discrepancies.</span>

In case you didn't notice, the above set of questions are asking you to think through really what is going on in the flip-flop. You cannot simply memorize some formulae about the flip-flop -- you need to be able to analyze it and trace through what it is doing. When correcting your answsers to the above questions, the TA's will be looking for evidence that you really understand how the gates are working and how (and when) the signals transition. If your answer shows that you understand that, you will get full points. If your answer looks like you were just guessing, you won't.

In the last half of the simulation waveform, focus on the time when CLK=0 and the master latch is open. Look at how long it takes for a change in D to settle on the master latch outputs (Q1, Q1BAR). Assume that this time is tSETUP (a good first approximation and the one used in the book). Also, compute tSETUP manually based on the critical path and gate delays.

Answer the following questions while considering only the waveform from 160ns to the end:

<span style="color:red">
1. <span style="color:red">From the flip-flop simulation, what would you deduce the tSETUP time to be?</span>
2. <span style="color:red">Is the deduced tSETUP from simulation different from a manually computed time? If so, explain why.</span>
3. <span style="color:red">Is the tSETUP time you see in this simulation different for when D rises vs. when D falls? It should be.</span>
4. <span style="color:red">Thus, what would be the proper value to use as a general tSETUP for this flip-flop so you can design with it and create working circuits? Why?</span>

<span style="color:green">
Attach a screenshot of the master/slave flip-flop simulation.
</span>

# Final Questions
<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

# A Final Note
Although these simulations are helpful for you to visualize the dynamic behavior of latches and flip-flops, we don't actually code them this way. Rather, as you will learn in upcoming class periods, we write our SystemVerilog code in a way that the synthesis tool will see that we want a flip-flop and will insert a circuit optimized for that function into our design. The optimized flip-flop it inserts is functionally equivalent to what we have learned about to a first order approximation, but is not made of NOR and AND gates. Rather is a custom transistor-level circuit that is much smaller and faster than the ones we have learned about. But, the function is the same and you use them the same way in your designs.
