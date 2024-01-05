---
layout: page
toc: true
title: Viewing SystemVerilog as a Schematic
lab: 3
---

This will teach you how to view your SystemVerilog code as a schematic. This can be helpful in quickly finding simple errors or double checking that your code matches what you're trying to design.

<iframe width="768" height="432" src="https://www.youtube.com/embed/B77-11m9ARc?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

1. First, set the module you want to view as a schematic as your top module. Find the module under **Design Sources**, right click it and click **Set as Top**. (If your module is already set as the top module, this option will be grayed out.)
2. Click **Open Elaborated Design** on the left in the Flow Navigator.
3. If this window pops up, click **OK**.

   <img src="{% link media/tutorials/lab_03/02_viewing_design_elaboration/00_elaborate_design_pop_up.png %}" width="500">

4. After a short wait, it will display a schematic of your design.
5. If there are triangles that look like the below image in your schematic, these are not **NOT** gates (there is no inversion bubble on the tip of the triangle). These are called **buffers**, notice that they are labeled with **OBUF** underneath them. A buffer essentially passes its input to its output. You can ignore them for this class, Vivado generates them.

   <img src="{% link media/tutorials/lab_03/02_viewing_design_elaboration/01_buffer_ignore.png %}" width="250">

## Refreshing the Schematic

If you make changes to your SystemVerilog code after opening the elaborated design, you need to update the schematic. To do so, in the Flow Navigator, right click on **Open Elaborated Design** and click **Reload Design**.

<iframe width="768" height="432" src="https://www.youtube.com/embed/ruhl1G55714?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

A bar near the top of the Vivado window may also appear stating that the elaborated design is out-of-date. Clicking **Reload** on this bar will also successfully refresh the schematic.
