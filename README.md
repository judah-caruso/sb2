# SB2

A stack-based VM implemented in Crystal.

# Disclaimer

SB2 is still very much a work in progress. Because of this, some things may not work
as expected. If you encounter anything out of the ordinary, please let me know!

# Information

SB2 works by pushing and popping values on and off a "Stack" (the primary container used to modify values),
and a "Heap" (a secondary container used to store values). The stack is where most
operations will take place (adding, subtracting, printing, etc). Because of this,
we need to utilize the heap to save values for later usage, as an iterator/placeholder for loops,
or to swap around values in our program.

# Requirements

* Crystal 0.27.2 (https://crystal-lang.org)
* LLVM 4.0.0

# Installation
1. Clone this github repository.
2. Run ``crystal build src/sb2.cr`` to create a binary.
3. Run ``sb2 [file.sb]`` to run an SB2 program.
4. You can also use ``crystal src/sb2.cr [file.sb]`` to run an SB2 program.

# Basics
TODO. For now look in the examples/ folder.

# Operations

Stack/heap quantity required = **2S:?H** -> At least 2 required in stack, any in heap  
Arguments for operation call = ? ? -> Minimum of 2 arguments required

  * HALT   : Exits the program. Required at the end of every program.
  * EXIT   : Syntactic sugar for HALT, used for exiting outside of the "main" label. Will have more specific uses in the future.
  * PUSH ? : Pushes a numeric (limted to integers for now) value to the stack.
  * POP    : **1S:?H** Removes the top-most stack value from the stack.
  * MSG  ? : Writes a value to STDOUT
  * IFEQ ? : **1S:?H** Executes the next instruction if true, skips if false.
  * IFNE ? : **1S:?H** Executes the next insturction if false, skips if true.
  * JUMP ? : **?S:?H** Jumps to a specific label (ex. JUMP :main). (examples/jump.sb)
  * ADD    : **2S:?H** Adds two values together. (examples/math-add.sb)
  * SUB    : **2S:?H** Subracts one value from another. (examples/math-sub.sb)
  * MUL    : **2S:?H** Multiples two values together. (examples/math-mul.sb)
  * DIV    : **2S:?H** Divides one value by another. (examples/math-div.sb)
  * DUP    : **1S:?H** Duplicates the top-most stack value. (examples/dup.sb)
  * SWAP   : **2S:?H** Swaps the positions of the first (top-most) and second values in the stack. (examples/swap.sb)
  * SAVE   : **1S:?H** Pushes the top-most stack value into the heap. Does *not* pop value off the stack. (examples/save-load.sb)
  * LOAD   : **?S:1H** Pushes the top-most heap value onto the stack. Removes the value from the heap. (examples/save-load.sb)
  * ROLS   : **2S:?H** Moves the top-most stack value to the bottom of the stack. (examples/roll.sb)
  * ROLH   : **?S:2H** Moves the top-most heap value to the bottom of the heap. (examples/roll.sb)
  * SHOW   : **?S:?H** Prints the current values of the stack and heap. (examples/show.sb)

# Contributing
1. Fork this repository (https://github.com/kyoto-shift/sb2/fork)
2. Create a branch (``git checkout -b my-fix-or-feature``)
3. Commit your changes (``git commit -m "Did a thing"``)
4. Push to the branch (``git push origin my-fix-or-feature``)
5. Create a new Pull Request
