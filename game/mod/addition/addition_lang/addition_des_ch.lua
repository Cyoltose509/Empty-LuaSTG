local t = stg_levelUPlib.tagslist
local GongFeng = Trans("addition", "GongFeng")

return {
    {
        [28] = {
            stitle = [[碎心难圆]],
            sdes = [[自机被弹（包括体术）时无论如何都是§b扣除33%的生命值]],
            detail = [[自机被弹（包括体术）时
无论如何都是§b扣除33%的生命值§d]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[暴力退出过§p1§d次游戏]],
            condd = nil,
        },
        [36] = {
            stitle = [[纯粹的游戏]],
            sdes = [[将符卡改为§p一段时间的无敌§d，且§r无法射击]],
            detail = [[记§ya=1§d, §yb=原符卡给予的无敌时间
将符卡的效果§r取消§d，改为获得§pb*(1.6+0.4*a)秒§d的无敌
释放符卡时，§r不能射击§d，移速倍率§g+50%]],
            repeatd = [[§ya§d+1
降低§r0.3§d倍获得权重]],
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [39] = {
            stitle = [[心体合一]],
            sdes = [[擦弹范围修改至判定点的§b1.86§d倍
且判定点大小§r+0.5§d，判定点倍率§r+100%§d]],
            detail = [[擦弹范围修改至判定点的§b1.86§d倍
判定点大小§r+0.5§d，判定点大小倍率§r+100%]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[改变过§p1§d次判定大小]],
            condd = nil,
        },
        [43] = {
            stitle = [[奇变偶也变]],
            sdes = [[波数为偶数时混沌值每秒§g-0.1%§d，
为奇数时每秒§b+0.1%§d]],
            detail = [[波数为偶数时混沌值每秒§g-0.1%§d，
为奇数时每秒§b+0.1%§d]],
            repeatd = nil,
            tags = t.chaos,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [46] = {
            stitle = [[千里之行]],
            sdes = [[高速速度§b-0.3§d，低速速度§b+0.3§d
高低移速将不会低于拾取此道具后的面板数值]],
            detail = [[高速速度§b-0.3§d，低速速度§b+0.3§d
高低移速将不会低于拾取此道具后的面板数值]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [48] = {
            stitle = [[喋血反击!]],
            sdes = [[敌怪死亡时，会向自机§r发射子弹]],
            detail = [[敌怪死亡时，发射1条§r3颗§d的自机狙弹链]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = [[每拥有1个§p"献祭"§d标签的道具，自机狙弹链颗数§r+1
§b见血封喉术§d：向反方向发射弹链]],
            unlockd = [[累计杀死§p1000§d个敌人]],
            condd = nil,
        },
        [54] = {
            stitle = [[小小贤者的力量]],
            sdes = [[屏幕两端出现隙间，能够传送自机，敌人，子弹等
敌人进入隙间后，对其造成§g350%攻击力§d的伤害]],
            detail = [[屏幕两端出现诡异的隙间，能够传送自机，敌人，子弹等
敌人进入隙间后，对其造成§b350%§d攻击力的伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[击败1次§p"八云紫"]],
            condd = nil,
        },
        [56] = {
            stitle = [[转逆]],
            sdes = [[攻击力倍率§g+50%§d，主炮将§r朝后发射
使§r"逆转"§d天气无效化]],
            detail = [[攻击力倍率§g+50%
§r主炮将朝后发射
使§r"逆转"§d天气无效化]],
            repeatd = nil,
            tags = nil,
            collabd = [[§b女仆飞刀§d：飞刀将从上往下发射
§p冰之妖精§d：改为在自机头顶生成子机
§p大促销：神子牌令牌§d：激光将向下发射
§g背扉的秘国§d：改为在自机前方生成门扉
§g寂静的冬天§d：雪花将从下往上飘“落”
§g寂静的冬天§d+§g太阳表面§d：雪花出现时就会融化
§p冰之鳞§d：低速时，波纹弹将向下发射
§p绯红的专注§d：针弹将向下发射
§g火鼠的皮衣§d：移动时，将同向发射火焰弹
§p蓬莱的玉枝§d：七色珠一开始将向上发射
§g小小星之伞§d：改为在自机下方生成伞]],
            unlockd = [[见过一次§-"逆转"§d天气]],
            condd = nil,
        },
        [83] = {
            stitle = [[……]],
            sdes = [[选择的道具有§b20%§d概率§r随机变成其他道具]],
            detail = [[选择的道具有§b20%§d概率§r随机变成其他道具]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [88] = {
            stitle = [[玩转偏向力]],
            sdes = [[弹速§g+0.3
主炮弹幕获得等同于自机速度的方向与大小的速度向量]],
            detail = [[弹速§g+0.3
主炮弹幕发射时
获得等同于自机速度的方向与大小的速度向量]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [98] = {
            stitle = [[回收旧手机，旧电脑......]],
            sdes = [[每波开始时，获得一个§g裨益§d、§b交易§d或§r侵害]],
            detail = [[每波开始时，获得一个§g裨益§d、§b交易§d或§r侵害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [102] = {
            stitle = [[里世界直通车]],
            sdes = [[下次更换季节时，一定会变成§y「里」
生效一次后§-损坏]],
            detail = [[下次更换季节时，一定会变成§y「里」
生效一次后损坏]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[遇到过一次§-「里」§d季节]],
            condd = [[存在§p季节系统]],
        },
        [107] = {
            stitle = [[它渴望鲜血]],
            sdes = [[恢复§g10§d生命值
按下x键(Bomb键)时会§b瞬移到离自机最近的敌人处]],
            detail = [[恢复§g10§d生命值
按下x键(Bomb键)时会获得§b7帧§d无敌，并§b瞬移到离自机最近的敌人处
冷却时间§b12帧]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [134] = {
            stitle = [[世界崩坏]],
            sdes = [[§g获得§d\§-损坏§d\§r失去§d该道具后，除了该道具以外
§b依次将所有道具§-(临时道具除外)§d替换成其他随机道具]],
            detail = [[§g获得§d\§-损坏§d\§r失去§d该道具后，除了该道具以外
§b依次将所有道具§-(临时道具除外)§d替换成其他随机道具]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [136] = {
            stitle = [[幸福今生]],
            sdes = [[本场游戏中，§g每次升级时额外出现一个选项
结算时若持有该道具，下一局游戏开始时获得道具§r"永恒的回音"]],
            detail = [[本场游戏中，§g每次升级时额外出现一个选项
结算时若持有该道具，下一局游戏开始时获得道具§r"永恒的回音"]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-永恒的回音§d具体效果：
上一局游戏获取了§b"无间之钟"§d之后，该道具便会§r强制初始携带
混沌值§r+25%§d，阻止道具§b"无间之钟"§d出现
升级时，有§r13%§d概率获得一个侵害
经验获取倍率§g+20%
仅§r当携带该道具通关§d时，下一局游戏才不再携带该道具]],
            unlockd = nil,
            condd = [[不会在挑战模式中出现]],
        },
        [137] = {
            stitle = [[无间]],
            sdes = [[混沌值§r+25%§d，经验获取倍率§g+20%§d，阻止道具§b"无间之钟"§d出现
升级时，有§r13%§d概率获得一个侵害]],
            detail = [[上一局游戏结算时若拥有§b"无间之钟"§d，该道具便会§r强制初始携带
混沌值§r+25%§d，阻止道具§b"无间之钟"§d出现
升级时，有§r13%§d概率获得一个侵害
经验获取倍率§g+20%
仅§r当携带该道具通关§d时，下一局游戏才不再携带该道具]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[不自然出现]],
        },
        [142] = {
            stitle = [[物极必反]],
            sdes = [[自机移速§r-0.25§d，主炮弹幕将持续获得§b向自机方向的加速度
离自机越远，加速度越大]],
            detail = [[自机移速§r-0.25§d，主炮弹幕将持续获得§b向自机方向的加速度
离自机越远，加速度越大
掉落物将受到自机微弱的§g吸引力]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [143] = {
            stitle = [[Friend to The End]],
            sdes = [[获得一个红色幽灵追随于自机
§r拥有体术伤害§d，§b阻挡敌我双方子弹]],
            detail = [[获得一个红色幽灵追随于自机
初始生成时不拥有体术伤害，
当幽灵与自机分离时§r拥有体术伤害§d，§b且阻挡敌我双方子弹]],
            repeatd = nil,
            tags = { t.defend, t.baby, },
            collabd = [[§b金刚不灭之身§d：幽灵不拥有伤害，且不阻挡任何子弹]],
            unlockd = GongFeng,
            condd = nil,
        },
        [151] = {
            stitle = [[本是同根生，就是要相煎]],
            sdes = [[阻止所有§-0级道具§d出现]],
            detail = [[阻止所有§-0级道具§d出现]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [153] = {
            stitle = [[除夕快乐给大家送一个大回环]],
            sdes = [[射程§g+7§d,射程倍率§g+177%
角色发射的主炮会§b不断旋转]],
            detail = [[射程§g+7§d,射程倍率§g+177%
角色发射的主炮会§b不断旋转]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [158] = {
            stitle = [[结构式错误]],
            sdes = [[主炮变为§y特殊主炮
§-*该主炮能获得意义不明的特性*]],
            detail = [[自机主炮变为§y特殊主炮§d，随机获得以下§b1~2§d种特性：
主炮贴图大小§b*50%~200%
主炮伤害§b*0%~250%
主炮弹速§b*25~50%
主炮射程§b*50%~200%
主炮颜色§b随机]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
    {
        [2] = {
            stitle = [[轻量，快捷，更方便！]],
            sdes = [[符卡所需能量§g-7%]],
            detail = [[§g符卡所需能量-7%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[一局游戏内释放§p5次§d符卡]],
            condd = nil,
        },
        [5] = {
            stitle = [[丰收的喜悦]],
            sdes = [[每秒恢复微量生命值]],
            detail = [[记§ya=1
每帧恢复§ga*0.1/60§d生命值]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [6] = {
            stitle = [[神风！]],
            sdes = [[自机被弹时会发生较大范围爆炸
消除敌弹且对敌人造成伤害]],
            detail = [[记§ya=1
自机被弹时产生持续§b45帧§d的消弹圈，
半径为§ga*75§d，每帧造成§b10%a攻击力§d伤害]],
            repeatd = [[§ya§d+1]],
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [20] = {
            stitle = [[防御性攻击]],
            sdes = [[自机处于无敌状态时，攻击力§g+35%]],
            detail = [[记§ya=1
自机处于无敌状态时，攻击力§g+a*35%]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [23] = {
            stitle = [[嗜血狂怒]],
            sdes = [[生命值百分比越低，敌人受到的伤害越高]],
            detail = [[记§ya=1§d, §yp=当前生命/生命上限
敌人受到的伤害倍率为§g1+(1-p)*(0.5+a/3)
§-该伤害倍率不会显示在攻击力面板中]],
            repeatd = [[§ya§d+1]],
            tags = t.sacrifice,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [35] = {
            stitle = [[喵喵喵！好运来！]],
            sdes = [[每通过一波，根据当前幸运值§g增加幸运值]],
            detail = [[记§ya=幸运值
每通过一波，幸运值增加§g(-a+100)/60§d，最大增加§b1]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [38] = {
            stitle = [[别人看不到你]],
            sdes = [[判定点大小§g减小§d，同时自机贴图变得§r透明]],
            detail = [[记§ya=1
判定点§g-0.1a
自机贴图不透明度倍率§r-a*33%]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [49] = {
            stitle = [[幻想的山之风]],
            sdes = [[自机移速§b+0.25
每当敌怪发弹时，有§g5%§d概率使子弹变为半透明，§g失去判定]],
            detail = [[记§ya=1
自机移速§b+0.25a
每当敌怪发弹时，有§g5a%§d概率使子弹变为半透明，§g失去判定]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [57] = {
            stitle = [[重度收集狂]],
            sdes = [[每当拾取经验点时，随机触发§g有益效果
多次拾取时解锁更多§g有益效果]],
            detail = [[每当拾取经验点时，随机触发以下效果：
生命值§g+0.03§d, 经验值§g+0.2§d, 分数§g+0.01%
符卡槽§g+0.2%§d, 经验值§g+0.5§d, 幸运值§g+0.004§-(2)
生命值§g+0.08§d, 攻击力§g+0.01§d, 生命上限§g+0.02§-(3)]],
            repeatd = [[叠加2个时解锁§-(2)§d，叠加3个时解锁§-(3)]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [59] = {
            stitle = [[后户之国]],
            sdes = [[增加一个后户之门在自机后方，碰到此子机的弹幕将被§g消除]],
            detail = [[增加一个后户之门子机
在自机后方碰到此子机的弹幕§g将被消除]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [60] = {
            stitle = [[连接月与海]],
            sdes = [[自机周围的空间出现坍缩
靠近自机的弹幕有§b20%§d概率被§b传送到屏幕的任意位置]],
            detail = [[靠近自机的弹幕有§b20%§d概率被§b传送到屏幕的任意位置
被传送的弹幕的速度、方向等保持不变]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[击败1次§p"八云紫"]],
            condd = nil,
        },
        [70] = {
            stitle = [[地上太阳]],
            sdes = [[在版底形成一个"太阳"，为了躲避"太阳"
敌人、敌方子弹和经验点等都有§b向上运动的趋势]],
            detail = [[在版底形成一个太阳
有"生命体征"的敌人、敌方子弹和经验点等
§b都有向上运动的趋势，碰到版底时直接消除
§-他们都不想被太阳消灭！]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [75] = {
            stitle = [[密葬]],
            sdes = [[所有大玉都§g不再对自机造成伤害]],
            detail = [[所有大玉都§g不再对自机造成伤害]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-Blood Magic§d：所有大玉变为红色]],
            unlockd = nil,
            condd = nil,
        },
        [79] = {
            stitle = [[以牙还牙]],
            sdes = [[每当自机失去生命时，对所有敌怪造成§g35%攻击力§d的伤害
有§b1.0秒§d的冷却时间]],
            detail = [[每当自机失去生命时，对所有敌怪造成§g35%攻击力§d的伤害
有§b60帧§d的冷却时间]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = nil,
            unlockd = [[死亡§p1§d次]],
            condd = nil,
        },
        [82] = {
            stitle = [[静海浮月]],
            sdes = [[§g允许自机移动到版外§d，但会出现强大的斥力让自机回到版内
自机移速§b+0.35]],
            detail = [[§g允许自机移动到版外
在版外待的越久，会出现越强大的斥力让自机回到版内
自机移速§b+0.35]],
            repeatd = nil,
            tags = t.tp,
            collabd = nil,
            unlockd = [[获得过§g"损坏的空间"]],
            condd = nil,
        },
        [91] = {
            stitle = [[自动式全方位射击]],
            sdes = [[场上每出现§b110§d颗主炮，自机发射主炮开花弹]],
            detail = [[记§ya=1
场上每出现§b110§d颗主炮弹幕，
自机发射条数§g9a§d的主炮开花弹]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [92] = {
            stitle = [[北风萧萧]],
            sdes = [[敌人死亡时，从版顶飘落雪花，每片雪花造成§g1+25%攻击力§d伤害]],
            detail = [[敌人死亡时，从版顶飘落§b1~2§d片雪花，每片雪花造成§g1+25%攻击力§d伤害
§-屏幕上方微微变蓝]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-Blood Magic§d：雪花变为粉红色
§g太阳表面§d：雪花飘过版中时透明度不断降低直至消失]],
            unlockd = [[一局游戏内拥有§b"⑨之祝福"§d和§p"冰之妖精"]],
            condd = nil,
        },
        [95] = {
            stitle = [[可怖的注视]],
            sdes = [[生成3个赤蛮奇的头，自动寻找并围绕着敌人外部旋转
每秒造成§g960%攻击力§d的伤害]],
            detail = [[生成§b3§d个赤蛮奇的头，它们自动寻找并围绕着敌人外部旋转
每帧造成§g16%攻击力§d伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [97] = {
            stitle = [[五色的弹丸]],
            sdes = [[环绕一名敌人发射五色风车弹，每颗造成§g20%攻击力§d伤害]],
            detail = [[选中一个敌人，使其每§b5帧§d向外发射五色的环玉风车弹
每颗弹造成§g20%攻击力§d伤害]],
            repeatd = nil,
            tags = t.neet,
            collabd = [[§b具现化记忆§d：当风车弹达到面板§b50%§d射程时，将反转速度方向]],
            unlockd = [[收取§p"神宝「耀眼的龙玉」"]],
            condd = nil,
        },
        [99] = {
            stitle = [[不焦躁的内心]],
            sdes = [[移动时向后发射火焰弹，每颗造成§g48%攻击力§d的伤害]],
            detail = [[每当自机移动时，每§b3帧§d向反方向发射微型火弹
火弹对敌怪造成§g48%攻击力§d伤害]],
            repeatd = nil,
            tags = t.neet,
            collabd = [[§p不死的尾羽§d：重生后，生成火焰弹的间隔减小，最小为§g1帧§d
§p引诱的黄泉§d：火焰弹获得小范围的§p追踪效果]],
            unlockd = [[收取§p"神宝「火蜥蜴之盾」"]],
            condd = nil,
        },
        [103] = {
            stitle = [[我离太阳越来越远了吗？]],
            sdes = [[所有季节时长§b延长1波]],
            detail = [[所有季节时长§b延长1波]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[通过§b"静海"§d场景]],
            condd = [[存在§p季节系统]],
        },
        [104] = {
            stitle = [[天气之子]],
            sdes = [["祥瑞"类的天气出现的概率提高§g25%]],
            detail = [["祥瑞"类的天气出现的概率§g提高25%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[存在§p季节系统]],
        },
        [109] = {
            stitle = [[可控的未来]],
            sdes = [[消除弹幕时，随机消除§g1§d颗同弹型的弹幕]],
            detail = [[消除弹幕时，§g随机消除1颗同弹型的弹幕]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [110] = {
            stitle = [[带走你的污秽]],
            sdes = [[敌人死亡时，消除离其最近的§g1§d颗弹幕
自机生命值归§r0§d时清空场上的弹幕]],
            detail = [[敌人死亡时，§g消除离其最近的1颗弹幕
自机生命值归§r0§d时清空场上的弹幕]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [117] = {
            stitle = [[不碎的意志]],
            sdes = [[被弹/升级获得的无敌时间额外增加§g0.43秒]],
            detail = [[被弹/升级获得的无敌时间额外§g+26帧]],
            repeatd = nil,
            tags = { t.neet, t.defend },
            collabd = [[蓬莱人形：玩偶生成时玩偶额外获得§g30帧§d无敌时间]],
            unlockd = [[收取§p"神宝「佛体的舍利子」"]],
            condd = nil,
        },
        [118] = {
            stitle = [[受伤了？]],
            sdes = [[自机受到伤害时，保留一半无敌时间但不扣血，
间隔§b99帧§d后才失去生命§-(附带完整无敌时间)]],
            detail = [[自机受到伤害时，保留一半无敌时间但不扣血，
间隔§b99帧§d后才失去生命§-(附带完整无敌时间)]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [120] = {
            stitle = [[x = x]],
            sdes = [[每当发射主炮时，有§g7%§d概率向随机方向发射§b1枚§d主炮
每有1个道具，概率§g+0.32%]],
            detail = [[每当发射主炮时，有§b7%§d概率向随机方向发射§b1枚§d主炮
每有1个道具，概率§g+0.32%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [121] = {
            stitle = [[I can't see Forever!]],
            sdes = [[自机周围出现黑色圆形区域，
区域内的敌人受到的伤害额外§g+75%]],
            detail = [[自机周围出现黑色圆形区域，
区域内的敌人受到的伤害额外§g+75%§d]],
            repeatd = nil,
            tags = nil,
            collabd = [[§b宝塔的神光§d：黑圈不断出现向外扩散的特效]],
            unlockd = GongFeng,
            condd = nil,
        },
        [138] = {
            stitle = [[被遗忘的遗弃之物]],
            sdes = [[获得一个追随型子机
每波开始时，随机获得一个§-(满叠)§d临时道具]],
            detail = [[获得一个追随型子机
每波开始时，随机获得一个§-(满叠)§d临时道具]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [141] = {
            stitle = [[爱丽丝宝宝]],
            sdes = [[获得一个人偶追随型子机
对角四向发射§g小针弹§d，造成§g1.0§d的伤害]],
            detail = [[获得一个人偶追随型子机
对角四向发射§g小针弹§d，造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [145] = {
            stitle = [[my name is fashion]],
            sdes = [[获得一个团子追随型子机
发射短距离开花子弹攻击敌人，每颗造成§g1.0§d的伤害]],
            detail = [[获得一个团子追随型子机
发射短距离开花子弹攻击敌人，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [146] = {
            stitle = [[无底的沉溺]],
            sdes = [[射速§g+1.4
自机将以一定的角速度旋转主炮发射方向，§g自动瞄准敌人射击]],
            detail = [[记§ya=弹速
射速§g+1.4
自机将以§g2*a°/s§d的角速度旋转主炮发射方向，自动瞄准敌人射击]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [148] = {
            stitle = [[汗颜了]],
            sdes = [[获得一个猫猫追随型子机
向下发射子弹，每颗造成§g1.0§d的伤害]],
            detail = [[获得一个猫猫追随型子机
向下发射子弹，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [149] = {
            stitle = [[网络喷子]],
            sdes = [[获得一个大喷菇追随型子机
向自机身后发射子弹，每颗造成§g1.0§d的伤害]],
            detail = [[获得一个大喷菇追随型子机
向自机身后发射子弹，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [154] = {
            stitle = [[激情二射]],
            sdes = [[攻击力倍率§r-80%§d
射速§g+1§d，射速倍率§g+150%§d]],
            detail = [[攻击力倍率§r-80%§d
射速§g+1§d，射速倍率§g+150%§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[通关§p挑战6]],
            condd = nil,
        },
        [156] = {
            stitle = [[顶礼膜拜]],
            sdes = [[攻击力§g+0.2§d，获得一个膜图追随型子机
向下发射子弹，每颗造成§g1.0§d的伤害]],
            detail = [[攻击力§g+0.2§d，获得一个膜图追随型子机
向下发射子弹，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [159] = {
            stitle = [[遮风避雨]],
            sdes = [[每当自机受伤时，在自机前方生成一把伞§g阻挡弹幕
伞持续时间§b75帧§d，冷却时间§b105帧§d]],
            detail = [[每当自机受伤时，在自机前方生成一把伞§g阻挡弹幕
伞持续时间§b75帧§d，冷却时间§b105帧§d]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = [[§g太阳表面§d：伞往上漂浮]],
            unlockd = [[击败1次§r"多多良小伞"]],
            condd = nil,
        },
        [160] = {
            stitle = [[...]],
            sdes = [[获得经验点时生成§g自瞄子弹
每发造成§g0.7§d点伤害]],
            detail = [[获得经验点时生成§g自瞄子弹
每发造成§g0.7§d点伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[通关§p挑战2]],
            condd = nil,
        },
        [163] = {
            stitle = [[开摆]],
            sdes = [[获得一个摆烂宝宝追随型子机，不做任何事情
结算时计算摆烂宝宝存在个数，下局游戏开始时获得§g等量死宛宝宝]],
            detail = [[获得一个摆烂宝宝追随型子机，不做任何事情
结算时计算摆烂宝宝存在个数，下局游戏开始时获得§g等量死宛宝宝]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = [[通关§p挑战4]],
            condd = nil,
        },
        [165] = {
            stitle = [[覆水难收]],
            sdes = [[每波开始时生成§g3§d个可阻挡弹幕的水皿
吸收弹幕后有概率破碎，并向上抛射大量§g我方子弹]],
            detail = [[记§ya=水皿个体阻挡的弹数
每波开始时生成§g3§d个可阻挡弹幕的水皿
水皿可阻挡弹幕，每次阻挡有§b0.5a%§d的概率碎裂，
向上方投射§ya§d颗水弹，每颗造成§g120%攻击力§d伤害]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [167] = {
            stitle = [[可爱捏]],
            sdes = [[场上出现一个旋转猫猫在屏幕中飞行
对敌人造成§g12%攻击力§d的接触伤害]],
            detail = [[场上出现一个旋转猫猫在屏幕中飞行
对敌人造成§g12%攻击力§d的接触伤害]],
            repeatd = nil,
            tags = t.siyuan,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [168] = {
            stitle = [[黄豆粉灵魂的包子]],
            sdes = [[获得一个黄豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            detail = [[获得一个黄豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[击败1次§p"铃瑚"]],
            condd = nil,
        },
        [169] = {
            stitle = [[寻求者包子]],
            sdes = [[获得一个红豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            detail = [[获得一个红豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[击败1次§p"铃瑚"]],
            condd = nil,
        },
        [170] = {
            stitle = [[渴望者包子]],
            sdes = [[获得一个绿豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            detail = [[获得一个绿豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[击败1次§p"铃瑚"]],
            condd = nil,
        },
        [171] = {
            stitle = [[喜爱者包子]],
            sdes = [[获得一个蓝豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            detail = [[获得一个蓝豆猫猫围绕自机
射击时猫猫飞出去打击敌人，造成§g30%攻击力§d的接触伤害]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[击败1次§p"铃瑚"]],
            condd = nil,
        },
        [172] = {
            stitle = [[原地tp]],
            sdes = [[拾取时提升§g1§d级
每级升级所需经验降低§g1§d级]],
            detail = [[拾取时提升§g1§d级
每级升级所需经验降低§g1§d级]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [180]=   {
            stitle = [[功德+1]],
            sdes = [[每隔几秒获得§y1§d颗经验点]],
            detail = [[记§ya=3
每隔§ya§d秒获得§y1§d颗经验点]],
            repeatd = [[§ya§d-1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
    {
        [7] = {
            stitle = [[完美主义者的操刀秀]],
            sdes = [[从底部发射自动瞄准敌人的飞刀]],
            detail = [[记§ya=1
发射飞刀间隔为§b({14,9,6})[a]§d帧，
造成§g(a/3*0.5+0.3)*100%攻击力§d的伤害]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [17] = {
            stitle = [[致命拥抱]],
            sdes = [[§g不再受到敌人体术攻击
且靠近敌人时每§b15帧§d对敌人造成§g100%攻击力§d伤害]],
            detail = [[§g不再受到敌人体术攻击
且靠近敌人时每§b15帧§d对敌人造成§g100%攻击力§d伤害]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[被敌怪体术§p5§d次]],
            condd = nil,
        },
        [22] = {
            stitle = [[吸血鬼飞刀]],
            sdes = [[自机击败敌人时根据敌人血量§g恢复生命值]],
            detail = [[记§ya=1
自机击败敌人时恢复§g16a%§d的敌人最大生命]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [25] = {
            stitle = [[汇聚力量与魔力的法阵]],
            sdes = [[出现一个跟随自机的法阵
自机在阵内时，攻击力§g+50%§d、移速§r-15%]],
            detail = [[出现一个跟随自机的法阵，
自机在阵内时，攻击力§g+50%§d、移速§r-15%§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [30] = {
            stitle = [[……代价是什么呢]],
            sdes = [[当符卡能量足够多时，能够以能量§g抵消被弹
但符卡能量不够多时，会使§r受到的伤害增加]],
            detail = [[记§ya=符卡槽个数
每当被弹&体术时，如果此时符卡充能值>70a%，
则§g不损耗生命值§d，改为§r扣除10a%充能值§d
每次触发此道具后，下次触发§r额外扣除10a%充能值§d，
最大扣除§b70a%§d充能值；
若此时符卡充能值不足，受到伤害则会§r提高15a%]],
            repeatd = [[最大扣除充能值量§g-30a%
充能不足时受到伤害§g减少5a%]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[使用§p5§d次符卡]],
            condd = nil,
        },
        [44] = {
            stitle = [[一帆风顺]],
            sdes = [[自机受到伤害时仅增加原本所增加的chaos的§g66%]],
            detail = [[自机受到伤害时仅增加原本所增加的chaos的§b66%]],
            repeatd = nil,
            tags = t.chaos,
            collabd = nil,
            unlockd = [[混沌值达到§r200%]],
            condd = nil,
        },
        [45] = {
            stitle = [[⑨⑨⑨⑨⑨⑨⑨⑨⑨]],
            sdes = [[为美好的世界献上小天才的§g各种增益§d！
"还不快谢谢本老娘！"]],
            detail = [[符卡所需能量§g-0.9%
恢复§g9§d生命值
生命上限§g+9
攻击力&移速§g+0.9
判定点大小§g-0.09
chaos§g-0.9%
§p"冰之妖精"§d的权重增加§g9倍]],
            repeatd = nil,
            tags = t.nine,
            collabd = nil,
            unlockd = [[获得§b9§d次§-"9"§d标签的道具]],
            condd = nil,
        },
        [52] = {
            stitle = [[谁？]],
            sdes = [[在屏幕上形成一个假自机，会射击造成§g自机相同伤害的子弹
移动方式与自机有差别，每波开始时会返回至自机位置]],
            detail = [[自机贴图不透明度倍率§r-30%
在自机位置生成1个与自机分身，随着自机移动而移动
每Wave开始时，分身重新归位到自机身上
高速下分身移速为自机的§b1.5§d倍，低速为§b0.8§d倍
分身发射与自机主炮完全一致的子弹，但射速是自机的§b1/3]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[将任一角色升至§y5§d级]],
            condd = nil,
        },
        [55] = {
            stitle = [[令敌我双方都害怕的秘籍]],
            sdes = [[攻击力§g+0.5，攻击力倍率§g+25%
自机射击时，§r生命值会缓慢流失]],
            detail = [[攻击力§g+0.5§d，攻击力倍率§g+25%
自机射击时，§r生命值会缓慢流失]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = nil,
            unlockd = [[死亡§p10§d次]],
            condd = nil,
        },
        [61] = {
            stitle = [[幻想溢出]],
            sdes = [[敌方子弹有概率变为§y特殊子弹
§-*该子弹能获得意义不明的特性*]],
            detail = [[敌方子弹有§b30%§d概率变为§y特殊子弹§d，随机获得以下§b1~2§d种特性：
每§b10~22帧§d改变一次弹型
每§b10~30帧§d改变一次颜色
每§b120~300帧§d，有§b50%§d概率速度变为负数
每§b150~300帧§d，子弹大小变为原来的§b0.5~1.2§d倍
经过§b0~300帧§d后停留在原地，§b120帧§d后消失
每§g20帧§d有§g5%§d的概率变为经验点]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [62] = {
            stitle = [[首要任务：退治]],
            sdes = [[每波提供一个§y「ToDo擦弹」§d任务，
达到目标数后会获得一个1级以上随机道具]],
            detail = [[记§ya=当前Wave数
每波提供一个§y「ToDo擦弹」§d任务，完成后会获得一个1级以上随机道具
§y「ToDo擦弹」§d：拾取时的Wave需擦§b100+5a§d颗弹，
其他Wave需擦§b0.8*前波擦弹数+a^2§d颗弹]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[一场游戏内擦满§p1000§d颗弹]],
            condd = nil,
        },
        [71] = {
            stitle = [[小小轮椅的力量]],
            sdes = [[射程§g+7
允许主炮§g穿墙1次]],
            detail = [[射程§g+7
允许主炮§g穿版1次]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[累计获得过§p5§d次§g"背扉的秘国"]],
            condd = nil,
        },
        [73] = {
            stitle = [[八分饱]],
            sdes = [[每擦1颗弹，擦弹范围增大§g1%§d，最大增加§r200%
当§b10帧§d内没擦弹时，擦弹范围逐渐减小至原状态]],
            detail = [[记§ya=0§-(最大为200)
擦弹范围增大§ga%
每擦1颗弹，§ga+1
当§b10帧§d内没擦弹时，§ba-(a*0.02)]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[一场游戏内擦满§p2000§d颗弹]],
            condd = nil,
        },
        [76] = {
            stitle = [[妖怪之山名产]],
            sdes = [[恢复§g25§d生命值
道具回收线下降§g64]],
            detail = [[恢复§g25§d生命值，道具回收线§g下降64§d]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[将任一角色升至§y10§d级]],
            condd = nil,
        },
        [78] = {
            stitle = [[可视化本我活动]],
            sdes = [[生成§g3§d个半透明圆形子机，围绕自机旋转
点击§-低速键§d时，发射跟随自机的半透明子弹，§g造成一定伤害]],
            detail = [[记§ya=一秒内按§-低速键§y的次数§d,§yb=3
获得§gb§d个半透明圆形子机，
在轨道上围绕自机旋转，并留下跟随自机的拖影线
高速时，此子机旋转半径较大；
低速时，汇聚到自机判定点处。
点击§-低速键§d时，生成跟随自机的半透明子弹，
经过§b60帧§d后以自机为中心向外发散。
每颗造成§g6a^2%攻击力§d的伤害]],
            repeatd = [[b+3]],
            tags = t.store,
            collabd = [[§b宝塔的神光§d：自机失去光环，妖怪测谎仪的子机获得较小范围的光环]],
            unlockd = nil,
            condd = nil,
        },
        [80] = {
            stitle = [[高燃易爆性！]],
            sdes = [[每当自机使用bomb时，恢复§g7§d生命值]],
            detail = [[记§ya=1
每当自机使用bomb时，恢复§g7a§d生命值]],
            repeatd = [[§ya§d+1]],
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = [[使用§p15§d次符卡]],
            condd = nil,
        },
        [81] = {
            stitle = [[一滴EXP十滴血]],
            sdes = [[每当升级时，恢复§g(当前等级)%生命上限§d的血量
最大恢复§b50%§d生命上限]],
            detail = [[记§ya=游玩等级§-(最大为50)
每当升级时，恢复§ga%§d最大生命值的血量]],
            repeatd = nil,
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = [[一局游戏内达到§p20§d级]],
            condd = nil,
        },
        [85] = {
            stitle = [[HP = EXP]],
            sdes = [[每当自机失去§b2.85%生命上限§d的生命值时
在自机前方生成§g1§d颗经验点]],
            detail = [[每当自机失去§b2.85%生命上限§d的生命值时
在自机前方生成§g1§d颗经验点]],
            repeatd = nil,
            tags = { t.sacrifice, t.store },
            collabd = nil,
            unlockd = [[一局游戏内达到§p25§d级]],
            condd = nil,
        },
        [87] = {
            stitle = [[无限的成长]],
            sdes = [[拾取boss掉落的残碎额外使生命上限§g+7]],
            detail = [[拾取boss掉落的残碎额外使生命上限§g+7]],
            repeatd = nil,
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [94] = {
            stitle = [[广域覆盖]],
            sdes = [[攻击力倍率§r-34%§d，射速§g+1§d，射速倍率§g+50%§d
主炮散射角§b+15°§d]],
            detail = [[攻击力倍率§r-34%§d
射速§g+1§d，射速倍率§g+50%§d
主炮散射角§b+15°§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [114] = {
            stitle = [[永命线]],
            sdes = [[自机受到的伤害增加§r50%§d，受伤的生命值变为§p虚血
§p虚血§d可以§g自愈]],
            detail = [[受到的被弹&体术伤害将§r增加50%
受伤的生命值将变成暗绿色的§p虚血§d，每秒恢复§g1/6§d的§p虚血
再次受到伤害时，先前的所有§p虚血§r全部归零
收集残碎会§g立即回复§p虚血]],
            repeatd = nil,
            tags = { t.defend, t.neet, t.life, },
            collabd = [[§b见血封喉术§d：流逝的血量将变为虚血]],
            unlockd = [[收取§p"神宝「无限的生命之泉」"]],
            condd = nil,
        },
        [116] = {
            stitle = [[判定奇点]],
            sdes = [[自机贴图与判定点大小§b*75%§d，移速§r-0.45
使§b"荷风"§r"台风"§d天气无效化]],
            detail = [[自机贴图与判定点大小§b*75%§d，移速§r-0.45
使§b"荷风"§r"台风"§d天气无效化]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-MAX M§d：引力变大]],
            unlockd = [[收取§p"「阿波罗11的捏造」"]],
            condd = nil,
        },
        [119] = {
            stitle = [[无有合一]],
            sdes = [[点击§-低速键§d时可以使离自机最近的两颗弹幕§b反转判定]],
            detail = [[点击§-低速键§d时可以使离自机最近的两颗弹幕§b反转判定]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[击败1次§p"八云紫"]],
            condd = nil,
        },
        [122] = {
            stitle = [[回溯子弹]],
            sdes = [[射速§g+0.7§d，射程倍率§g+100%§d
当子弹达到§b50%射程§d时，将反转速度方向]],
            detail = [[射速§g+0.7§d，射程倍率§g+100%§d
当子弹达到§b50%射程§d时，将反转速度方向]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [135] = {
            stitle = [[恸红]],
            sdes = [[每当敌人死亡时，在原地留下一个§r血色光环
光环每§g(66/射速)帧§d造成§g3%攻击力§d的伤害，§g45帧§d后消失]],
            detail = [[每当敌人死亡时，在原地留下一个§r血色光环
光环每§g(66/射速)帧§d造成§g3%攻击力§d的伤害，§g45帧§d后消失
光环的大小和敌人判定大小成正比]],
            repeatd = nil,
            tags = t.store,
            collabd = [[§p绯红的专注§d：增大光环的范围]],
            unlockd = nil,
            condd = nil,
        },
        [139] = {
            stitle = [[灵梦宝宝]],
            sdes = [[获得一个阴阳玉追随型子机
发射§g追踪札符§d，造成§g2.0§d的伤害]],
            detail = [[获得一个阴阳玉追随型子机
发射§g追踪札符§d，飞行时间为§b75§d帧，造成§g2.0§d的伤害]],
            repeatd = nil,
            tags = { t.baby, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [140] = {
            stitle = [[魔理沙宝宝]],
            sdes = [[获得一个八卦炉追随型子机
发射§g小导弹§d，造成§g6.0§d的伤害]],
            detail = [[获得一个八卦炉追随型子机
发射§g小导弹§d，飞行时间为§b112§d帧，造成§g6.0§d的伤害]],
            repeatd = nil,
            tags = { t.baby, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [144] = {
            stitle = [[此面向敌]],
            sdes = [[有概率额外向后发射主炮]],
            detail = [[记§ya=幸运值
有§g9/(101-a)*100%§d概率额外向后发射主炮]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [147] = {
            stitle = [[死宛猫猫]],
            sdes = [[获得一个猫猫追随型子机
有节奏地向上洒小子弹，每颗造成§g1.0§d的伤害]],
            detail = [[获得一个猫猫追随型子机
有节奏地向上洒小子弹，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [152] = {
            stitle = [[一飞冲天]],
            sdes = [[攻击力§g+1.5
主炮变为§y火箭子弹§d，初始弹速从0开始逐渐加速，直至200%弹速]],
            detail = [[攻击力§g+1.5
主炮变为§y火箭子弹§d，初始弹速从0开始逐渐加速，直至200%弹速]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[通关§p挑战3]],
            condd = nil,
        },
        [155] = {
            stitle = [[海之恩惠]],
            sdes = [[随机获得§g7种效果之一
效果的获得§-不重复]],
            detail = [[随机获得以下某一种效果§-(不会重复)§d：
§r红 生命上限+10
§o橙 删除3个灾害
§y黄 缩短夏季时长1波
§g绿 恢复25生命值
§c青 获得3个裨益
§b蓝 缩短冬季时长1波
§p紫 修复3个损坏的道具]],
            repeatd = [[增加§g5§d倍获得权重]],
            tags = t.life,
            collabd = nil,
            unlockd = [[通关§p挑战5]],
            condd = nil,
        },
        [157] = {
            stitle = [[嘲讽]],
            sdes = [[射速§g+0.9§d，获得一个猫猫追随型子机
发射追踪子弹，每颗造成§g0.8§d的伤害]],
            detail = [[射速§g+0.9§d，获得一个猫猫追随型子机
发射追踪子弹，每颗造成§g0.8§d的伤害]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [164] = {
            stitle = [[月的另一边]],
            sdes = [[自机处展开1个§y可消弹的月球§d，当月球碰到弹幕时缩小至消失
消失间隔§b85帧§d后，会在§b120帧§d内完全展开]],
            detail = [[自机处展开1个§y可消弹的月球§d，当月球碰到弹幕时缩小至消失
消失间隔§b85帧§d后，会在§b120帧§d内完全展开]],
            repeatd = nil,
            tags = t.defend,
            collabd = [[§b永远的幼月§d：月球变为红色]],
            unlockd = [[击败1次§y"露娜切露德"]],
            condd = nil,
        },
        [166] = {
            stitle = [[不支持日语]],
            sdes = [[每隔§b200帧§d生成一个§r"異議あり！"
寻找场上血量最高的非boss敌人§y秒杀§d]],
            detail = [[每隔§b200帧§d生成一个§r"異議あり！"
寻找场上血量最高的非boss敌人§y秒杀§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [173] = {
            stitle = [[飞翔于天空的不思议经验]],
            sdes = [[经验获取倍率§g+50%
经验点下降速度§r+75%]],
            detail = [[经验获取倍率§g+50%
经验点下降速度§r+75%]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [181]=   {
            stitle = [[便携式黑手]],
            sdes = [[场上所有敌人以较慢的速度流失生命]],
            detail = [[记§ya=2
场上所有敌人每秒流失(a)%的生命值]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
    {
        [18] = {
            stitle = [[敢于直面弹幕的威光]],
            sdes = [[在自机周围增加一个可以§g消除弹幕§d的水獺灵]],
            detail = [[增加一个可以§g消除弹幕§d的水獺灵子机]],
            repeatd = [[水獺灵+1]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [21] = {
            stitle = [[化无为有]],
            sdes = [[自机擦弹时有概率掉落经验点]],
            detail = [[记§ya=1
擦弹时，有§ga*15%§d的概率掉落经验点]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [24] = {
            stitle = [[全方位射击]],
            sdes = [[获得1个碎冰弹子机，散射碎冰弹
每颗子弹伤害为§g35%攻击力]],
            detail = [[记§ya=1
获得1个碎冰弹子机，散射碎冰弹，每颗子弹伤害为§g35%攻击力
发射间隔为§b({12,8,6})[a]§d帧
发射条数为§b({9,9,12})[a]§d]],
            repeatd = [[§ya§d+1]],
            tags = t.nine,
            collabd = nil,
            unlockd = [[击败1次§b"琪露诺"]],
            condd = nil,
        },
        [26] = {
            stitle = [[灵敏的寻宝器]],
            sdes = [[周期性生成不断旋转扩大的金摆
当其接触到敌人时，§g生成一些经验点§d并对敌人§g造成伤害]],
            detail = [[记§ya=1
每§b355-55*a§d帧在自机周围生成§g3§d个金摆
每帧造成§g30+10*a%攻击力§d的伤害，同时§g生成一些经验点]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = [[一局游戏内达到§p15§d级]],
            condd = nil,
        },
        [29] = {
            stitle = [[清仓大甩卖]],
            sdes = [[射击时会额外发射§y超闪超亮的穿透祷光§d，努力凑满§g17§d条吧！
每当获取此道具时，有概率额外§g获得一个]],
            detail = [[增加§g10§d倍获得权重
记§ya=1
当自机不动时，向自机正前方为§b0°§d，左右各§b(a/17*135)°§d的范围内，
随机角度生成一条激光
每帧造成§g(50-a/17*30)%§d攻击力的伤害，持续§g(187-4a)§d帧
激光的不透明度为§b(80-a/17*40)%
每当获取此道具时，有§g(17+6a)%§d概率额外获得一个
当a=17时，自机背后出现§y光背特效]],
            repeatd = [[a+1
增加§g10§d倍获得权重]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [37] = {
            stitle = [[汝吾连心，血偿无敌]],
            sdes = [[当生命充足时，可将生命转化为充能来§g释放符卡]],
            detail = [[记§ya=符卡槽总充能-当前充能量§d, §yb=生命上限
当符卡充能不足以释放符卡时，
可按释放符卡键耗费§r(a+b)/8§d点生命值来§g释放符卡§d并§r清空符卡槽§d
§-(不计作伤害，会致死时则无效)]],
            repeatd = nil,
            tags = t.store,
            collabd = [[§g硝酸甘油§d：使用§p心连心§d释放符卡时，硝酸甘油固定回复§g5§d点生命值]],
            unlockd = nil,
            condd = nil,
        },
        [50] = {
            stitle = [[命冥合一]],
            sdes = [[受到致死伤害时，生命值恢复§g50%§d，但生命上限减少§r50%§d
每波仅限一次]],
            detail = [[受到致死伤害时，§g抵消该次伤害§d，
同时生命值恢复§g50%§d，但生命上限减少§r50%§d
§r每波仅限一次]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[击败1次§p"八云紫"]],
            condd = nil,
        },
        [53] = {
            stitle = [[暗黑之手]],
            sdes = [[§b场上所有生物的生命值不断流逝
会导致自机§r死亡]],
            detail = [[§b场上所有生物的生命值不断流逝
敌人每秒失去§r min {33.33%生命上限, 54}
自机每秒失去§r max {1.03%生命上限, 0.514}
会导致自机§r死亡]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[仅可通过§r"露米娅"§d掉落获得]],
        },
        [63] = {
            stitle = [[陈旧幻想]],
            sdes = [[自机持续一段时间未被弹时，生成§g1§d个小型人偶，上限§b9§d个
人偶会§g攻击敌人§d，也会§g抵挡数颗弹幕]],
            detail = [[记§ya=人偶数量
自机持续§b30+25a§d帧未被弹时，生成§g1§d个小型人偶，上限§b9§d个
每当自机被弹时，强制进入§r110帧§d的冷却，§r无法生成人偶
人偶将朝着最近的敌人每§b75帧§d发射§g1§d枚§g0.5a+50%攻击力§d伤害的子弹
人偶生成时有§g30帧§d的保护时间，可抵消弹幕
非保护状态时，抵消§g3§d颗弹幕或被体术时消失]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = [[§g生命爆炸之药§d：人偶消失时，产生小范围爆炸
§g佛的御石钵§d：人偶生成时的保护时间延长§p30帧]],
            unlockd = GongFeng,
            condd = nil,
        },
        [72] = {
            stitle = [[When I see you ...]],
            sdes = [[射程§g+7§d，弹速§r-2.5
主炮获得§g追踪效果]],
            detail = [[射程§g+7§d，弹速§r-2.5§d
主炮获得§g追踪效果]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [74] = {
            stitle = [[「复活」]],
            sdes = [[自机死亡时通过一段时间的§y「重生」§d便可以复活
§g没有次数限制]],
            detail = [[自机死亡时进入§y「重生」§d状态
§y「重生」§d：§r攻击力大幅下降且不能释放符卡§d，持续§b4.43秒
若受击，则直接§r死亡
结束后自机恢复§g50%生命上限§d的生命。
§g该复活道具没有次数限制]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[复活优先级为§y-1§-(越高越先触发)]],
            unlockd = [[死亡§p5§d次]],
            condd = nil,
        },
        [77] = {
            stitle = [[全方位无死角反弹]],
            sdes = [[射程§g+7§d
允许主炮子弹§g无限反弹]],
            detail = [[射程§g+7§d
允许主炮子弹§g无限反弹]],
            repeatd = nil,
            tags = nil,
            collabd = [[§b便捷式后户§d：先触发穿版，再触发反弹]],
            unlockd = GongFeng,
            condd = nil,
        },
        [84] = {
            stitle = [[Rewind]],
            sdes = [[玩家死亡时§g读档至上一波§d，并且该道具§-损坏]],
            detail = [[玩家死亡时§g读档至上一波§d，并且此道具§-损坏
§-第一波时该道具无效
§-回溯后该道具至少有一波的冷却]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[复活优先级为§y2§-(越高越先触发)]],
            unlockd = GongFeng,
            condd = nil,
        },
        [89] = {
            stitle = [[不死图腾？]],
            sdes = [[混沌值超过§r30%§d时，混沌值减少§g30%
触发一次后§-损坏]],
            detail = [[混沌值超过§b30%§d时，混沌值减少§g30%
触发一次后§-损坏]],
            repeatd = nil,
            tags = { t.chaos, t.store },
            collabd = nil,
            unlockd = [[混沌值达到§p150%]],
            condd = nil,
        },
        [93] = {
            stitle = [[神明之祝福]],
            sdes = [[主炮靠近敌人时，若打不中则§g会转向90°以瞄准敌人]],
            detail = [[主炮靠近敌人时，若打不中则§g会转向90°以瞄准敌人]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [96] = {
            stitle = [[火力优势学说]],
            sdes = [[增加一个符卡槽]],
            detail = [[增加一个符卡槽！]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[使用§p30§d次符卡]],
            condd = nil,
        },
        [100] = {
            stitle = [[PPT]],
            sdes = [[所有弹幕消除后都会产生§y消弹点
每颗§y消弹点§d增加§g0.01%§d符卡能量]],
            detail = [[所有弹幕消除后都会产生§y消弹点
每颗§y消弹点§d增加§g0.01%§d符卡能量]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [101] = {
            stitle = [[梦色之乡]],
            sdes = [[自机向下发射§y七色珠§d，反弹后自动瞄准敌人，造成§g120%攻击力§d伤害
击中敌人的§y七色珠§d将掉落，可以回收并重新射出]],
            detail = [[自机每§g45帧§d向下随机角度发射§g1~3§d颗§y七色珠
每颗造成§g120%攻击力§d伤害
§y七色珠§d可以反弹§g1§d次，反弹后将自动瞄准敌人发射
当§y七色珠§d击中敌人后，将会向下掉落为可回收的§y七色珠§d，
回收后§y七色珠§d将自动瞄准敌人并发射，并重置其反弹次数
同屏最多§b20§d颗§y七色珠§d]],
            repeatd = nil,
            tags = t.neet,
            collabd = nil,
            unlockd = [[收取§p"神宝「蓬莱的玉枝　-梦色之乡-」"]],
            condd = nil,
        },
        [105] = {
            stitle = [[棱镜散光]],
            sdes = [[主炮子弹击中敌人时，向四方发射§b原主炮大小75%§d的小主炮
每颗小主炮造成§g20%攻击力§d伤害]],
            detail = [[主炮子弹击中敌人时，向四方发射§b原主炮大小75%§d的小主炮
每颗小主炮造成§g20%攻击力§d伤害
§-发射角度会随时间进行变化]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [106] = {
            stitle = [[稗草萋萋，命散别离]],
            sdes = [[自机死亡后在§g原地复活§d，获得§g120帧§d无敌时间和修改为§r9§d点生命上限
复活后，随机§r损坏§d1个道具；复活§g8§d次后，此道具§-损坏]],
            detail = [[自机死亡后在§g原地复活§d，获得§g120帧§d无敌时间和修改为§r9§d点生命上限
复活后，随机§r损坏§d1个道具
复活§g8§d次后，此道具§-损坏]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[复活优先级为§y1§-(越高越先触发)]],
            unlockd = [[2024年8月7日后]],
            condd = nil,
        },
        [108] = {
            stitle = [[星垂平野阔]],
            sdes = [[每当敌人出现/死亡时，在场上随机一位置生成§b1§d颗星星，
星星造成§g20%攻击力§d伤害，经过§b350帧§d后，星星消失]],
            detail = [[每当敌人出现/死亡时，在场上随机一位置生成§b1§d颗星星，
星星造成§g20%攻击力§d伤害，经过§b350帧§d后，星星消失]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [111] = {
            stitle = [[典礼]],
            sdes = [[攻击力§g+1§d，射速倍率§r-77%§d，射程§r-3.5§d，射程倍率§r-34%§d
自机将发射§b150%§d攻击力的大主炮，消失时分裂出开花主炮]],
            detail = [[攻击力§g+1§d，射速倍率§r-77%§d，射程§r-3.5§d，射程倍率§r-34%§d
自机改为发射一枚§b150%§d攻击力的大主炮，
大主炮碰到敌人或者消失时分裂，向周围发射§b6~9§dway开花主炮
主炮继承§b60%§d射程，但最小不小于§b5~8§d]],
            repeatd = nil,
            tags = nil,
            collabd = [[§p幻想万华镜§d：每颗小主炮只会分裂出§b4§d颗弹幕]],
            unlockd = GongFeng,
            condd = nil,
        },
        [112] = {
            stitle = [[人生之梦]],
            sdes = [[有概率§g免除被弹&体术伤害]],
            detail = [[记§ya=1
有§ga*23%§d概率免除被弹&体术伤害]],
            repeatd = [[a+1
降低§r0.3§d倍获得权重]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[被弹累计§p50§d次]],
            condd = nil,
        },
        [113] = {
            stitle = [[充能型护盾]],
            sdes = [[每Wave获得§g0.75§d层护罩，每§b1§d层护罩可以抵消§g1§d次伤害
最多叠加§b3§d个护罩]],
            detail = [[每Wave获得§g0.75§d层护罩，每§b1§d层护罩可以抵消§g1§d次伤害
最多叠加§b3§d个护罩]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[获得过§b"魔力护瓶"]],
            condd = nil,
        },
        [123] = {
            stitle = [[百战不殆的瞄准]],
            sdes = [[开火一段时间后向前发射高速针弹，造成§g大量伤害，
但自机§r熄火一段时间]],
            detail = [[记§ya=0§d，§ym=1§-(最大为9)
自机每射击§b(300-a*50-m*13)§-(不低于75)§b帧§d，
向全方位发射§gm§d枚高速红色拖尾针弹
针弹继承自机射程，对接触到的敌人造成每帧§g25%攻击力§d的伤害
发射完针弹后，自机熄火§r(60-a*20)帧§d，§ym§g+0.75
当自机受到非技巧性伤害时，§rm=1]],
            repeatd = [[a+1]],
            tags = nil,
            collabd = [[引诱的黄泉：针弹获得§g追踪效果
便捷式后户：针弹§g可穿版1次
幽谷回响：针弹§g可无限反弹
吸血鬼之牙：§ym§d最大值修改至§g12]],
            unlockd = GongFeng,
            condd = nil,
        },
        [124] = {
            stitle = [[水中的秘密]],
            sdes = [[低速状态下，攻击力§g+0.5§d，判定点§g-0.1§d
同时额外§g发射波纹弹]],
            detail = [[自机低速时，进入§y「潜水」§d，§-贴图变蓝
§y「潜水」§d：攻击力§g+0.5§d，判定点§g-0.1§d
每§b12帧§d，发射大型波纹弹，造成§g60%攻击力§d的伤害；
每§b25帧§d，发射小型波纹弹，造成§g30%攻击力§d的伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[击败1次§b"若鹭姬"]],
            condd = nil,
        },
        [125] = {
            stitle = [[非等价市场]],
            sdes = [[根据收集的经验点数§g增加攻击力与射速
每当升级时重置经验点数计数]],
            detail = [[记§yn=收集的经验点数
自机攻击力和射速§g+0.012n
每当升级时，§rn=0]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[一局游戏内达到§p30§d级]],
            condd = nil,
        },
        [126] = {
            stitle = [[无上之威光]],
            sdes = [[自机周围出现光环，
进入光环中的敌人每帧受到§g5%攻击力§d伤害]],
            detail = [[自机周围出现光环，
进入光环中的敌人每帧受到§g5%攻击力§d伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [127] = {
            stitle = [[直视我！]],
            sdes = [[自机击败敌人越快，§g攻击力提升越大]],
            detail = [[自机击败敌人越快，§g攻击力提升越大
记§yt=0§-(最大为200)§d，§yn=0
每当击破敌人时，§bn+0.3§d。每帧§bt-1
§bt>=60§d时：每击破一名敌人使§bt+10§d；每15帧§bn-1
§bt<60§d时：击破敌人会使得§bt=60
§bt<30§d时：如果此时§bn<=25§d，则§bn=0§d；否则，每帧§bn-2
自机攻击力§g+35%n]],
            repeatd = [[叠加2个时，自机攻击力§g+15%n§d；
叠加3个时，击破敌人时§bn+0.3§d]],
            tags = t.store,
            collabd = nil,
            unlockd = [[累计杀死§p3333§d个敌人]],
            condd = nil,
        },
        [128] = {
            stitle = [[轻拿轻放]],
            sdes = [[攻击力倍率§g+69%§d，主炮大小§g+69%
生命上限修改为§r20§d，每次受到伤害时减少§r2.5§d点生命上限]],
            detail = [[攻击力倍率§g+69%§d，主炮大小§g+69%
自机最大生命修改至§r20§d且不能再增加§-(包括复活后)
每次受到伤害时减少§r2.5§d点生命上限]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[死亡§p15§d次]],
            condd = nil,
        },
        [129] = {
            stitle = [[炽热鲜血]],
            sdes = [[有§b16%§d的概率发射§r红色主炮§d
造成§g3.3§d倍伤害]],
            detail = [[有§b16%§d的概率发射§r红色主炮§d
造成§g3.3§d倍伤害]],
            repeatd = nil,
            tags = t.RGB,
            collabd = [[获得3件带有§yRGB§d标签的道具时
有概率发射出白色主炮，拥有§r红§g绿§b蓝§d子弹的效果
击中敌人时将透过敌人，分裂出§r红§g绿§b蓝§d三枚主炮]],
            unlockd = GongFeng,
            condd = nil,
        },
        [130] = {
            stitle = [[二氧化碳过滤器]],
            sdes = [[有§b17%§d的概率发射§g绿色主炮§d
击中时恢复§g0.025§d生命值]],
            detail = [[有§b17%§d的概率发射§g绿色主炮§d
击中时恢复§g0.025§d生命值]],
            repeatd = nil,
            tags = { t.RGB, t.life, t.store },
            collabd = [[获得3件带有§yRGB§d标签的道具时
有概率发射出白色主炮，拥有§r红§g绿§b蓝§d子弹的效果
击中敌人时将透过敌人，分裂出§r红§g绿§b蓝§d三枚主炮]],
            unlockd = GongFeng,
            condd = nil,
        },
        [131] = {
            stitle = [[明亮岩盐]],
            sdes = [[有§b10%§d的概率发射§b蓝色主炮§d
被击中的敌人将掉落§g1§d颗经验点]],
            detail = [[有§b10%§d的概率发射§b蓝色主炮§d
被击中的敌人将掉落§g1§d颗经验点]],
            repeatd = nil,
            tags = { t.RGB, t.store },
            collabd = [[获得3件带有§yRGB§d标签的道具时
有概率发射出白色主炮，拥有§r红§g绿§b蓝§d子弹的效果
击中敌人时将透过敌人，分裂出§r红§g绿§b蓝§d三枚主炮]],
            unlockd = GongFeng,
            condd = nil,
        },
        [150] = {
            stitle = [[死宛拉拉队]],
            sdes = [[获得一个拉拉队追随型子机
有节奏地挥舞发射子弹，每颗造成§g1.0§d的伤害]],
            detail = [[获得一个拉拉队追随型子机
有节奏地挥舞发射子弹，每颗造成§g1.0§d的伤害]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [161] = {
            stitle = [[黄豆粉灵魂的躯壳]],
            sdes = [[拾取boss掉落的残碎额外使攻击力§g+1§d，符卡能量§g+25%]],
            detail = [[拾取boss掉落的残碎额外使攻击力§g+1§d，符卡能量§g+25%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[击败1次§p"铃瑚"]],
            condd = nil,
        },
        [179] = {
            stitle = [[你不存在]],
            sdes = [[§r受击§d时，使场上所有弹幕§b反转判定]],
            detail = [[§r受击§d时，使场上所有弹幕§b反转判定]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
    {
        [27] = {
            stitle = [[魂飞魄散]],
            sdes = [[擦弹时有几率§g将子弹变成追踪幽魂弹
幽魂弹每秒对敌人造成§g1200%攻击力§d的伤害]],
            detail = [[擦弹时有几率§g将子弹变成追踪幽魂弹
幽魂弹每秒对敌人造成§g1200%攻击力§d的伤害
记§ya=幸运值§-(最小为5)
§yb=-8§-(最小为-16，最大为40)
§yx=幸运值§-(最小为1)
判定成功概率§yp=(a+15/66+b)*x/100
判定成功时§rb-8§d，失败时§gb+8
每擦2颗弹时判定1次，判定成功后被判定的子弹变为追踪幽魂弹，
幽魂每帧造成§g20%攻击力§d的伤害，持续§b288帧§d
最多存在§b36§d个幽魂]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [40] = {
            stitle = [[永星祈祷]],
            sdes = [[当生命值等于生命上限时，
回复生命时会增加§g其回复量一定比例§d的生命上限]],
            detail = [[记§ya=1
当生命值等于生命上限时，
回复生命时会增加其§g回复量的(20+a*10)%§d的生命上限
将天星之沐愿(蓝)、天星之沐愿(红)的权重降为§r0]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [41] = {
            stitle = [[质星祈祷]],
            sdes = [[每次升级§g可选择2次加成§d，§r但选择的选项减少1个
经验获取倍率§r下降§d，多次获得后§g上升]],
            detail = [[记§ya=1
每次升级§g可选择2次加成§d，§r但选择的选项减少1个
经验获取倍率§r-30%
将天星之沐愿(绿)、天星之沐愿(红)的权重降为§r0]],
            repeatd = [[经验获取倍率§g+20%]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [42] = {
            stitle = [[灵星祈祷]],
            sdes = [[每次升级时，选取§y攻击力|射速|弹速|射程§d中随机一项
§g提高一定数值，该效果每次升级执行§y2§d次]],
            detail = [[记§ya=1§d
每次升级时，将§y攻击力|射速|弹速|射程§d从小到大排序
分别有§g40%§d,§g30%§d,§g20%§d,§g10%§d的概率得到数值提升
数值为§g0.5+a*0.5
该效果每次升级执行§y2§d次
将天星之沐愿(绿)、天星之沐愿(蓝)的权重降为§r0]],
            repeatd = [[a+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [47] = {
            stitle = [[命之纽带]],
            sdes = [[每当敌人死亡时
对场上所有敌人造成1次§g死亡敌人4%§d生命上限的伤害]],
            detail = [[每当敌人死亡时
对场上所有敌人造成1次§g死亡敌人4%§d生命上限的伤害]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[累计杀死§p10000§d个敌人]],
            condd = nil,
        },
        [51] = {
            stitle = [[叹息之墙]],
            sdes = [[生成横跨版中上方的蓝色屏障
碰到屏障的敌机弹幕§g会被消除§d]],
            detail = [[生成横跨版中上方的蓝色屏障
碰到屏障的敌机弹幕§g会被消除§d]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [58] = {
            stitle = [[她将永远守护着你……]],
            sdes = [[获得§y「樱花结界」§d系统
使春季时长延长§b1§d波]],
            detail = [[获得§y「樱花结界」§d系统
§y「樱花结界」§d：
攻击敌人时增加樱点，高速状态增加更多
樱点数量显示于右处，装满进度条即会自动开启樱花结界
开启结界时，恢复§g10§d生命值，结界持续一段时间，§g擦弹获得大量分数
结界<被弹结束/主动结束>时：§g全屏消弹
结界<时间耗尽>时：§g奖励一定分数
开启结界时按释放符卡键§g可以主动结束
使春季时长延长§b1§d波]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[遇见一次§p"春雪"§d天气]],
            condd = nil,
        },
        [64] = {
            stitle = [[我全都要！]],
            sdes = [[§g自机吸引场上的所有经验点
每级升级所需经验§g降低7级]],
            detail = [[§g自机吸引场上的所有经验点
每级升级所需经验§g降低7级]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [86] = {
            stitle = [[永远的满月]],
            sdes = [[自机对任何类型的伤害都§g减免1.00
自机对任何类型的伤害都§g减免50%]],
            detail = [[自机对任何类型的伤害都§g减免1.00
自机对任何类型的伤害都§g减免50%]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[击败1次§r"纯狐"]],
            condd = nil,
        },
        [90] = {
            stitle = [[甜蜜的痛苦]],
            sdes = [[每当主炮击中敌人时，施加§g1§d层§y「甘毒」
§y「甘毒」§d：攻击时，额外对敌人造成§g0.19§d点伤害]],
            detail = [[射速§g+0.7
每当主炮击中敌人时，施加§g1§d层§y「甘毒」
§y「甘毒」§d：攻击时，额外对敌人造成§g0.19§d点伤害]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[击败1次§p"梅蒂欣"]],
            condd = nil,
        },
        [115] = {
            stitle = [[以爱濡养]],
            sdes = [[每有§b60§d颗弹幕被消除时，获得§g60帧§d无敌时间
同时自机周围将展开一定大小的消弹圈]],
            detail = [[当有§b60§d颗弹幕被消除时，获得§y「护莲」
§y「护莲」§d：使自机获得最高§g60帧§d的无敌时间
同时§g展开一定大小的消弹圈
可储存最多§b60§d颗消除的弹幕，以获得下次§y「护莲」§d。
§-注意：激光的消除无法记录消弹个数]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [132] = {
            stitle = [[鬼气狂澜]],
            sdes = [[攻击力§g+1
攻击力倍率§g+100%]],
            detail = [[攻击力§g+1
攻击力倍率§g+100%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [133] = {
            stitle = [[八岳之力]],
            sdes = [[每波第1次被弹§g不计伤害
且该弹型在本波中不再出现§-(区分颜色)]],
            detail = [[每波第1次被弹§g不计伤害
且该弹型在本波中不再出现§-(区分颜色)]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[通过"雾之湖"与"静海"的§yExtra§d难度]],
            condd = nil,
        },
        [162] = {
            stitle = [[核聚变]],
            sdes = [[击破敌人时，有概率在敌人位置出现1条§y十字激光
激光对敌人每帧造成§g8%攻击力§d伤害]],
            detail = [[记§yb=1§d
击破敌人时，有§g10%§d概率在敌人位置出现1条十字激光
幸运值为§g50§d时概率§g100%
激光对敌人每帧造成§g8%攻击力§d伤害，持续§b30b帧]],
            repeatd = [[b+1]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
}