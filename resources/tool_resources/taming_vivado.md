---
layout: page
toc: true
title: Taming Vivado
icon: fas fa-hippo
---

# Taming Vivado
As with all software, Vivado has a number of "features" which you will sometimes have to deal with. This page is to help with a number of commonly encountered issues you may need to understand.

# 1. General Compilation Errors
Sometimes your design will not compile and gives elaboration errors. This may happen when you are trying to start up a simulation or it may happen when you are trying to synthesize. Or, your synthesis might just never finish. How do you debug this case?

Elaboration errors occur when the syntax of all your files are correct (no missing semicolons or keywords) but other problems are discovered when the simulator tries to wire all your modules together into a complete design. Typical errors include instancing a module with the wrong number of ports, or referencing a module not in your project, ...

Usually, you will get an elaboration error message. If so, it will give a filename (sometimes it will also provide the error message in the log). If you don't see the error message in the log, but a filename is given, go open the file specified (File-\>Text Editor-\>Open File) and see what the error message is.

Or, sometimes when you try to simulate, it will hang with "executing analysis and compilation" in a popup box on screen, meaning it is hung trying to compile your design. If this happens to you when you are trying to start a simulation, please kill the simulation and then type the following command in the Tcl console window to reset your simulation files:
```tcl
reset_simulation -simset sim_1 -mode behavioral
```
This typically fixes that problem.

# 2. Wedged or Frozen Simulation
If your simulation is hanging, try the following steps to resolve your problem, starting with the first. Anytime you make a change to your Verilog code, the simulation needs to be rerun. Your code describes your circuit, and if you change it, you change the circuit you are simulating.

## 2.1 Have you turned it off and on again?
It sounds cliche, but it often works. Sometimes relaunching the simulation isn't sufficient and the old simulation needs to be closed by exiting out of the simulator completely. To do this, what we mean is this:
* When you are simulating, a blue bar appears near the top of the window that is labelled "Simulation".
* There is an 'X' at the right end of that bar.
* Click that 'X'.
* Now, run the simulation again.

Or, you may need to completely exit Vivado and restart it.

## 2.2 Are Multiple Copies of Vivado Running?
This is a common problem. Make sure there is only one copy of Vivado running. Sometimes the GUI will be gone, but there is a Vivado process running. You can check for Vivado processes in Linux by typing the following.
```sh
$ ps -ef | grep vivado
```
If you find any extra Vivado processes running, kill them with `kill <process id>`. If you don't have permissions to kill them (they are likely left from some other user), power cycle your entire machine.

## 2.3 Set Force Recompile
*Note: This should have already been done if you followed all of the instructions in the [vivado\_project\_setup]({% link tutorials/lab_03/00_vivado_project_setup.md %}) tutorial.*

Run the following command in the Tcl console:
```tcl
set_property INCREMENTAL false [get_filesets sim_1]
```

OR do the following steps:

1. In Vivado, right click on Simulate and select Simulation settings.
2. On the right side there is an 'Advanced' tab. Open it.
3. Uncheck the first box where it says, "Enable Incremental Compilation"
4. Exit out of your simulation if you haven't already and reopen it. If this doesn't work you may need to restart Vivado after making the change.

## 2.4 Clearing the Cache
This entails deleting everything related to simulation from your project. This can be done as above using the following at the Tcl Console:
```tcl
reset_simulation -simset sim_1 -mode behavioral
```

Or, you can do it manually from the File Explorer on the computer. Just be careful and don't delete your design files.

1. Exit out of Vivado.
2. Open your file explorer and navigate to your project.
3. There will at least be several files, including a .xpr file, which is your actual project, your .tcl files, and possibly a .srcs directory, which has source code. **All 3 of these are very important. Do NOT delete them\!** Make copies of them to be safe if you are worried. What you may delete is the "proj.sim" directory (or the similarly named directory for your project's name) to get rid of anything in your simulator setup that might be preventing new simulations from being started or running correctly.
4. Now reopen Vivado and open your project and you should be ready to go.

Sometimes you will get errors about not being able to delete some files -- this can be a sign that multiple Vivado processes are running. See above to fix.

# 3. Redo Your Project
We have seen cases where the only thing that fixes it is to create a new project with the same files. Here are the steps to do so:

1. Make a new directory.
2. Locate and copy all .sv, .xdc, and .tcl files from the existing project over to the new directory.
   - When you let Vivado create your .sv files, it usually buries them deep in a directory with a .srcs on the end of the name. Find them all and copy them over.
3. Start Vivado and create a new project in the new location.
4. Add all the source files.
5. Add the constraint file. For this and the source files above, since they already exist, uncheck the box about copying the files into the project and Vivado will leave them where they are. This is useful for files you already have created to keep Vivado from putting a copy deep inside the file hierarchy.

At this point you have a clean project with just the files you need.

# 4. Synthesis is Hung
Synthesis should only take 2-5 minutes for the labs we do. If your synthesis is never finishing, many of the options from above will work if adapted to synthesis instead of simulation. Here are some things to try:

1. Kill the synthesis (upper right corner of window) and re-run it.
2. Check to see if multiple copies of Vivado are running (see 2.2 above).
3. Quit Vivado and restart it and try again.
4. Clear the cache. This is similar to 2.4 above for manually clearing the cache. But, in addition to deleting the directory "proj.sim" you would also delete the directory "proj.runs", "proj.cache", "proj.hw" (or the similarly named directories for your project's name). This will get rid of anything in your synthesis setup that might be preventing it from running.
5. Redo your project as described in item 3 above.
