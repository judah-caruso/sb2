module Sb2
  class CPU
    getter program : Array(SType)
    getter ipointer : Int32 = 0
    getter linepointer : Int32 = 0
    getter mainpointer : Int32 = 0
    getter stack : Array(SType) = Array(SType).new()
    getter heap : Array(SType) = Array(SType).new()
    getter halted : Bool = false
    getter labels : Array(SType) = Array(SType).new()
    getter scope : Int32 = 0
    property io = IO::Memory.new()
    property va : String | Int32 | Nil = nil

    def initialize(inst)
      if inst.size <= 0
        raise InstructionError.new("Program needs at least 1 instruction!")
      end

      @program = inst
      checkForMain(@program)
      getLabels(@program)
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

      if @program[@ipointer].value == ERRORCODE::S
        raise InvalidProgramError.new("Program exited suddenly due to an error [#{@linepointer}]")
      end

      nextInstruction = getNextInstruction()
      decodeInstruction(nextInstruction)
    end

    def getNextInstruction() 
      if @ipointer >= @program.size
        printf("Status: No instruction left in program!\n")
        exit
      end

      nextInstruction = @program[@ipointer]

      @ipointer += 1
      @linepointer = @ipointer / 2

      if nextInstruction.type == "label"
        @scope = @ipointer
      end

      return nextInstruction
    end

    def checkInstructionArgument(ins, min)
      if @stack.size < min
        raise InvalidProgramError.new("Invalid number of instructions for '#{ins.unwrap}' [#{@linepointer}]. Expected: #{min}, received: #{@stack.size}")
        return false
      else
        return true
      end
    end

    def decodeInstruction(instruction)
      case instruction.unwrap
        when Instruction::HALT
          @halted = true
        when Instruction::EXIT
          @halted = true
        when Instruction::PUSH
          nv = getNextInstruction()
          @stack.push(nv)
        when Instruction::ADD
          checkInstructionArgument(instruction, 2) 
          
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::SUB
          checkInstructionArgument(instruction, 2) 
          
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::MUL
          checkInstructionArgument(instruction, 2) 
          
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::DIV
          checkInstructionArgument(instruction, 2) 
          
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::OR
          checkInstructionArgument(instruction, 2) 
          
          operation = doBinaryOp(instruction, @stack.pop, @stack.pop)
          @stack.push(SType.new(operation))
        when Instruction::POP
          checkInstructionArgument(instruction, 1) 
          
          @stack.pop()
        when Instruction::DUP
          checkInstructionArgument(instruction, 1) 
          
          n = @stack.first(1)[0]
          @stack.push(n)
        when Instruction::SAVE
          checkInstructionArgument(instruction, 1) 

          n = @stack.first(1)[0]
          @heap.push(n)
        when Instruction::LOAD 
          if @heap.size < 1
            raise InvalidProgramError.new("Attempt to load from empty heap [#{@linepointer}]")
          end
          
          n = @heap.first(1)[0]
          @stack.push(n)
          @heap.pop()
        when Instruction::SHOW
          @stack.each do |si|
            puts "Stack : %s" % si
          end
          @heap.each do |hi|
            puts "Heap : %s" % hi
          end
        when Instruction::MSG
          #checkInstructionArgument(instruction, 1)  

          str = @program[@ipointer]
          fin = ""

          if str.type == "alias"
            al = currentalias() || SType.new(ERRORCODE::S)
            fin += al.value.to_s 
          end

          if str.type == "string"
            str.raw.each do |c|
              fin += c.unsafe_chr
            end
            
            fin = fin.gsub(/(\\n|\\r|\\t)/, {
              "\\n": "\n", 
              "\\r": "\r",
              "\\t": "\t"
            })
          end

          STDOUT.puts(fin)
          @ipointer += 1
        when Instruction::SWAP
          checkInstructionArgument(instruction, 2) 

          v = @stack.first(2)
          top = v[0]
          sec = v[1]
          @stack.pop()
          @stack.pop()
          @stack.push(sec)
          @stack.push(top)
        when Instruction::JUMP

          i = @ipointer
          jump(i)
        when Instruction::IFEQ
          checkInstructionArgument(instruction, 1) 

          comparison = @program[@ipointer]
          comparator = @stack[0]
          
          if comparator.value == comparison.value
            @ipointer += 1
          else 
            @ipointer += 2
          end
        when Instruction::IFNE
          checkInstructionArgument(instruction, 1) 
          
          comparison = @program[@ipointer]
          comparator = @stack[0]
          
          if comparator.value != comparison.value
            @ipointer += 1
          else
            @ipointer += 2
          end
        when Instruction::ROLS
          if @stack.size <= 0
            raise InvalidProgramError.new("Attempt to roll empty stack [#{@linepointer}]")
          end

          roll(@stack)
        when Instruction::ROLH
          if @heap.size <= 0
            raise InvalidProgramError.new("Attempt to roll empty heap [#{@linepointer}]")  
          end

          roll(@heap)
        when Instruction::LABEL
          # do nothing (yet)
        else
          raise InstructionError.new("Unknown instruction: '#{instruction.unwrap}' [#{@linepointer}]")
      end
    end

    def getLabels(p)
      p.each do |line|
        if line.type == "label"
          @labels.push(line)
        end
      end
    end

    def checkForMain(p)
      startaddr = 0
      
      p.each do |line|
        if line.name == "main" && line.stackaddr != nil
          startaddr = line.stackaddr
        end
      end

      @ipointer = startaddr || 0
      @mainpointer = startaddr || 0
    end

    def compare(n1, o, n2)
      case o.to_s
      when "<"
        return n1.value < n2.value
      when ">"
        return n1.value > n2.value
      when "<="
        return n1.value <= n2.value
      when ">="
        return n1.value >= n2.value
      when "!="
        return n1.value != n2.value
      when "=="
        return n1.value == n2.value
      else
        return
      end
    end

    def jump(i)
      label = @program[i]

      if label != nil
        @ipointer = label.stackaddr || ERRORCODE::S
      end
    end

    def currentalias() 
      if @stack.size < 1
        raise InvalidProgramError.new("Attempt to reference null alias [#{@linepointer}]")  
      end

      @program.find { |label|
        if label.type == "alias"
          label = @stack[0]
          label.type = "alias"
          return label
        end
        }
    end

    def roll(arr)
      head = arr[0]
      arr.shift
      arr.push(head)
    end

    def doBinaryOp(instruction, n1, n2)
      # receives an instruction and two values of SType
      # then converts the values into their unwrapped form
      
      n1 = n1.value
      n2 = n2.value

      if typeof(n1) != Int32 || typeof(n2) != Int32
        raise ArgumentError.new("Invalid type in binary operation (#{@linepointer})")
      end

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
          raise ArgumentError.new("Invalid binary instruction '#{instruction.value}'")
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
