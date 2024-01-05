---
layout: page
toc: true
title: Submitting Project Files
lab: 0
---

We are making a change to how things are turned in for labs to enable quicker grading by the TA's.

# The Old Method
* In the old method, using <span style="color:red">red text</span> you were asked to submit some SystemVerilog code files to the Lab Online Writeup.
* In the old method you were also asked, using <span style="color:green">green text</span> to submit the URL to a video on your project.

# The NEW Method
* We are going to swap the above moving forward. In future labs, there will be <span style="color:red">red text</span> instructing you to attach the URL of your video.
* And, in future labs, there will be <span style="color:green">green text</span> instructing you to attach a ZIP file of all your project code.

IMPORTANT: you cannot attach any other kind of files - they must be ZIP files for the grading system to work correctly.

## Making ZIP Files
Depending on how you are running Vivado you may need to copy the relevant files to your home machine to do the following steps. Or, you may not need to. Figure it out and ask a TA if you need help.

### Windows
Let's assume you have 4 files you want to ZIP up to attach for a particular lab: `top.sv` `sevenseg.sv` `simulateCommands.tcl` `basys3.xdc`:
1. In the File Explorer go into the directory where those files are. If they are not all in the same directory you may need to copy them so they are all in a directory by themselves (make a subdirectory to hold them - this would serve as a record for you of what you submitted). Or, you could learn how to have all them in the base project directory to start with.
2. In the File Explorer, select them all with the mouse and then do `right click --> Send to --> Compressed (zipped) folder`. The name you choose for the ZIP file is not important - it just needs to have a .zip extension.
3. If you want to verify that you got the files into the ZIP successfully, copy the ZIP file to a new directory and double-click on it in the File Explorer. If the files you thought you zipped reappear, then you got it right.

### Mac
Let's assume you have 4 files you want to ZIP up to attach for a particular lab: `top.sv` `sevenseg.sv` `simulateCommands.tcl` `basys3.xdc`:
1. Open a terminal windows and `cd` into the directory where the files where those files are. If they are not all in the same directory you may need to copy them so they are all in a directory by themselves (make a subdirectory to hold them - this would serve as a record for you of what you submitted). Or, you could learn how to have all them in the base project directory to start with.
2. Execute the following command:
```sh
zip someFileName.zip top.sv sevenseg.sv simulateCommands.tcl basys3.xdc
```
Or, you could use this to minimize typing:
```sh
zip someFileName.zip *.sv *.tcl *.xdc
```
3. If you want to verify that you got the files into the ZIP successfully, copy the ZIP file to a new directory and then type the following command:
```sh
unzip someFileName.zip
```
If the files you thought you zipped reappear, then you got it right.

NOTE: you CANNOT use the Mac Finder's `Compress` menu item to do this - it doesn't create a zip file like we need. It adds an extra layer of hierarchy in the file. So, use this command line approach.

### Attaching Your ZIP File
Regardless of how create your ZIP file you will attach it to the Learning Suite question.

The Learning Suite assignments being used have changed. There will no longer be a `Lab 4 Passoff` in the Exams section of Learning Suite any more. Rather, it will be a regular assignment and will be called `Lab 4 Files`. This will consist of a single question which will ask you to attach your ZIP file to satisfy the requirement. Once again, it must be a ZIP file the system to work.

A TA will then review the files you ZIPPED together to give you a grade on it. Due to this change, the relative weightings of the 2 Lab things you turn in (Lab Online Reports and Lab Files) will be adjusted.

## Getting Feedback on Your Code
You will not get feedback inside the Learning Suite question like you have before. Rather, when the TA is done correcting your code, a file will be added to the Content Section of Learning Suite which contains the feedback for everyone's assignments in a text file. Each student's feedback will be identified by that student's Homework ID # and so it will be confidential. Once that file appears you may see why you got the score you got.

If you have questions about why you got what you got, you may visit with the TA who corrects labs (and whose name and contact info is on the lab webpage for Zoom addresses and schedule).