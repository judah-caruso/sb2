require "./exceptions"
require "./type"
require "./cpu"
require "./instructions"

module Sb2
  
  instructions = 
    [
     SType.new(Instruction::PUSH),
     SType.new(0),
     SType.new(Instruction::PUSH),
     SType.new(2),
     SType.new(Instruction::OR),
     SType.new(Instruction::HALT)
    ]

  cpu = CPU.new(instructions)
  cpu.run()
 
  puts cpu.stack
end
