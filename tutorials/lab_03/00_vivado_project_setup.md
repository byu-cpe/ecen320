---
layout: page
toc: true
title: Creating a New Vivado Project
lab: 3
---

The purpose of this tutorial is to guide you through the steps for creating a new project in the Vivado design suite for developing logic circuits for the Basys 3 FPGA board.

# Project Creation
<iframe width="768" height="432" src="https://www.youtube.com/embed/2PczpXH1Qwk?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<span style="color:blue">**Notes on video (IMPORTANT TO READ):**</span>
* The video above was made for the FPGA board used in previous classes. <span style="color:blue">**THE CORRECT FPGA PART # TO USE FOR THE BASYS 3 IS xc7a35tcpg236-1.**</span>
* The video instructs you to put your project on the J: drive. Later it also shows a project being put onto the C: drive. Where you put your project matters a lot!
  * If you are running physically in the lab with Linux, put your project in your home directory (/fsx/username).
  * If you are running Vivado locally on your own computer (with Microsoft Windows), put your project on C:.
  * If you are running via Citrix, put your project on Box.
* Vivado will throw errors at inopportune times if you have space characters in directory names or path names. If you are running on your own laptop and your user name has a space in it, this will cause problems (see below for solution). Or, if you put spaces into directory names you create you will have problems (so don't do that).
  * While you could change your username in Windows AND figure out how to rename your home directory, the simplest solution might be to just create a new user (call it ecen220) on your laptop just for this class's lab.
  * And, when making subdirectories to hold your projects, do not name them things like 'Lab 3'. Rather, use 'Lab3' or 'Lab_3'.

Follow these steps to create a project:
1. Open Vivado **2019.2**. If running from the command line, make sure to setup the Xilinx environment first by running `source myenv.sh`. Then run `vivado`. Refer to Lab Getting Started, Exercise #3 if needed.

1. Click **Create Project**. Click **Next**.
1. Name your project after the lab that its for.
1. Check the **Create project subdirectory** box.
1. Type in a location path or click **...** to select a destination folder. Click **Next**.
1. Select the **RTL Project** button and check the **Do not specify sources at this time** box. Click **Next**.
1. Find the correct part by selecting the following filter information or by searching for the part name directly. If you do not select the correct board, you will have many problems.
   * **Family**: Artix-7
   * **Package**: cpg236
   * **Speed grade**: -1
   * **Part Name**: xc7a35tcpg236-1 <br>
     <img src="{% link media/tutorials/lab_03/00_vivado_project_setup/00_part_select.JPG %}" width="750">
1. Click **Next**, then **Finish**!

Follow these steps to change the part if you selected the wrong part to create your project:
1.  Go to Tools and Click **Settings** (The last option at the bottom of the popup menu).
1.  In the Settings window, select **General** under Project Settings.
1.  On the right hand side, go to **Project Device** to select the right part.

# Project Configuration
<!-- <span style="color:#BD8017"> -->
<span style="color:#1F45FC">After you have created your project, you should copy and paste the following commands and run them in the Tcl Console. You don't have to run them one at a time; you can copy the full set of commands, paste them in the Tcl Console and press Enter to run all of them. EACH TIME YOU CREATE A NEW PROJECT, YOU SHOULD PASTE AND RUN THESE COMMANDS. But, once you have done it for a new project, you don't have to ever do it again for that project.</span>

So, what are these commands doing? They are making a number of important settings for this Vivado project. They change what kinds of things count as errors (to keep you out of trouble), they change the behavior of certain tools (to do what we want), etc.

```tcl
set_msg_config -new_severity "ERROR" -id "Synth 8-87"
set_msg_config -new_severity "ERROR" -id "Synth 8-327"
set_msg_config -new_severity "ERROR" -id "Synth 8-3352"
set_msg_config -new_severity "ERROR" -id "Synth 8-5559"
set_msg_config -new_severity "ERROR" -id "Synth 8-6090"
set_msg_config -new_severity "ERROR" -id "Synth 8-6858"
set_msg_config -new_severity "ERROR" -id "Synth 8-6859"
set_msg_config -new_severity "ERROR" -id "Timing 38-282"
set_msg_config -new_severity "ERROR" -id "VRFC 10-3091"
set_msg_config -new_severity "WARNING" -id "Timing 38-313"
set_msg_config -suppress -id "Constraints 18-5210"
set_property INCREMENTAL false [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value 0ns -objects [get_filesets sim_1]
```

# Creating a Project using a Tcl Command
You can also create an empty project directly by running a Tcl command without using the GUI. The following command demonstrates this with the part used on the Basys 3 board:
```tcl
create_project <project name> <Path of project> -part xc7a35tcpg236-1
```

This is an example of creating a new project in your home directory.
```tcl
create_project proj /fsx/username/ecen220/lab03/proj -part xc7a35tcpg236-1
```

If you do things this way, you should still remember to execute the commands in the previous section after you have created the project.
