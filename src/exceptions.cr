module Sb2
  struct ERRORCODE
    S = -2
  end

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
