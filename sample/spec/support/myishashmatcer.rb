# Hash
module MyIsHashMatcher
  #
  class Matcher
    def initialize(expected, n)
      @expected = expected
      @expectwk = expected
      @n = n
    end
    def matches?(actual)
        if actual.length != @expectwk.length then
            return false
        end
        ret = true
        @expectwk.each {|k, v|
          actv = actual[k]
          if ret == true then
            if actv.kind_of?(Hash) then
              @expectwk = v
              ret = matches?(actv)    
            end            
            if actv.kind_of?(Float) then
              ret = (v == actv.round(@n))
            end
          end
        } 
        @actual = actual
        return ret
    end
    def failure_message
      "#{@expected} expected but got #{@actual}"
    end
  end

  def is_hash(expected, n)
    Matcher.new(expected, n)
  end
end

