---
layout: page
toc: true
title: Installing Putty on a Personal Machine
lab: 9
---

PuTTY is a computer application that allows a user to send and receive character data on a machine's serial device. A serial protocol transmits data bit-by-bit over a single wire. A number of our labs use that capability, so you will need to have it available.

When you program your FPGA board, you do it over a USB cable that goes between your computer and the FPGA board. It turns out that there are chips and software on the FPGA board as well as in your own computer so that you can _piggyback_ serial communications over USB. Thus, if your FPGA design is transmitting serial information on its `tx_out` pin, that will appear on your personal machine on either a COM port (Windows) or a /dev/tty device file (Linux) - having been transmitted to your computer over the USB cable.

The program PuTTY is a piece of software you run on your computer to communicate with that port: (1) anything received on the port will be displayed on the PuTTY screen and (2) anything you type in the PuTTY program will be sent out the port.

If you are on a personal machine you will need to install it, otherwise it is already installed on the lab machines. Follow the directions below to get PuTTY installed.

## Windows
1. Download the Windows 64-bit Installer here: [https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
2. Follow the Installation Wizard. We recommend adding the shortcut to your desktop for easy access.
3. You are ready to use PuTTY! Refer to the [PuTTY Setup]({% link tutorials/other/01_putty_setup.md %}) for configuration help.

## Linux
1. Open a Terminal Window. You can do this in Linux by searching for "Terminal" within the "Show Applications" widget in the bottom left hand corner or by right clicking on the desktop and selecting the open terminal option.
2. Install PuTTY - to do so run "sudo apt-get install -y putty" in the terminal.
3. Add yourself to the dialout group by typing "sudo usermod -a -G dialout MY_USER_NAME".
4. To launch PuTTY, run "putty" in the terminal.
5. You are ready to use PuTTY! Refer to [PuTTY Setup]({% link tutorials/other/01_putty_setup.md %}) and skip ahead to the PuTTy Configuration Section. As a Linux user, your serial port will be either /dev/ttyUSB0 or /dev/ttyUSB1.

## Testing Your PuTTY
You can test whether your PuTTY is working by setting it up as detailed above and then programming a Basys 3 FPGA board with [this file]({% link resources/example_bitfiles/tx_putty_test.bit %}).

Once you have programmed the board with this bitfile, every time you push the center button ('btnc') on the board, it will print out a message on the serial line saying that the putty test worked. If you see the message, all is working. If not, some debugging is in order.