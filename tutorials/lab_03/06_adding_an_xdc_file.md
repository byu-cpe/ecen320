---
layout: page
toc: true
title: Adding a Constraints File to your Project
lab: 3
---

Like your SystemVerilog design files, the XDC file must be added to your project. Follow these instructions to add your .xdc file to your project.

## Adding an Existing File
If you are using the Master Constraints file (which you should be doing), then edit a copy of it in your project directory as needed and keep the original for use in another project. In other words, copy or download the [master XDC file]({% link resources/design_resources/basys3_220.xdc %}) to your current lab directory and then modify the copy. Each lab project should have its own XDC file.
1. Place a copy of the constraints file in your lab directory (e.g. ecen220/lab3).
2. Click on **Add Sources** just like in the [Adding a SystemVerilog Design Module to a Project]({% link tutorials/lab_03/01_creating_a_new_module.md %}) tutorial. However, this time select **Add or create Constraints**. Click **Next**.
3. Click **Add Files** and then select the constraints file from the file explorer. Click **OK**.
4. The added XDC file can be accessed from the **Project Manager**, in the **Sources** pane, inside the **Constraints** folder. Find the file and double click it to open it.

## Creating a New File
<iframe width="768" height="432" src="https://www.youtube.com/embed/kb4UXGJdocE?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

If you are creating an XDC file from scratch, you can name it whatever you want.
1. Click on **Add Sources** just like in the [Adding a SystemVerilog Design Module to a Project]({% link tutorials/lab_03/01_creating_a_new_module.md %}) tutorial. However, this time select **Add or create Constraints**. Click **Next**.
2. Click **Create File**. Ensure that the File Type is **XDC**. Choose where you want to save the new file. A good place is in your "labN" directory. Click the File Location drop-down box and select **Choose Location**. Enter a name for the XDC file and click **OK**.
3. Your new XDC file can be accessed from the **Project Manager**, in the **Sources** pane, inside the **Constraints** folder. Find the file and double click it to open it.

<!--
===== Adding an XDC file with a Tcl command =====

You can add your file to your project with the following Tcl command:

<code>
add_files -fileset constrs_1 -norecurse <filename.xdc>
</code>
*/
----

[[ta:tutorials#adding_xdc_files|TA Feedback]]
-->

