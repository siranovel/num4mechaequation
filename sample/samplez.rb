require 'num4mechaequ'

class Num4MechaEquTest
    def initialize
        @k = 1.0                       # バネ定数
        @c = 0.0                       # 空気抵抗
        @m = 1.0                       # 重りの重さ
        @h0 = 1.0                      # 初期位置
        @v0 = 0.0                      # 初期速度
        @theta = 5 * Math::PI / 180.0  # 角度
        @l  = 10                       # 糸の長さ
        @r  = 3                        # 半径
        @w  = 2                        # 角速度
        @f0 = 2.5                      # 強制振動外力
    end
    #
    # 自由落下による運動方程式テスト
    def freeFallMotionTest
        puts 'freeFallMotionTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.freeFallMotion(@m, @c, 2, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
    #
    # 放物運動
    def projectileMotionTest
        puts 'projectileMotionTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.projectileMotion(@m, @theta, 2, 0.0, 3.0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end

    #
    # 単振動テスト
    def SHMTest
        puts 'SHMTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.SHM(@m, @k, 2, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
    #
    # 等速円運動
    def UCMTest
        puts 'UCMTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.UCM(@m, @r, @w, 2)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
    #
    # 振り子運動テスト
    def pendulumMotionTest
        puts 'pendulumMotionTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.pendulumMotion(@m, @l, 2, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
    #
    # 減衰振動
    def DHMTest
        puts 'DHMTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.DHM(@m, @k, 0.6, 2, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
    #
    # 強制振動
    def forcedOscillationTest
        puts 'forcedOscillationTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.forcedOscillation(@m, @k, 0.6, @f0, 2, @h0, @v0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
end
tst = Num4MechaEquTest.new
#tst.freeFallMotionTest()
#tst.projectileMotionTest()
#tst.SHMTest()
#tst.UCMTest()
#tst.pendulumMotionTest()
#tst.DHMTest()
tst.forcedOscillationTest()


