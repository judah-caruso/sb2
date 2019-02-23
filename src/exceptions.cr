module Sb2
  class InstructionError < Exception
    def initialize(message = "Program instruction error!")
      super(message)
    end
  end
  class InvalidProgramError < Exception
    def initialize(message = "Invalid program error!")
      super(message)
    end
  end
end
