require 'num4mechaequ'

class Num4MechaEquTest
    def initialize
        @k = 1.0                       # バネ定数
        @c = 0.0                       # 空気抵抗
        @m = 1.0                       # 重りの重さ
        @h0 = 0.0                      # 初期位置
        @v0 = 1.0                      # 初期速度
        @theta = 5 * Math::PI / 180.0  # 角度
    end
    #
    # 自由落下による運動方程式テスト
    def freeFallMotionTest
        puts 'freeFallMotionTest in'
        yi_1 = []
        yi_1 = Num4MechaEquLib.freeFallMotion(@m, @c, 2, 0.0, 0.0)
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
        yi_1 = Num4MechaEquLib.projectileMotion(@m, @theta, 1, 0.0, 3.0)
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
        yi_1 = Num4MechaEquLib.SHM(@k, @m, 1, 1, 0)
        yi_1.map{ |v|
            print v
            puts
        }
        puts
    end
end
tst = Num4MechaEquTest.new
tst.SHMTest()
tst.freeFallMotionTest()
tst.projectileMotionTest()

