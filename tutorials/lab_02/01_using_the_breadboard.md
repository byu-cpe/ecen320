---
layout: page
toc: true
title: Building Logic Circuits on a Breadboard
lab: 1
---

A **breadboard** is a construction base or board for prototyping electronic circuits. These boards allow you to easily create circuits without soldering wires or building a custom **PCB** (printed circuit board). Breadboards allow the creation of temporary connections between components that can easily be changed or removed. Although breadboards are great for rapid circuit prototyping, they are not very robust and may fall apart with too much use or rough handling (you will need to be gentle with your circuits). Prototype circuits are often transferred to more permanent form such as PCBs after being tested and verified. You will use a breadboard to create simple digital logic circuits.

# Breadboard Overview
We will use the FX2-BB breadboard manufactured by Digilent for our labs. This breadboard has a lot of holes in which you can insert the pins of a electronic device or wires to make connections between different parts of the circuit. This breadboard has over 1,000 holes for making such connections.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/00_breadboard.jpg" width="800">

The image below demonstrates the organization of a breadboard. Each of the holes in a breadboard column (five holes in this case) are electrically connected, allowing you to build connected circuits by placing wires in the holes of the column. For example, the holes A1, B1, C1, D1, and E1 are all electrically connected. This electrical connection does not cross the "gutter" (the gutter is the notch in the breadboard that separates columns of holes). The holes F1, G1, H1, I1, and J1 are all electrically connected but they are isolated from the holes across the gutter (A1, B1, C1, D1, and E1).

The two colored rows of holes in the middle are different from the "columns" and are electrically connected horizontally. All 50 of the holes with the red row are connected electrically and are intended for positive voltage (+) or **VCC**. The blue row is also connected electrically and is intended for the ground (-) or **GND**. Having two rows dedicated to **VCC** and **GND** facilitate the ability to easily attach power and ground to each of the 7400 series chips. These long rows are often called **rails**.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/01_breadboard_holes_explained.jpg" width="800">

In order to begin building a circuit with these chips on your breadboard you must complete the following steps.
1. Place your **IC** (integrated circuit) chips onto the breadboard. The ICs **must** be placed over a gutter so that the pins on opposite sides of the chip are not connected together.
2. Make power and ground connections to each chip. Connections must be made from the **VCC** power rail to the chip's **VCC** pin and from the **GND** rail and the chip's **GND** pin.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/02_ic_with_power.jpg" width="600">

# Breadboard Pins
The FX2-BB breadboard has a number of pins along the edge that provide power, inputs, and outputs for your circuit, as shown and explained below. You will need to attach wires from these edge pins onto your breadboard to complete your circuit.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/03_breadboard_pins.jpg" width="800">

Along the top edge of the breadboard are the power pins. For these labs you will only be using **VCC** and **GND**. You will need to add a wire from one of the VCC pins to the VCC power rail on the breadboard. You will also need a wire from the GND pin to the GND power rail on the breadboard.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/04_ic_with_power_and_bus.jpg" width="800">

Along the right edge of the breadboard are the **I/O** (input/output) pins that you will be using for providing inputs to your circuit and capturing the outputs. The breadboard will be mated with the Basys 3 board so the buttons on the Basys 3 board can be used as inputs to your breadboard circuit. In addition, your outputs will be connected to the LEDs on the Basys 3 board. To use the Basys 3 buttons and LEDs, you will need to use pin groups **J1** and **J2** as circled below.

<img src="/media/tutorials/lab_02/01_using_the_breadboard/05_breadboard_io_pins.png" width = "200">

# Attaching the Basys 3
The Basys 3 board needs to be connected to the breadboard to provide power, inputs, and outputs. With the Basys 3 board turned off, connect the two boards together by attaching the female connectors on the left side of the Basys 3 to the male connectors on the right side of the breadboard as shown below. Make sure that the Jumpers J1 and J2 on the breadboard are both set to **VCC** (and not VU).

<img src="/media/tutorials/lab_02/01_using_the_breadboard/06_breadboard_basys3_attach.jpg" width="600">

Note that there are two rows in the Basys 3's pins, but only one on the breadboard. Plug the breadboard into the Basys 3's top row.