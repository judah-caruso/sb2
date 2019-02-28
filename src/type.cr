module Sb2
  struct SType
    getter unwrap : Int32 | String | Sb2::Instruction
    property type : String
    property stackaddr : Int32 | Nil
    property name : String | Nil
    property raw : Array(UInt8)

    def initialize(@unwrap)
      @type = "instruction"
      @name = nil
      @stackaddr = nil
      @raw = Array(UInt8).new()
    end
    
    def value
      return @unwrap.to_i
    end

  end
end
