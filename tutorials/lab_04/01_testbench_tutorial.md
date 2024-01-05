---
layout: page
toc: false
title: Adding a Testbench and Simulating with a Testbench
lab: 4
---

<iframe width="768" height="432" src="https://www.youtube.com/embed/WNq20wcnpqA?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# Notes On Above Video:
The video says to 'run 1us'. If that is long enough for the testbench to complete, you will get the completion message printed to the Tcl console. However, the testbench may take longer than that to run.

The way to ask it to run to completion would be to type 'run -all'. It should then run to completion, however long that takes. When done, it will print the time it terminates in the final message.

The flip side of the coin, however, is that later in the semester you will have testbenches that run for 5-15 minutes. For those, a smart thing to do is to run initially for only a few hundreds or thousands of nanoseconds and see if you are getting errors in the console and if the waveforms are free from 'X' values. Only then, should you do a 'run -all'. Otherwise, you will have waited for 5-15 minutes for nothing and wasted your time...

And, remember, as the simulation is running if it encounters an error it will immediately print that error to the console. So, watch the console for error messages -- as soon as they start to appear, just kill the simulation and then debug what is going wrong.

<!--
/*
* Goal of tutorial:
* Review what happens when you added design projects. they show up in the "Design sources" folder of your project.
  * In addition to the design sources folder, they also appear in the "simulation sources" folder. They are here because in addition to synthesizing these files, you will be simulating these files.
  * Note that the seven_segment_top file is bold indicating that when you simulate, you will simulate this file and the other file will simulate as a sub-module
  * You can change which file is set as "top". (show this).
* In addition to design sources, you can add simulation sources or testbenches. A testbench file is a Verilog file that provides a stimuls to your synthesizable Verilog file but it is not synthesizable itself. To add a file that you simulate but do not synthesize, you add it as a "simulation source". Show them how to do this.
  * See the color of the file. Make sure the testbench is black (set as top)
* Make sure the hierarhcy is correct simulation sources section
  * Problems that can happen (mismatch hierarchy)
  * Note that the file shows up in simulation sources but not in design sources
* Simulating different levels of hierarchy
* Go through the process of simulation
  * Start it the same way
  * Not forcing the signals - it will do the forcing.
  * Just execute a "run" (run 1 us)
  * Notice hierarchy
  * Notice the console (printing messages)
  * Will indicate errors (show them)
  * Wait for "done" message
  * Show them how to find a time in he simulation
*/

/*
===== Adding an Testbench file with a Tcl command =====

You can add your testbench file to your project with the following Tcl command:
<code>
add_files -fileset sim_1 -norecurse C:/wirthlin/ee220/git/labs/SevenSegment/testbench/tb_SevenSegment.v
</code>
*/
-->
