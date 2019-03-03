module Sb2
  enum Instruction
    HALT  # Stops a program (exit)
    EXIT  # Alias for HALT
    PUSH  # Pushes a value to the stack
    JUMP  # Jump to label
    IFEQ  # Move to next instruction if equal
    IFNE  # Move to next insturction if not equal
    IFLE  # Move to next instruction if less than or equal
    IFME  # Move to next instruction if more than or equal
    ROLH  # Rolls the heap
    ROLS  # Rolls the stack
    REDO  # Re-does the current block
    ADD   # Adds the previous 2 values
    SUB   # Subtracts the previous 2 values
    MUL   # Multiplys the previous 2 values
    DIV   # Divides the previous 2 values
    SWAP  # Swaps the two top-most values
    MSG   # Writes to std.io
    SAVE
    LOAD
    POP   # Pops the top-most value off the stack
    SHOW  # Write top-most value of stack to io
    DUP   # Duplicates the top-most value onto the stack
    OR
    AND
    LABEL  # A compiler placeholder value for labels
    STRING # A compiler placeholder value for strings
    ALIAS  # A compiler placeholder value for aliases [$]
  end
end
