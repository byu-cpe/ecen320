---
layout: page
toc: true
title: Combinational Logic Styles
icon: fas fa-chalkboard-teacher
---

There are many different styles of SystemVerilog code that you can use to generate combinational circuits.

Consider the following logic function that outputs a 1 when an odd number of the three input bits are 1. (This is a 3-input XOR).

|in[2]|in[1]|in[0]|out|
|:-:|:-:|:-:|:-:|
|0	|0	|0	|0
|0	|0	|1	|1
|0	|1	|0	|1
|0	|1	|1	|0
|1	|0	|0	|1
|1	|0	|1	|0
|1	|1	|0	|0
|1	|1	|1	|1

```verilog
logic [2:0] in;
logic       out;

<Combinational Logic Here>
```

Assuming the above SystemVerilog code, there are many different ways to implement the same combinational logic. Here are some different examples.

----

## Structural SV
As a sum of products:

```verilog
logic [2:0] in_not;

not(in_not[0], in[0]);
not(in_not[1], in[1]);
not(in_not[2], in[2]);

and(term1, in_not[2], in_not[1], in[0]);
and(term2, in_not[2], in[1], in_not[0]);
and(term3, in[2], in_not[1], in_not[0]);
and(term4, in[2], in[1], in[0]);
or(out, term1, term2, term3, term4);
```

Minimized (single XOR gate):

```verilog
xor(out, in[2], in[1], in[0]);
```

## Dataflow SV
Using assign statement, and the ternary operator (also known as the ?: operator):
```verilog
assign out =
  (in==3’b000)?0:
  (in==3’b001)?1:
  (in==3’b010)?1:
  (in==3’b011)?0:
  (in==3’b100)?1:
  (in==3’b101)?0:
  (in==3’b110)?0:
  1;
```

Using assign statement, with sum of products, and dataflow operators:
```verilog
assign out = (~in[2] & ~in[1] & in[0]) | (~in[2] & in[1] & ~in[0]) |
             (in[2] & ~in[1] & ~in[0]) | (in[2] & in[1] & in[0]);
```

Using assign statement, vectored comparison operators, binary literals:
```verilog
assign out = (in == 3'b001) || (in == 3'b010) || (in == 3'b100) || (in == 3'b111);
```

Using assign statement, vectored comparison operators, decimal literals:
```verilog
assign out = (in == 3'd1) || (in == 3'd2) || (in == 3'd4) || (in == 3'd7);
```

## Behavioral SV
Using always_comb block with if statement:
```verilog
always_comb begin
    out = 1'b0;
    if ((in == 3'b001) || (in == 3'b010) || (in == 3'b100) || (in == 3'b111)) begin
        out = 1'b1;
    end else begin
        // This else isn't necessary because of the default value at the top, but is included here
        // to show you the syntax.
        out = 1'b0;
    end
end
```

Using always_comb block with case statement:
```verilog
always_comb begin
    out = 1'b0;
    case(in)
        3'b001: out = 1'b1;
        3'b010: out = 1'b1;
        3'b100:
            out = 1'b1;
        3'b111: begin
            out = 1'b1;
        end
        default: begin
            // This default isn't necessary because of the default value at the top, but is included here
            // to show you the syntax.
            out = 1'b0;
        end
    endcase
end
```

The example above mixes different formatting of the case statements to show you the variations available. Note: Similar to if and always blocks, you will need to include a `begin` and `end` if your case contains more than one statement.