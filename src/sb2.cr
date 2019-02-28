require "./exceptions"
require "./type"
require "./cpu"
require "./instructions"
require "./parser"
require "./compiler"

module Sb2
  parser = Parser.new
  compiler = Compiler.new

  if ARGV.size < 1
    raise ArgumentError.new("No file given to compiler!")
  end

  raw = parser.open(ARGV[0])
  instructions = compiler.transform(raw)

  cpu = CPU.new(instructions)
  cpu.run
end


