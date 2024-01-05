---
layout: page
toc: true
title: Linux Intro
lab: Linux
---

In this lab you will learn some basic Linux features and skills that are useful throughout a technical career. The Linux environment is used commonly in the engineering, scientific and research communities. One of the reasons for this stems from the openness of Linux and the many applications that run on it. The source code to most everything that runs on Linux, and the [kernel](http://www.kernel.org/) itself, is available on the Web. If you don't like something or want to improve it, nothing is stopping you from getting the source code and changing it. You are encouraged to learn and explore beyond what is presented here on your own. We can only touch on a few Linux features. Discovering the flexibility that is available to the creative mind is left to you. If you want to experiment more at home, a low cost hardware option that supports Linux is the [Raspberry Pi](http://www.raspberrypi.org/products/raspberry-pi-4-model-b/).

<span style="color:red;">The average time to complete this lab is 1.5 hours.</span>

# Learning Outcomes

* Become familiar with the Linux environment, commands, and some applications.
* Be able to navigate a directory tree from the command line.
* Use a text editor to create and edit text files.

# Linux Related Resources

* [The Linux Command Line for Beginners (tutorial)](http://ubuntu.com/tutorials/command-line-for-beginners)
* [Linux Survival (tutorial)](http://linuxsurvival.com)
* [The Linux Command Line (book online)](http://linuxcommand.org/tlcl.php)
* [Shell (bash) Built-in Commands - cd, pwd, echo, etc.](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html)
* [GNU Coreutils - cp, mv, rm, mkdir, chown, etc.](https://www.gnu.org/software/coreutils/manual/html_node/index.html)

# Exercises

## Exercise #1 - Explore Common Linux Commands
Work through Modules 1 and 2 of the [Linux Survival](http://linuxsurvival.com) tutorial. It has a simulated Linux terminal for practicing what you learn in the modules.

After finishing the modules, answer the following questions related to Linux commands.

<span style="color:red">What Linux command is used to:</span>
- <span style="color:red">copy files and directories?</span>
- <span style="color:red">move or rename files?</span>
- <span style="color:red">change the current directory to another?</span>
- <span style="color:red">list directory contents?</span>
- <span style="color:red">print name of current directory?</span>
- <span style="color:red">show the contents of a text file?</span>
- <span style="color:red">make directories?</span>
- <span style="color:red">remove empty directories?</span>
- <span style="color:red">change file mode bits?</span>

For a brief list of commonly used commands, see the [Linux Command Summary]({% link resources/tool_resources/linux_commands.md %}).

## Exercise #2 - Keyboard Shortcuts
Even though using the command line to do things in Linux may seem like a lot of typing, there are shortcuts in place that can tremendously reduce the number of keystrokes. With a little practice, the shortcuts become a natural part of doing work on the command line and can even be more efficient than pointing, clicking, and navigating menus in a graphical interface. With a graphical interface, a user will often need to move their hand back and forth between the keyboard and the mouse. This motion is inefficient, even though most of us get used to it. With command line operation, our fingers never need to leave the keyboard and reach for the mouse.

### Command History
When you type a command on the keyboard, there is a good chance you will want to execute it again, exactly the same way, or with a small variation. Using the up and down arrows on the keyboard allows you to navigate through a history of commands you have typed on the command line. When you hit the up arrow key the first time, the last command you executed will appear on the command line. If you hit up arrow again, you will see the next to the last and so forth. Typing down arrow will show more recent commands. After you have selected a previous command with the arrow keys, hitting the Enter key will execute the command.

### Command Editing
Once you have selected a prior command with the up and down arrow keys, you may want to slightly change it before you execute it again. The left and right arrow keys allow you to move the cursor to a location where you want to change the command. Use the backspace key to remove characters and then type new text at that location. When satisfied with the modified command, hit Enter to execute it. This is useful, for example, when you want to execute the same command on a different filename. Just hit up arrow to get the previous command, then backspace over the old file name and type the new one.

### Command Completion
Another helpful shortcut is called command or tab completion. If the tab key is pressed while a partial command or file name is typed, the shell will complete the rest of the text based on what has already been typed. Open a terminal window to your home directory and type the following and then hit `Tab`.
```sh
ls Doc
```
After hitting `Tab` you should see that "Doc" was extended to "Documents/". Now type `Enter` to execute the command. When navigating deep directory hierarchies, tab completion can assist in typing what could otherwise be very long path names. For example, tab can be pressed multiple times to keep extending the path name after typing a few characters, enough to make the name unique.

Command names can also be tab completed. In a terminal window, type the following and then hit `Tab`.
```sh
fir
```
Pressing the tab key should complete the command to "firefox". Press `Enter` to start the web browser. If you press `Tab` and you don't get a response, you have mistyped the leading characters or there are other options that are ambiguous. Typing `Tab` again a second time will list the remaining options that begin with the characters you have typed.

## Exercise #3 - Set and Read Environment Variables
The Linux environment holds configuration variables used by application programs. These variables are set in the environment by a user or by the system as needed. Knowing how to set environment variables and view them is important, since some Linux application programs may depend on you setting these up properly before running them. For example, the Xilinx design tools use environment variables that indicate the license key location and file paths where programs are installed on the system. Now let's see how to set an environment variable. The following example will set the variable MYLAB to a value of 02.
```sh
export MYLAB=02
```
After typing the command in the terminal, you can view the value that was last set by typing:
```sh
echo $MYLAB
```
You can also see your variable among all the others by typing:
```sh
env
```
<span style="color:red">What is the value of the HOME environment variable on your Linux system as seen from a terminal window?</span>

## Exercise #4 - Get Familiar with a Text Editor
Several text editors are installed on your system, for example, code, gedit, vi, and vim. Some applications can only be run from the command line, while others can be launched graphically by clicking on its icon in the application screen. Choose an editor, and use it to create a new file.

1. Open a new file in your home directory and create a note to yourself.
1. Experiment with deleting text, copying, and pasting.
1. Save the file.
1. Open a terminal window and type `ls -l` to see details about the text file you created.

<span style="color:red">What are the file permissions and type on the text file you created (first 10 characters from a long listing, ls -l)?</span>

<span style="color:red">What editor did you choose to explore?</span>

You can remove the text file you created by typing `rm <filename>` at a terminal window prompt.

## Exercise #5 - Setup Shell Configuration Files
If the default configuration of your command line environment is not what you would prefer, you can change it to your liking. Let's go through how to customize your environment.

When you first open a terminal window, if your home directory contains a file named .profile, the command shell (bash) will read and execute commands from that file before giving you the command prompt. Copy an example .profile file to your home directory and another file named .bashrc, which is called as an additional configuration script.
```sh
cp /etc/skel/.profile .
cp /etc/skel/.bashrc .
```
Since the file names begin with a dot '.', they are hidden from the `ls` command unless you use the -a option (e.g. `ls -a`).

Use your text editor of choice to view these files and make any changes according to your preferences. For example:
```sh
gedit .bashrc
```
If you are not familiar with a command and want to know what it does, type `man` and the name of the command to see a help manual for that command. You can open another terminal window at the same time to type the `man` command and see the helpful text. Many of the commands used in .bashrc, like `alias`, are built into bash. For these, type `man bash` to get help. If you type `man <command>` and the response is `No manual entry for <command>`, it is likely built into bash. Online help is also available for [shell built-in commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html) and other [core commands](https://www.gnu.org/software/coreutils/manual/html_node/index.html).

One of the preferences set in the example .bashrc file you copied over is to define an alias for typing `ll` at the command line. When the alias is defined, typing `ll` will actually execute `ls -alF` with the long listing option. To customize this for pass-off, remove the 'a' and 'F' options so that the line reads `alias ll='ls -l'`. Lines beginning with a '#' in shell scripts are comments and are not executed.

Save any changes you have made to .profile or .bashrc. Test that your preferences are working by closing the terminal window and opening a new one. Then type some commands that exercise the preference. Files listed with `ls` should now be shown with color.

<span style="color:red">List one of the commands used in your new .bashrc file and briefly explain what it does.</span>

## Exercise #6 - Personal Exploration
In this exercise you are given the freedom to explore and learn as much as you would like about application programs on your system. These can be command line based or graphical applications. Because of this freedom, the exercise may seem vague, but specifically, you are to pick a program, run it, look at the help menu (or man pages), explore other menus (or command line options), and figure out how it works. What is the program used for? Why would someone, maybe yourself in the future, want to use it?

Choose a Linux application and explore its features and functionality. Examples from the application screen are LibreOffice, System Monitor, To Do, Utilities, Visual Studio Code, etc.

<span style="color:red">What application did you choose to explore?</span>

# Final Pass-Off
Do the pass-off in person with a TA or by video:

<span style="color:green">Show that you can open a new terminal window and type `ll` as the first command to get a long listing of files. Also, explain what you chose to do for your personal exploration exercise and what you learned from it.</span>

# Final Questions
Answer the following questions:

<span style="color:red">How many hours did you work on the lab?</span>

<span style="color:red">Provide any suggestions for improving this lab in the future.</span>

<!-- Exercise Ideas
Go over, demonstrate Linux commands, use linuxsurvival.com
Set and read environment variables
Get familiar with a text editor. Find a topic about how to use VSCode - explain what you learned in a paragraph
Setup bash profile with some customization, copy skeleton file
Create a myenv.sh script to setup Vivado environment
Use git clone to pull in a repo and use for a tutorial
Use wget to download a tarball and build the project, wget https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz
-->
