---
layout: page
toc: true
title: Downloading a bit file to the Basys 3 Board Using Adept
lab: 1
---

This will show you how to download a bit file to the Basys 3 board by using the program called Adept.

NOTE: the instructions below may show an XC7A100T FPGA chip in some of the video or pictures. In your case you will see XC7A35T instead (your board uses a slightly different FPGA chip).

# Video
Here is an overview video:

<iframe width="768" height="432" src="https://www.youtube.com/embed/io6519JBCCY?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# Instructions
* First, check that your Basys 3 jumpers are correctly placed by following the [Setting Jumpers on the Basys 3 Board]({% link tutorials/lab_01/04_setting_up_the_basys3_jumpers.md %}) tutorial.
* Plug in your Basys 3 board with a micro USB cable and turn it on.
* Open **Adept**, which can be found on the desktop.
  ![]({% link media/tutorials/lab_01/06_downloading_to_the_basys3_using_adept/00_adept_shortcut.png %})
  * If you get an error that says "Initialization Failed" you forgot to turn on the Basys 3.
* If **Basys 3** isn't selected in the top right of the window, change it to select Basys 3.
* Click **browse**.
* Navigate to the **bit file** that you are going to download to the board. Select it and click **open**.
* Click **program**.
  * Wait for the bit file to be programmed to the board!
  * When it is done Adept will say **Programming Successful** at the bottom.
  * The **DONE** LED on the board itself will also light up. Check for the LED being on the before proceeding.

![]({% link media/tutorials/lab_01/06_downloading_to_the_basys3_using_adept/01_adept_programming_successful.png %})

You can select recent files with the file name drop down menu.

If Adept doesn't recognize your board, make sure the Basys 3 board is turned on and plugged into your computer. Also check that the **Auto Initialize SC** checkbox is marked under **Settings**.
