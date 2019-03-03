require "./spec_helper"

module Sb2
  describe Sb2::Instruction do 
    # If value equals do
    it "IFEQ works properly" do
      raw = [
        "PUSH", "1",
        "PUSH", "2",
        "ADD",
        "IFEQ", "3",
        "EXIT",
        "POP",
        "HALT"
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
  
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should eq 3
    end
    
    # If value isn't equal do
    it "IFNE works properly" do
      raw = [
        "PUSH", "1",
        "PUSH", "2",
        "ADD",
        "IFNE", "1",
        "EXIT",
        "PUSH", "99",
        "HALT"
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
  
      cpu.stack.size.should be <= 1
      cpu.stack[0].value.should eq 3
    end

    # If value is less than equal do
    it "IFLE works properly" do
      raw = [
        "PUSH", "2", 
        "PUSH", "2",
        "SUB",
        "IFLE", "0",
        "EXIT",
        "PUSH", "100",
        "HALT"]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should be <= 0
    end
    
    # If value is more than equal do
    it "IFME works properly" do
      raw = [
        "PUSH", "1",
        "PUSH", "2",
        "ADD",
        "IFME", "3",
        "EXIT",
        "PUSH", "100",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should be >= 3
    end

    # Swap stack values
    it "SWAP properly swaps the first two values on the stack" do
      raw = [
        "PUSH", "1",
        "PUSH", "2",
        "SWAP",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should eq 2
      cpu.stack[1].value.should eq 1
    end
    
    # Save value to heap
    it "SAVE properly saves a new value into the heap" do
      raw = [
        "PUSH", "1",
        "SAVE",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.stack.size.should_not eq 0
      cpu.heap[0].value.should eq 1
    end
    
    # Load value from heap
    it "LOAD properly pushes and deletes value" do
      raw = [
        "PUSH", "1",
        "SAVE",
        "POP",
        "LOAD",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.heap.size.should eq 0
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should eq 1
    end
    
    # Roll stack
    it "ROLS properly modifies the stack" do
      raw = [
        "PUSH", "0",
        "PUSH", "1",
        "PUSH", "2",
        "ROLS",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run
      
      cpu.stack.size.should_not eq 0
      cpu.stack[0].value.should eq 1
      cpu.stack[1].value.should eq 2
      cpu.stack[2].value.should eq 0
    end

    # Roll heap
    it "ROLH properly modifies the heap" do
      raw = [
        "PUSH", "0",
        "SAVE", "POP",
        "PUSH", "1",
        "SAVE", "POP",
        "PUSH", "2",
        "SAVE", "POP",
        "ROLH",
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run

      cpu.stack.size.should eq 0
      cpu.heap.size.should be >= 3
      cpu.heap[0].value.should eq 1
      cpu.heap[1].value.should eq 2
      cpu.heap[2].value.should eq 0
    end

    # Send message to stdout
    it "MSG properly outputs a string to stdout -> " do
      message = "\"Hello, Sb2 sent this!\""
      # Simulate what the compiler does to the string literal
      byte_array = message.bytes
      byte_array.pop
      byte_array.shift

      raw = [
        "MSG", message,
        "HALT",
      ]
      compiler = Compiler.new
      instructions = compiler.transform(raw)
      cpu = CPU.new(instructions)
      cpu.run

      cpu.stack.size.should eq 0
      cpu.heap.size.should eq 0
      cpu.program[1].raw.should eq byte_array
    end
  end
end
