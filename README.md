# asm_coprocessor
Wrote a program that implements Newton's one-parameter pole method for solving an equation.
The program must consist of modules in C++ and assembler, and input-output is carried out into the C++ module, and all components into the assembler module.
following special assembly procedures:
- calculation of the function that defines the final part of the equation;
- calculation (if required) of derivative functions;
-calculation associated with the solution method.
The input data are exact solutions. The output is the solutions and the number of iterations.
For the function and (if required) its derivatives, an estimate of the growth in the postfix notation is required (any deviations from it must be justified by an increase in efficiency). It is necessary to pay special attention to the competent use of the coprocessor stack.
