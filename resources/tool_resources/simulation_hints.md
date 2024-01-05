---
layout: page
toc: true
title: Simulation Hints
icon: far fa-smile-wink
---

Some things that can help with simulation:

# 1. Interactive Simulation
It is not necessary to always push the "Run All" button when simulating. You can instead run for just 2000 ns, look at the waveforms, and repeat. For some labs, running the entire testbench can take 15 minutes -- don't blindly click Run All.

Related to the above, with testbenches provided for you to use, if there is an error that gets printed, hit the pause button at the top of the screen (looks like `||`) rather than wait another 10 minutes for the Run All to complete. You can then immediately start debugging.

Related to the above, you can type Tcl commands into the Tcl command line area -- use it\! Rather than make little changes to your Tcl files and then re-run the entire simulation, just start typing commands into the Tcl command line. Reset your circuit, apply inputs, and run for a bunch of ns. This is far superior to restarting from scratch every time you need to make a change to your Tcl file. It makes debugging interactive...

Once you have figured things out you can go back and modify your Tcl file accordingly based on what you have learned.

# 2. Visibility is EVERYTHING !!!!
If the top-level signals in your design aren't working, it may be due to something inside your other modules. And, if you cannot see what is inside your other modules in the waveform view, how in the world could you ever debug it?

For example, if your timer is not working, is it a) because it is not being told to increment?, b) because it is never reset?, or c) something else? Watching its internal signals will allow you to figure that out immediately rather than having to just guess.

So, once the simulation has started, click the "Scope" tab next to sources and drag your other modules (or selected signals from those modules) into the waveform viewer. It will make their signals visible in the waveform view and you should be able to tell where the problem is in your code both a) immediately and b) without guessing.

You can also add dividers to separate out your top-level signals from the new ones you drag down. To find the option, right-click in the signal names area in the waveform viewer and look for dividers. You can even assign names to the dividers you add.

Finally, you can save this new waveform configuration to your project and it will become the default waveform that appears when you start a simulation. If you later want to go back to the default you can delete the one you created (look in Simulation Sources in the Sources pane).

And, remember, you can ***never*** have too much visibility into your circuit.
