require 'num4simdiff'

#
# 数値計算による力学方程式の解法するライブラリ
#
module Num4MechaEquLib
    @g = 9.80665                       # 重力加速度(m/s2)
    @dt = 0.001                        # 時間刻み
    @w = 0.0
    @l = 0.0
    @ft = 0.0                          # 外力
    # 単振動
    @SHMFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = - @w * @w * yi[0]       # vの傾き値
        next f
    end
    # 自由落下運動
    @motionFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]                   # hの傾き値
        f[1] = @w * yi[1] - @g         # vの傾き値
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
    # 減衰振動
    @DHMFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]
        f[1] = - @l * yi[1] - @w * @w * yi[0] 
        next f
    end
    # 強制振動
    @forcedFunc = Proc.new do | n, yi |
        f = []
        f[0] = yi[1]
        f[1] = - @w * @w * yi[0] + @ft
        next f
    end 
    class << self

        # 単振動(simple harmonic motion)
        #
        # @overload SHM(m, k, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] k バネ定数
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   k = 1.0
        #   h0 = 1.0
        #   v0 = 0.0
        #   yi_1 = Num4MechaEquLib.SHM(m, k, 2, h0, v0)
        #
        def SHM(m, k, t, h0, v0)
            @w = Math.sqrt((k / m))
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(t, @dt) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @dt, @SHMFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt
        end
        # 自由落下による運動方程式(空気抵抗有り)
        #
        # @overload freeFallMotion(m, c, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] c 空気抵抗
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   c = 0.0
        #   h0 = 1.0
        #   v0 = 0.0
        #   yi_1 = Num4MechaEquLib.freeFallMotion(m, c, 2, h0, v0)
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
        # 放物運動
        #
        # @overload projectileMotion(m, theta, t, h0, v0)
        #   @param [double] m     重りの重さ
        #   @param [double] theta 角度(ラジアン指定)
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   theta = 5 * Math::PI / 180.0
        #   yi_1 = Num4MechaEquLib.projectileMotion(m, theta, 2, 0.0, 3.0)
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
        # 等速円運動(Uniform Circular motion)
        #
        # @overload UCM(m, r, w, t)
        #   @param [double] m 重りの重さ
        #   @param [double] r 半径
        #   @param [double] w 角速度
        #   @param [double] t 時間
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   r  = 3
        #   w  = 2
        #   yi_1 = Num4MechaEquLib.UCM(m, r, w, 2)
        #
        def UCM(m, r, w, t)
            hvt = []
            h = []
            v = []
            0.step(t, @dt) { |x|
              sinwt = Math.sin(w * x)
              coswt = Math.cos(w * x)
              h = [r * coswt, r * sinwt]
              v = [r * w * -sinwt, r * w * coswt]
              a = [-r * w * w * coswt, -r * w * w * sinwt]
              hvt.push({"t" => x, 
                        "x" => {"h" => h[0], "v" => m * v[0]},
                        "y" => {"h" => h[1], "v" => m * v[1]},
                       }
                      )
            }
            return hvt
        end
        # 振り子運動
        #
        # @overload pendulumMotion(m, l, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] l 糸の長さ
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   l  = 10
        #   h0 = 1.0
        #   v0 = 0.0
        #   yi_1 = Num4MechaEquLib.pendulumMotion(m, l, 2, h0, v0)
        #
        def pendulumMotion(m, l, t, h0, v0)
            return SHM(m, l, t, h0, v0)
        end
        # 減衰振動（damped harmonic motion)
        #
        # @overload DHM(m, k, b, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] k 比例定数
        #   @param [double] b 抵抗力の比例定数
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   k = 1.0
        #   h0 = 1.0
        #   v0 = 0.0
        #   yi_1 = Num4MechaEquLib.DHM(m, k, 0.6, 2, h0, v0)
        #
        def DHM(m, k, b, t, h0, v0)
            @l = 2 * m * b
            @w = Math.sqrt((k / m))
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(t, @dt) { |x|
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @dt, @DHMFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt
        end
        # 強制振動
        #
        # @overload forcedOscillation(m, k, w0, w, t, h0, v0)
        #   @param [double] m 重りの重さ
        #   @param [double] k 比例定数
        #   @param [double] w0 振動系の固有角振動
        #   @param [double] w 外力の角振動数
        #   @param [double] t 時間
        #   @param [double] h0 初期位置値
        #   @param [double] v0 初期速度
        #   @return [hash[]] 0秒からt秒までの位置(h)と速度(v)の値
        # @example
        #   m = 1.0
        #   k = 1.0
        #   f0 = 2.5
        #   h0 = 1.0
        #   v0 = 0.0
        #   yi_1 = Num4MechaEquLib.forcedOscillation(m, k, 0.6, f0, 2, h0, v0)
        #
        def forcedOscillation(m, k, w0, w, t, h0, v0)
            @w = Math.sqrt((k / m))
            hvt = []
            yi_1 = []
            yi = [h0, v0]
            0.step(t, @dt) { |x|
              @ft = w / m * Math.cos(w * x)
              yi_1 = Num4SimDiffLib.rungeKuttaMethod(yi, @dt, @forcedFunc)
              hvt.push({"t" => x, 
                        "h" => yi_1[0], "v" => m * yi_1[1]})
              yi = yi_1
            }
            return hvt
        end
    end
end

