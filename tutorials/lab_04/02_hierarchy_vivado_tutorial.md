---
layout: page
toc: false
title: Managing Hierarchy in Vivado
lab: 4
---

* Discuss the concept of hieararchy. You manage hierarchy directly in your design files (instancing modules)
* When you add files to Vivado using the "add file" command (link to tutorial), the Vivado design suite will analyze the design and try to recognize the hierarchy.
* If you correctly implemented hierarchy in your design files, you will see this hierarchy in the design file browser window (give a screen shot of this).
* If you incorrectly implemented hierachy in your design files, you won't see hierarchy in your design file browser window. (give a screen shot). Instead, you will see a missing file and a second file (referring to the screen shot).
* Discuss the things that cause the hierarchy to be incorrect:
  * There is a mismatch between the module you are instancing in your top-level Verilog and the actual module you are trying to instance: difference between name of module, different name of port, different size of ports.
  * How to cause the design to reanaluyze? (update_command? save file command?)
* How to change "top-level" (for synthesis, simulation, etc.)

<img src="{% link media/tutorials/lab_04/02_hierarchy_vivado_tutorial/mismatch_hierarchy.png %}" width="500">

<img src="{% link media/tutorials/lab_04/02_hierarchy_vivado_tutorial/matched_hierarchy.png %}" width="500">
