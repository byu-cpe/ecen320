---
layout: page
toc: true
title: Starting the Vivado HDL Simulation Tool
lab: 3
---

The Vivado design suite has a professional logic simulation tool that you can use to simulate the behavior of your SystemVerilog HDL files. HDL Simulation tools like this are used by professional engineers to simulate very complex and large digital design files. Your ability to use simulation tools effectively is key to successfully designing digital circuits. This tutorial will guide you through how to setup and start the Vivado simulation tool. Other tutorials are available that describe how to run your simulation once it is properly setup.

## Set "Top" Module
The Vivado simulator is able to simulate any of the SystemVerilog files that are part of your project. Before simulating, you need to identify the SystemVerilog module you want to simulate. The module that is simulated is called the "top" module. You can set the "top" module under **Simulation Sources** as follows:
1. In the **Project Manager**, in the **Sources** pane, expand the **Simulation Sources** folder and the folder inside of that.
2. Right click on the source you want to set as top module, then click **Set as Top**. If your file is already set as the top it will have a small hierarchy picture next to the filename and the **Set as Top** option will not be available.

## Remove default simulation run time
By default, the simulator will simulate 1000 ns of time when the simulation is first run. This is not helpful as the inputs to the simulation are not yet set. It is best to remove this default simulation run time before starting the simulation (you only need to do this once - this will be saved in your project settings). Follow these steps to remove the default simulation run time:
1. Right-Click the **SIMULATION** link in Flow Navigator and click **Simulation Settings...**.
2. Click the **Simulation** Tab in the middle of the window that pops up.
3. Click the small **x** to the right of **Simulation Run Time**. This should remove the **1000ns** if it is there, which it is by default.
   <img src="{% link media/tutorials/lab_03/03_starting_vivado_simulation_tool/00_simulation_settings.png %}" width="750">
4. Click **OK**.

## Run Simulation
At this point you can start the simulation tool:
1. Click **Run Simulation**
2. Click **Run Behavioral Simulation**.

The simulator will perform an "elaboration" step on your SystemVerilog code before starting the simulation. During elaboration, the simulator may find errors in your SystemVerilog code that were not found by the syntax checker. If you have errors, resolve them and re-run the simulation.

<!--
Add an example of an error message here on elaboration messages. Need to help them know where to look for the error message when they occur here.
-->

A video example of performing these steps is shown below:

<iframe width="768" height="432" src="https://www.youtube.com/embed/WR-NKXluhxk?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Simulation GUI Overview
The following video provides a summary of running the Vivado simulation. Watch this video as you complete your simulation.

<iframe width="768" height="432" src="https://www.youtube.com/embed/h_jLFwNelIw?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## BEWARE OF THE SIMULATOR DEMONS !!!
Our experience has been that the simulator sometimes gets in a funny state, meaning that you may think you have changed and then re-compiled your circuit but the simulator doesn't realize this. It happens to every student one or more times in the semester

If the simulator just seems to not be reflecting your circuit changes or not working at all, you need to take action to reset it. There is a whole webpage devoted to this. It is called [Taming Vivado]({% link resources/tool_resources/taming_vivado.md %}) and is under the "Resources" link in the sidebar of this webpage. When this happens consult that page - it will lead you through the steps needed to kill the simulator demons and get it working again.

<!--
[[https://youtu.be/6CpSlv1se7U|External Link]]

<html>
<iframe width="768" height="432" src="https://www.youtube.com/embed/6CpSlv1se7U" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</html>

1. Open the simulator steps
 - While the GUI is opening, talk about how a new program is being loaded and that it is running within vivado. The GUI will change.
 - Remind them that any operation they perform can also be executed with a Tcl command. When they open the simulator with the GUI, this is the same as the “launch_simulation” command (when the simulation is open, show them the “launch_simulation” command in the Tcl window)
2. Simulator open
  - Point out the Blue top “Project Manager” bar is replaced with the Blue top “Behavioral Simulation Bar”
    - Can close it if you click on top right close button
  - The toolbar has changed. We will use these tools later.
  - Bottom Tcl console is different (different tabs). The Tcl console is the console for the simulator and not for the project manager
  - New Simulation GUI in the middle (will discuss later)
 - The left Flow navigator is the same

3. Simulator GUI
  - Four main areas
  - “Scopes” : this describes the various modules within the design you can examine. We only have one - in future labs you will have more. In some cases you can close this if you want more room.
  - Objects. This indicates the objects we can examine in the simulator for the current “scope”. Change the scopes by clicking on different scopes and note how the objects view changes. Discuss the objects in the objects view: top-level ports (both inputs and outputs), internal wires. Discusses the value and type of the object. Again, you can close this if you want more room.
 - Waveform view. Shows us the waveforms of the various signals. Different parts:
   - Waveform Toolbar to the left (lots of important tools here)
   - Signal name and value. These are the signals we are going to trace with the waveform viewer. Note the value of the signals. The inputs are a “Z” - this means they are high impedance or not set. The outputs are “X” meaning unknown. This is because we don’t have valid inputs.
   - Waveforms. Time is on the X axis and the Y axis are all of the signals we are going to view.

Note that all the objects of my module have already been placed in the view.
 - Tcl console. This will show the Tcl commands that are executed. Everything we do with the GUI will show up with Tcl commands.

4. Simple Simulation (with no input setting)
 - Start a simulaton by executing a “run” command.
   - update the run box to “10 ns” above
   - Click on “Run for” button to cause this run to occur
   - Remind them that every action has a command. There is a Tcl command executed for this GUI (run 10 ns). It is sometimes easier to type this in than to mess with the GUI.
 - Note the lines on the waveform viewer. These lines indicate the values. Describe what the blue means and what the red means.
 - Note that we are not looking at the full waveform - need to zoom out (zoom box button)
5. Simple simulation with inputs set
 - This isn’t a very interesting simulation so we are going to simulate with inputs.
 - Press the backward rewind button (restart). Note the Tcl command. What this does is starts the simulation over with time = 0
 - Set the inputs to zero (for input A). Note the corresponding add_force command
 - Set the input for B to zero but type a command. Discuss wy we can use “B” rather than full name
 - Set input for C (use up arrow to get the last command and change it)
 - Type {run 10 ns}. The simulation window now has green lines. The green lines are “good” meaning a 1 or zero. (no longer blue for Z or red for x)
 - Zoom out. Discuss the values of each output and the intermediate signals.
 - Set new values for A,B, and C, run 10 ns
 - Again a third time (four simulation values)

6. Creating Tcl script
 - Discuss the notion of scripts. Files that have commands
 - Have a script prepopulated
 - What directory are you in
 - Show them the source command

7. GUI tutorial.
 - Once you have a waveform, it is important to learn how to navigate through the waveform
  (using the simulation from above)
  - zoom full, zoom in zoom out
  - center on coursor
  - Go to time zero, go to end
  - Next edge

8. Managing waveform
- Deleting waveforms (intermediate signals)
- Adding waveforms that are interesting later

- Relaunch simulation button
- Exiting and the waveform save button (generally don’t save)


X. Close the simulator (note that the simulator is another program running within Vivado and it needs to be closed if we want to do something else).
  - Click on top right corner box

-->