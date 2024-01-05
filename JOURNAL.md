# Things students trip up on
* Didn't do lab in order and so did all SV before simulated anything.  Gave problems with top
* Didn't understand simulation was hex
* Wrong part name due to video
* Forgot to change file types to SystemVerilog
* Implement circuits they are given verbatim (sim lab)
* Need to follow syntax in the book rather than thinking C syntax wll work

# Things to tell the TA's
* Taking off for ports being in a different order than specified seems extreme to me
* Otherwise, we want to be tough on the coding standard, including indentation, comments, etc.

# The Commandments of SV
1. Counter outputs cannot be in an always_ff block.  Why?
2. Stop trying to use your mod_counter for everything already...
3. Any assignment inside an always_ff will generate flip flops.  If that is not what you intended, don't put the assignment there.
4. CL doesn't contain flip flops.  Sequential logic does.  Learn the difference.
5. "cnt = cnt + 1" in an always_comb block is ALWAYS wrong.  All a FSM's always_comb can do is produce outputs in response to inputs.
6. [3:0] is not a type.  This is wrong:
    output logic done, [3:0] q

    This is right:
    output logic done, logic[3:0] q

    This is even better:
    output logic done,
    output logic[3:0] q
7. Indentation is not optional.
8. Follow the code samples in the book
9.
10.
