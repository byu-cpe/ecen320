---
layout: page
toc: true
title: Adding a SystemVerilog Design Module to a Project
lab: 3
---

This will show you how to add a new SystemVerilog source file to an existing project. You should make a new source file for every individual SystemVerilog module you make.

## Video Walk-Through
<iframe width="768" height="432" src="https://www.youtube.com/embed/18NNbml5qI0?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Adding a New SystemVerilog File
1. First, click **Add Sources**. This button is located in multiple places. (See video above)
2. This will open the New Source Wizard. Click **Add or create design sources** then **next**.
3. Click **Create File**. Change the File Type to **SystemVerilog**. Choose where you want to save the new file. A good place is in your "labN" directory. Click the File Location drop-down box and select **Choose Location**. Enter a name for the file and click **OK**. You can add more files before going to the next step if you want, but you can also do so any time later. Click **Finish** when you're done adding files.
4. Now you can enter all the port information for each module you're adding. Click **OK** when you're done. Better yet, if you want to wait and add the ports later, just click **OK** and then **Yes**. The ports can be added later by editing the SystemVerilog file after it gets created.
5. Now your new source(s) will be available in the **sources** pane under **Design Sources**. They will also be visible under **Simulation Sources**. To edit one of your sources, find the file in the **sources** pane and double click it to open it.

Make sure you **save your SystemVerilog file often**, especially before running a simulation or generating a bitstream file.

***IMPORTANT:*** The input and output syntax must match what is in the [SystemVerilog Coding Standard]({% link _pages/03_coding_standard.md %}) document -- this is so it will work with Vivado.

## Adding a Previously Created Module
This probably won't be useful in early labs but will be necessary in the later ones. This steps you through adding a source file that you have previously made (either in a past lab, or downloaded from the course website).

1. Go through steps 1 and 2 in the section above.
2. Instead of clicking Create File, click **Add Files**.
3. Browse to the location of the source file you wish to add.
   * If you created the source in Vivado, and saved the file internal to the project, you'll have to navigate to that project's folder, then to the subfolder named **\<project name\>.srcs** then **sources_1** then **new**.
4. Make sure the "Copy sources into project" checkbox is marked.
5. Click **Finish**.

<!--
==== Adding a file using Tcl commands ====

You can add a file to your project with a simple Tcl command on the command line. The syntax for adding a SystemVerilog design file is as follows:

<code>
add_files <file_name>
</code>

----

[[ta:tutorials#add_file_tutorial|TA Feedback]]
-->
