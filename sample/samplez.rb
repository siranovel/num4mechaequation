require 'num4mechaequ'

class Num4MechaEquTest
    def initialize
        @k = 1.0
        @m = 1.0
        @h0 = 0.0
        @v0 = 1.0
    end
    def springFreqEquTest
        yi_1 = []
        yi_1 = Num4MechaEquLib.springFreqEqu(@k, @m, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
    end
end
 tst = Num4MechaEquTest.new
 tst.springFreqEquTest()

