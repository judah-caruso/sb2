require "./instructions"

module Sb2
  class Parser
    @COMMENT_CHAR = "//"
    @LABEL_CHAR = ":"
    @STRING_CHAR = "\""
    @CHAR_CHAR = "\'"
    @ALIAS_CHAR = "$"

    property lines : Array(String)

    def initialize
      @lines = Array(String).new
    end

    def open(f)
      file = File.open(f) do |c|
        c.each_line do |fileline|
          tokens = fileline.split(/\s/, remove_empty: true)
          
          # if we find a blank line
          if tokens.size == 0
            tokens.clear
            next
          end

          # if we find whitespace characters starting a line
          if tokens[0][0].ascii_whitespace?
            tokens.each do |tkn|
              if !Instruction.names.includes?(tkn)
                tokens.clear
                next
              end
            end
          end

          # if we find a comment starting a line
          if tokens[0].includes?(@COMMENT_CHAR)
            tokens.clear
            next
          end

          # if we find a label
          if tokens[0].split("").last(1)[0] == @LABEL_CHAR
            @lines.push(tokens[0])
            next
          end

          if Instruction.names.includes?(tokens[0])
            valid_tokens = Array(String).new()
            cur = 0

            # loop through all tokens unless we find a comment start
            while cur <= tokens.size - 1 && tokens[cur] != @COMMENT_CHAR
              valid_tokens.push(tokens[cur])
              cur += 1
            end

            valid_tokens.each do |token|  
              @lines.push(token)
            end
          else
            raise InstructionError.new("Unrecognized instruction '#{tokens[0]}'!")
          end
        end
      end

      return @lines
    end
  end
end
