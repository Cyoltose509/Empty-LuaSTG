LoadFX("fx:gray_color", "shader\\gray.hlsl")
LoadFX("fx:hue_set", "shader\\hue_set.hlsl")
LoadFX("fx:brightness_set", "shader\\brightness_set.hlsl")

function PostEffectGrayColor(tex, alpha, flag)
    flag = flag or 0.0
    PostEffect("fx:gray_color", tex, 6, "", {
        { alpha, flag, 0.0, 0.0 }
    }, {})
end

function PostEffectHueSet(tex, Hue, flag, open)
    flag = flag or 1
    open = open or 1.0
    PostEffect("fx:hue_set", tex, 6, "", {
        { Hue, flag, open, 0.0 }
    }, {})
end

function PostEffectBrightnessSet(tex, delta)
    PostEffect("fx:brightness_set", tex, 6, "", {
        { delta, 1, 1, 0.0 }
    }, {})
end