require 'spec_helper'
require 'num4mechaequ'

RSpec.describe Num4MechaEquLib do
    before do
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
    it '#freeFallMotion' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.freeFallMotion(@m, @c, 2, @h0, @v0)
        res = {"t" => 2.0, "h" => 3.5184, "v" => -8.4363}
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#projectileMotion' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.projectileMotion(@m, @theta, 2, 0.0, 3.0)
        res = {
         "t"=>2.0, 
         "x"=>{"h"=>5.2821, "v"=>15.8358},
         "y"=>{"h"=>-1.3182, "v"=>-7.0509}
        }
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#SHM' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.SHM(@m, @k, 2, @h0, @v0)
        res = {"t" => 2.0, "h" => 5.0069, "v" => -1.7349}
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#UCM' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.UCM(@m, @r, @w, 2)
        res = {
         "t"=>2.0, 
         "x"=>{"h"=>-1.9609, "v"=>4.5408},
         "y"=>{"h"=>-2.2704, "v"=>-3.9219}
        }
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#pendulumMotion' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.pendulumMotion(@m, @l, 2, @h0, @v0)
        res = {"t" => 2.0, "h" => 2.6152, "v" => -14.5785}
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#DHM' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.DHM(@m, @k, 0.6, 2, @h0, @v0)
        res = {"t" => 2.0, "h" => 5.0421, "v" => -1.4299}
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
    it '#forcedOscillation' do
        yi_1 = []
        yi_1 = Num4MechaEquLib.forcedOscillation(@m, @k, 0.6, @f0, 2, @h0, @v0)
        res = {"t" => 2.0, "h" => 5.1385, "v" => -1.6533}
        expect(
            yi_1.last
        ).to is_hash(res, 4)
    end
end

