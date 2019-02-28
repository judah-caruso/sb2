require "./type"
require "./instructions"
require "./exceptions"

module Sb2
  class Compiler
    property program : Array(SType)

    def initialize
      @program = Array(SType).new
    end

    def transform(tree)
      cur = 0

      while cur <= tree.size - 1
    
        # if our current value is not a number
        if tree[cur].to_i { nil } == nil

          if tree[cur].includes?("$")
            a = SType.new(Instruction::ALIAS)
            a.type = "alias"

            @program.push(a)
            cur += 1
          end

          # if we find a string
          if tree[cur].includes?('"')
            str = tree[cur]

            if !str.ends_with?('"')
              str += " "
              cur += 1

              while !tree[cur].includes?('"')
                str += tree[cur] + " "
                cur += 1
              end
            
              if tree[cur].includes?('"')
                str += tree[cur]
              end

              str = str.chomp
            end
            
            if !str.ends_with?('"')
              raise InvalidProgramError.new("Unclosed string literal (#{str})")
            end

            m = SType.new(Instruction::STRING)
            
            str.bytes.each do |c|
              m.raw.push(c)
            end

            m.raw.pop
            m.raw.shift
            m.type = "string"
            
            @program.push(m)

            cur += 1
          end

          # if we've received a label declaration
          if tree[cur].split("").last(1)[0] == ":"
            label = SType.new(Instruction::LABEL)
            label.type = "label"
            label.name = tree[cur].rchop
            label.stackaddr = cur

            @program.push(label)
            cur += 1
          end
          
          # if we've received a label invocation
          if tree[cur].split("").first(1)[0] == ":"
            
            @program.each do |line|
              if line.name.to_s == tree[cur].lchop.to_s
                la = SType.new(Instruction::LABEL)
                i = line.stackaddr || 0

                la.type = "label"
                la.stackaddr = i
                la.name = line.name

                @program.push(la)
                break
              end
            end
          else
            cmd = Instruction.parse(tree[cur])
            @program.push(SType.new(cmd))
          end
        else
          cmd = SType.new(tree[cur].to_i)
          @program.push(cmd)
        end

        cur += 1
      end

      if @program.last(1)[0].unwrap != Instruction::HALT
        raise InvalidProgramError.new("Program is missing final 'HALT' command")
      end

      return @program
    end
  end
end
