require 'num4simdiff'

#
# 数値計算による力学方程式の解法するライブラリ
#
module Num4MechaEquLib
    @g = 9.80665                       # 重力加速度(m/s2)
    @dt = 0.001                        # 時間刻み
    @w = 0.0
    # 単振動
    @springFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = - @w * @w * yi[0]       # vの傾き値
        next f
    end
    # 自由落下運動
    @motionFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = - @g + @w * yi[1]       # vの傾き値
        next f
    end
    # 放物運動
    @projectileXFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = 0                       # vの傾き値        
        next f
    end
    @projectileYFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = - @g                    # vの傾き値        
        next f
    end
    class << self

        #
        # 単振動(simple harmonic motion)
        # @overload SHM(k, m, t, h0, v0)
        #   @param [double] k バネ定数
        #   @param [double] m 重りの重さ
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        #
        def SHM(k, m, t, h0, v0)
            @w = Math.sqrt((k / m))
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(t, @dt) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @dt, @springFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt
        end
        #
        # 自由落下による運動方程式(空気抵抗有り)
        # @overload freeFallMotion(m, c, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] c 空気抵抗
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        #
        def freeFallMotion(m, c, t, h0, v0)
            @w = c / m
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(t, @dt) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @dt, @motionFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt

        end
        #
        # 放物運動
        # @overload projectileMotion(m, theta, t, h0, v0)
        #   @param [double] m     重りの重さ
        #   @param [double] theta 角度(ラジアン指定)
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        #
        def projectileMotion(m, theta, t, h0, v0)
            hvt = []
            yxi_1 = []
            yyi_1 = []
            yxi = [h0, v0 * Math.cos(theta)]
            yyi = [h0, v0 * Math.sin(theta)]
            0.step(t, @dt) { |x|
              yxi_1 = Num4SimDiffLib.rungeKuttaMethod(yxi, @dt, @projectileXFunc)
              yyi_1 = Num4SimDiffLib.rungeKuttaMethod(yyi, @dt, @projectileYFunc)
              hvt.push({"t" => x, 
                        "x" => {"h" => yxi_1[0], "v" => m * yxi_1[1]},
                        "y" => {"h" => yyi_1[0], "v" => m * yyi_1[1]},
                       }
                      )
              yxi = yxi_1
              yyi = yyi_1
            }
            return hvt
        end 
    end
end

