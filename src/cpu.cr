module Sb2
  class CPU

    getter program : Array(SType)
    getter ipointer : Int32 = 0
    getter stack : Array(SType) = Array(SType).new()
    getter halted : Bool = false
    
    def initialize(inst)
      if inst.size <= 0
        raise InstructionError.new("Program needs at least 1 instruction!")
        exit
      end

      @program = inst
    end

    def run()
      while !@halted
        step()
      end
    end

    def step()
      if @halted
        raise InstructionError.new("Cannot run instruction while halted")
      end

      nextInstruction = getNextInstruction()
      decodeInstruction(nextInstruction)
    end

    def getNextInstruction()
      if @ipointer >= @program.size
        printf("Status: No instruction left in program!")
        exit
      end
      
      nextInstruction = @program[@ipointer]
      @ipointer += 1
      
      return nextInstruction
    end

    # Definitely needs to be refactored in the future
    def decodeInstruction(instruction)
      case instruction.unwrap
        when Instruction::HALT
          @halted = true
        when Instruction::PUSH
          nv = getNextInstruction()
          @stack.push(nv)
        when Instruction::ADD
          if @stack.size < 2 
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 2, recieved: #{@stack.size}") 
          end
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::SUB
          if @stack.size < 2 
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 2, recieved: #{@stack.size}") 
          end
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::MUL
          if @stack.size < 2 
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 2, recieved: #{@stack.size}") 
          end
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::DIV
          if @stack.size < 2 
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 2, recieved: #{@stack.size}") 
          end
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::OR
          if @stack.size < 2 
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 2, recieved: #{@stack.size}") 
          end
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::POP
          if @stack.size < 1
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 1, recieved: #{@stack.size}") 
          end
          @stack.pop()
        when Instruction::DUP
          if @stack.size < 1
            raise InvalidProgramError.new("Invalid number of instructions for '#{instruction.unwrap}'. Expected: 1, recieved: #{@stack.size}") 
          end
          n = @stack.first(1)[0]
          @stack.push(n)
        else
          raise InstructionError.new("Unknown instruction '#{instruction.value}'")
      end
    end

    def doBinaryOp(instruction, n1, n2)
      # receives an instruction and two values of SType
      # then converts the values into their unwrapped form
      
      n1 = n1.value
      n2 = n2.value

      case instruction.unwrap
        when Instruction::ADD
          return n1 + n2
        when Instruction::SUB
          return n1 - n2
        when Instruction::MUL
          return n1 * n2
        when Instruction::DIV
          return n1 / n2
        when Instruction::OR
          return toBool(n1) || toBool(n2)
        when Instruction::AND
          return toBool(n1) && toBool(n2)
        else
          raise ArgumentError.new("Invalid binary instruction '#{instruction.value}'!")
        end
    end

    def toBool(n)
      if n != 0
        return 1
      end

      return n
    end
  end
end
