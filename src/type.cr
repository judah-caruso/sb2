module Sb2
  struct SType
    getter unwrap : Int32 | Sb2::Instruction

    def initialize(@unwrap)
    end
    
    def value
      return @unwrap.to_i
    end
  end
end
