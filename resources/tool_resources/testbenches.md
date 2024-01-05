---
layout: page
toc: true
title: Testbenches - An Alternative to Tcl
icon: fas fa-cogs
---
by Prof. Brent Nelson 3/2020...

# Intro
The most common way to simulate a SystemVerilog design is actually to write a testbench in SystemVerilog and use it to drive values into your design and monitor the outputs for correctness. For example, that is what all the testbenches you are given in the various labs do themselves.

Since you know SystemVerilog you can use it to write a testbench rather than learn yet another language (Tcl). The advantage of Tcl, however, is that it is trivial to learn to use for extremely simple testbenches (and that is why we use it in this class). However, SystemVerilog has many advanced features which make it possible to write sophisticated testbenches that could not be reasonably coded in Tcl.

So, while it is a mixed bag for simple circuits, essentially *all* industrial digital circuit design simulation is done using testbenches instead of Tcl. Thus, learning how to write testbenches is a useful skill.

If you know Tcl, it is very straightforward to create an equivalent testbench. This will be illustrated using some examples that you may choose to mimic. Before we start here are some things to know:

1. A testbench is THE top level module in your design. That is, it contains your design.
2. A testbench has no input or output ports -- it essentially represents the environment your design will operate inside of.
3. The main components of a testbench include:
   - Local signal declarations
   - Inserting an instance of your design and wiring the local signals up to it.
   - A clock generation block (if your design has a clock)
   - A set of statements which do the following: a) set some of the local signal values, b) run for some time period, c) repeat.

Finally, a very big CAUTION: the SystemVerilog language features used to write testbenches *cannot* be used in the design of circuits -- the synthesis tool would not know what to do with much of it. Rather, we are using SystemVerilog in our testbenches like C or Java or python -- we are using it as a sequential programming language. This is perfectly normal and is how it is intended to be used for testbenches. So remember -- the kind of SystemVerilog you write for your digital circuits (which will be synthesized to an FPGA) is very different from the kind of SystemVerilog you write for testbenches.

----

# A Combinational Testbench
Here is a simple combinational design:

```verilog
// In file mux2.sv:
module mux2(
  input wire logic sel,
  input wire logic a,
  input wire logic b,
  output wire q);

  assign q = sel?b:a;
endmodule
```

And, here is a testbench for it:

```verilog
// In file tb.sv:
module tb();

  logic sel, a, b, q;   // The local signals

  mux2 M0(sel, a, b, q);  // The instantiation

  // An initial block is a piece of sequential code
  // In general it cannot be synthesized and is used
  // only for testbenches.
  initial begin
    sel = 0;      // Set initial values
    a = 0;
    b = 0;
    #10ns;        // Wait for 10ns

    sel = 0;      // Do it again
    a = 1;
    b = 0;
    #10ns;

    sel = 1;      // And again...
    a = 1;
    b = 0;
    #10ns;

    // and so on...

  end
endmodule
```

So, if you can write a Tcl script to exercise a combinational circuit, you can certainly do one as a SystemVerilog testbench.

----

# Testbenches for sequential circuits
The major difference here is that there is a clock:

```verilog
//In file cnt.sv:
module cnt(input wire logic clk, clr, output logic[7:0] q);
  always_ff @(posedge clk)
    if (clr)
      q <= 0;
    else
      q <= q + 1;
endmodule
```

and here is the testbench:

```verilog
// In file tb.sv
module tb();

  logic clk, clr;
  logic[7:0] q;

  cnt MYCNT(clk, clr, q);

  // Here is how we make a clock generator with a 10ns period:
  initial begin
    clk = 0;
    forever clk = #5ns ~clk;
  end

  // Here is how we assert signals.
  // Note, rather than worry about ns,
  // we just wait for negative edges of the clock
  // to change our input signals.  This
  // ensures they don't change right at the
  // clock rising edge (which, if they did,
  // would cause a "race" and make you pull your hair out
  // trying to debug it).
  initial begin
    clr = 0;
    @(negedge clk);  // Wait until the next falling edge of the clock

    clr = 1;
    @(negedge clk);

    clr = 0;
    repeat(13) @(negedge clk);   // Wait for 13 clock cycles

    clr = 1;
    repeat(2) @(negedge clk);

    // and so on...

  end
endmodule
```

So, what happens when you have two *initial* blocks in a testbench? The simulator will simulate them as if they executed in parallel. That is, they both are running all the time (or so the simulator makes it seem). Thus, the clock generator block can run independently of the actual main block that exercises the circuit.

----

# Writing a Self-Checking Testbench
A testbench can have the ability to check to see if your design outputs correct answers. Here it is for the MUX testbench above:

```verilog
// In file tb.sv:
module tb();

  logic sel, a, b, q;   // The local signals

  mux2 M0(sel, a, b, q);  // The instantiation

  int error_count = 0;

  // A function definition to help us check correctness
  function void checkData(logic expected);
    if (expected != q) begin
      $display("ERROR at time %t: got a %d but expected a %d", $time, q, expected);
      error_count++;
    end
  endfunction

  initial begin
    sel = 0;      // Set initial values
    a = 0;
    b = 0;
    #10ns;        // Run for 10ns
    checkData(0);

    sel = 0;      // Do it again
    a = 1;
    b = 0;
    #10ns;
    checkData(1);

    sel = 1;      // And again...
    a = 1;
    b = 0;
    #10ns;
    checkData(0);

    // and so on...

  end
endmodule
```

This testbench uses a function to check correctness and has a $display() function to print messages to the console.

SystemVerilog supports not only functions, but also *tasks*. A task is like a function except a) it *cannot* return a value and b) it *can* advance simulation time. Using a task, the above testbench could be rewritten like this:

```verilog
module tb();

  logic sel, a, b, q;   // The local signals

  mux2 M0(sel, a, b, q);  // The instantiation

  int error_count = 0;

  // A function definition to help us check correctness
  function void checkData(logic expected);
    if (expected != q) begin
      $display("ERROR at time %t: got a %d but expected a %d", $time, q, expected);
      error_count++;
    end
  endfunction

  task applyValuesAndCheck(logic sin, ain, bin, expected);
    sel = sin;
    a = ain;
    b = bin;
    #10ns;
    checkData(expected);
  endtask

  initial begin
    applyValuesAndCheck(0, 0, 0, 0);
    applyValuesAndCheck(0, 1, 0, 1);
    applyValuesAndCheck(1, 1, 0, 0);

    // and so on...

  end
endmodule
```

The testbench just got much, much shorter. Importantly, the actual interesting stuff (the values to apply and the expected answers) are concentrated in just a few lines of code, making it easy to understand and to add new combinations without much typing.

Also, the list of inputs and expected values could be stored in an array or read from a file.

A similar structure could be applied to the construction of a testbench for a sequential circuit.

And, it could go on and on and on. For example, there is a whole object oriented side to SystemVerilog (which can only be used in testbenches) so that advanced test frameworks can be constructed (we teach a graduate course on that topic). So, did you really think they simulate their quad-core Pentium processor designs containing billions of transistors at Intel by typing Tcl scripts in by hand? :-)

----

# Using $finish
By default, when you start a simulation in Vivado it will run for a set amount of time (1000ns) and then stop, awaiting further input from you.

If you want your simulation to quit before that, you can stop it early by putting a $finish call into your testbench like this:

```verilog
    ...

    clr = 0;
    #100ns;

    $finish;
  end
endmodule
```

The simulation will stop and return control to the GUI. At this point, if you want you can continue simulating using the Tcl console or the buttons at the top of the simulation window.

A good use for this is to always put a $finish in your testbench where you know it finishes its testing (which may be 100000's of ns into the simulation. Then, once the simulation runs the first 1000ns, you can type:

```tcl
run -all
```

in the console window which instructs the simulator to run until it hits a $finish command. This way you don't have to know precisely at what time your simulation will end.

If you do this, the simulator will print a message to the Tcl console when it finishes, telling you when it ended and why:

```
$finish called at time : 2640 ns : File "/home/nelson/cnt/cnt.srcs/sources_1/new/tb.sv" Line 61
```

----

# Debugging in Simulation
The Vivado simulator has debug capabilities similar to what you find in programming language tools (like gdb for example). Once you are in simulation mode you can open up your testbench and set breakpoints at various lines. The simulation will stop when it gets to those lines.

How do you set a breakpoint? It is pretty simple -- the large circles next to each executable line of testbench code are the breakpoint markers. Click one, it becomes solid colored, and you have now set a breakpoint at that line. Click it again, it becomes open, and you have unset the breakpoint.

----

# Other Resources To Learn More
If you have read this far, you are definitely interested in learning to simulate more effectively using testbenches.

Where to go to next? A web search for "verilog testbench" or "systemverilog testbench" will turn up many, many tutorials on the subject. But, some words of CAUTION are in order:

- There is, frankly, a lot of junk out there on the web regarding testbench design so be careful. For example, some will advocate changing the inputs at the rising of the clock (bad idea -- are you feeling lucky?).
- Many will attempt to fix the above bad practice using \#0 delays (don't even ask what that is for). Instead stick with what was shown above --- changing inputs on the falling edge of the clock is a commonly accepted practice that avoids a number of race problems.
- A final challenge you will have is that if you search for "systemverilog testbench" you will likely find some advanced materials on using the object oriented SystemVerilog features to create very sophisticated testbenches. While this is good, these might be beyond what you are looking for.

So, what to do to learn more? The basic structure above is perfectly fine for typical testbenches. Through the use of functions and tasks you can organize and make your testbenches even more efficient. Then, learn about SystemVerilog's data structures for simulation (arrays, queues, etc). Finally, learn about loops, file I/O, and the like.

If you would like to learn more, here are some ideas:

1. Read through the testbenches used in the 220 class labs. Most are written in basic Verilog but some are SystemVerilog. You can learn from all of them.
2. In the past we have taught SystemVerilog-based testing as a grad course in the department. Talk to the CpE faculty to learn more.
3. The very best book on the subject is: "SYSTEMVERILOG FOR VERIFICATION -- A Guide to Learning the Testbench Language Features", Third Edition by Spear and Tumbush, 2011. It is what we use in our class.
