require 'num4simdiff'

#
# 数値計算による力学方程式の解法するライブラリ
#
module Num4MechaEquLib
    @g = 9.80665                       # 重力加速度
    @t = 0.001                         # 時間刻み
    @w = 0.0
    @springFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = @w * yi[0] - @g# vの傾き値
        next f
    end
    @motionFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = - @g                    # vの傾き値
        next f
    end
    class << self

        #
        # バネの固有振動
        # @overload springFreqEqu(k, m, h0, v0)
        #   @param [double] k バネ定数
        #   @param [double] m 重りの重さ
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒から1秒までの位置(h)と速度(v)の値
        #
        def springFreqEqu(k, m, h0, v0)
            @w = Math.sqrt((k / m))
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(1, @t) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @t, @springFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt
        end
        #
        # 自由落下による運動方程式(空気抵抗有り)
        # @overload motiEqu4freeFallEqu(m, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒から1秒までの位置(h)と速度(v)の値
        #
        def motiEqu4freeFallEqu(m, h0, v0)
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(1, @t) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @t, @motionFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt

        end
    end
end

