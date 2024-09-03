# ECEN 320 Web Page

This is the repository for the ECEN 320 web pages.
This repository was copied from the [ECEN 220](https://github.com/byu-cpe/ECEn-220) repository. 
The following steps were used to create this initial repository:
```
# See: https://stackoverflow.com/questions/6613166/how-to-duplicate-a-git-repository-without-forking
# Create an emptp ecen320 repository
cd ecen320
git init
git fetch --depth=1 -n git@github.com:byu-cpe/ECEn-220.git
git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "initial commit")
```

See the following [page](https://github.com/byu-cpe/ECEn-220/blob/master/README.md) for details in setting up a new class website.

## Web Page Versions

The repository contains the history of the web pages for the class over time. 
This section summarizes the different versions of the lab pages to make it easier to view previous labs.

### Winter 2024

* [Lab 1 - Introduction to Basys3 Board](https://github.com/byu-cpe/ecen320/blob/winter25/_labs/lab_01.md)
* [Lab 2 - Vivado Synthesis Tools](https://github.com/byu-cpe/ecen320/blob/winter25/_labs/lab_02.md)
* [Lab 3 - Structural Verilog](https://github.com/byu-cpe/ecen320/blob/winter25/_labs/lab_03.md)
* [Lab 4 - Arithmetic](https://github.com/byu-cpe/ecen320/blob/winter25/_labs/lab_04.md)
* [Lab 5 - Seven Segment Display](https://github.com/byu-cpe/ecen320/blob/winter25/_labs/lab_05.md)

Differences from ECEN 220:
* Drop lab 0 (lab orientation) and combine it with the introduction of the Basys3 board

### Initial Copy from ECEN 220

The repository was initially created by copying the last version of the [ECEN 220 repository](https://github.com/byu-cpe/ECEn-220) (taught in spring term of 2023).
The tag for this initial version is ['initial'](https://github.com/byu-cpe/ecen320/tree/Initial) and contains the following labs:
* [Lab 0 - Lab orientation](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_00.md)
* [Lab 1 - Introduction to Basys3 Board](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_01.md)
* [Lab 2 - Introduction to Linux](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_02.md)
* [Lab 3 - Structural Verilog/Introduction to Vivado](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_03.md)
* [Lab 4 - Arithmetic](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_04.md)
* [Lab 5 - Seven Segment Display](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_05.md)
* [Lab 6 - Fun With Registers](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_06.md)
* [Lab 7 - Stopwatch](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_07.md)
* [Lab 8 - Debouncer](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_08.md)
* [Lab 9 - UART Transmitter](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_09.md)
* [Lab 10 - Codebreaker](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_10.md)
* [Lab 11 - UART Receiver](https://github.com/byu-cpe/ecen320/blob/Initial/_labs/lab_11.md)

This initial repository also contains a number of historical 'unused' labs:
* [Arithmetic no subtractor](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/arithematic_no_subtractor.md)
* [Codebreaker VGA](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/lab_codebreaker_vga.md)
* [Lab Gates](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/lab_gates.md)
* [Simulation Lab](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/lab_sim.md)
* [Pong 1](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/pong_1.md) and [Pong 2](https://github.com/byu-cpe/ecen320/blob/Initial/unusedPages/pong_2.md)

# Related Resources

* [ECEN 220 Lab Resources](https://github.com/byu-cpe/ecen220_labs): Contains solutions and resources for ECEN 220 labs that are not part of the published web page
