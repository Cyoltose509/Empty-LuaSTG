local t = stg_levelUPlib.tagslist
local GongFeng = Trans("addition", "GongFeng")

return {
    {
        [28] = {
            stitle = [[Three pieces of the heart]],
            sdes = [[Whenever Player MISS always lose 33% of Maxlife]],
            detail = [[Whenever Player MISS always lose 33% of Maxlife]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[Violently quit the game]],
            condd = nil,
        },
        [36] = {
            stitle = [[Pure game]],
            sdes = [[Changes the Bomb to §pa period of Invincibility§d
and §rshooting is disabled]],
            detail = [[Recall §ya=1§d, §yb= the Invincibility time given by the original Spell
The effect of the Spell is §r canceled §d
and changed to gain §pb*(1.6+0.4*a) seconds §d of Invincibility
While using the Spell, §r you cannot shoot §d, and Speed is increased by 50%]],
            repeatd = [[§ya§d+1
Decreases the §r0.3§d times to gain weight]],
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [39] = {
            stitle = [[Unity of soul and body]],
            sdes = [[The Graze area becomes the 1.86 sizes of Hitbox
and Hitbox §r+0.5§d, Hitbox Power §r+100%§d]],
            detail = [[the Graze area becomes the 1.86 sizes of Hitbox
and Hitbox §r+0.5§d, Hitbox Power §r+100%§d]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Changed Hitbox §p1§d times]],
            condd = nil,
        },
        [43] = {
            stitle = [[Odd changes, Even changes]],
            sdes = [[In the even wave, Chaos §g-0.1%§d /s,
In the odd wave, Chaos §g+0.1%§d /s]],
            detail = [[In the even wave, Chaos §g-0.1%§d /s,
In the odd wave, Chaos §g+0.1%§d /s]],
            repeatd = nil,
            tags = t.chaos,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [46] = {
            stitle = [[A thousand miles journey]],
            sdes = [[High-Speed §b-0.3§d, Low-Speed §b+0.3§d
Speed will not be lower than the value after getting this Item]],
            detail = [[High-Speed §b-0.3§d, Low-Speed §b+0.3§d
Speed will not be lower than the value after getting this Item]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [48] = {
            stitle = [[Bloody counterattack!]],
            sdes = [[When enemies died, they will shoot bullets towards Player]],
            detail = [[When enemies died, they will shoot a chain of §r3 bullets§d towards Player]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = [[Each Item with a §p"Sacrifice"§d tag increases the number of bullets §r+1
§bThe Bloodhex§d: Shoots extra bullets in the opposite direction]],
            unlockd = [[Killed a total of §p1000§d enemies]],
            condd = nil,
        },
        [54] = {
            stitle = [[The small power of Yukari]],
            sdes = [[Gaps appear at the edges of the screen
Enemies that enter the gaps will take §g350% ATK§d dmg]],
            detail = [[Gaps appear at the edges of the screen
Allowing Player, enemies and bullets to teleport
Enemies that enter the gaps will take §g350% ATK§d dmg]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Defeated §p"Yakumo Yukari"§d once]],
            condd = nil,
        },
        [56] = {
            stitle = [[Reversal]],
            sdes = [[ATK Power §g+50%§d, Player will shoot backwards
Makes §r"Reversis"§d weather ineffective]],
            detail = [[ATK Power §g+50%§d
§rPlayer will shoot backwards
Makes §r"Reversis"§d weather ineffective]],
            repeatd = nil,
            tags = nil,
            collabd = [[§bSakuya's Knife§d: Knives will shoot from top
§pIce Fairy§d: Changes to generate a minion above Player
§pGreat Sale: Miko's Tokens§d: Lasers will shoot downwards
§gThe Hidden§d: Changes to generate a door in front of Player
§gSilent Winter§d: Snowflakes will fall "from bottom"
§gSilent Winter§d + §gSolar Flare§d: Snowflakes will melt
§pIce Scales§d: Bullets will shoot downwards
§pCrimson Focus§d: Bullets will shoot downwards
§gSalamander Shield§d: Fireballs will shoot in the same direction
§pHourai Branch§d: ColorBall will start shooting upwards
§gSmall Starasol§d: Changes to generate an umbrella below Player]],
            unlockd = [[Meet §-"Reversal"§d weather]],
            condd = nil,
        },
        [83] = {
            stitle = [[...]],
            sdes = [[Selected Item has a §b20%§d chance to §rrandomly become other Item]],
            detail = [[Selected Item has a §b20%§d chance to §rrandomly become other Item]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [88] = {
            stitle = [[Play with bias]],
            sdes = [[Bullet speed §g+0.3
Player's Bullets gain a velocity vector equal to Player's speed]],
            detail = [[Bullet speed §g+0.3
Player's Bullets gain a velocity vector equal to Player's speed]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [98] = {
            stitle = [[Recycle old dreams...]],
            sdes = [[Each wave, gain a §gBenefit§d, §bTrade§d, or §rInfringe]],
            detail = [[Each wave, gain a §gBenefit§d, §bTrade§d, or §rInfringe]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [102] = {
            stitle = [[Subworld express]],
            sdes = [[The next season will definitely become §y"Doyou"
It will be damaged after taking effect once]],
            detail = [[The next season will definitely become §y"Doyou"
It will be damaged after taking effect once]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Meet §-"Doyou"§d season]],
            condd = [[Wx system exists]],
        },
        [107] = {
            stitle = [[It craves blood]],
            sdes = [[Restores §g10§d Life
Pressing the Bomb key will §bteleport to the nearest enemy]],
            detail = [[Restores §g10§d Life
Pressing the Bomb key will grant §b7 f§d Invincibility
and §bteleport to the nearest enemy
Cooldown is §b12 f]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [134] = {
            stitle = [[World collapse]],
            sdes = [[§gGain§d\§-Break§d\§rLose§d this Item, all other Items
§bWill be replaced randomly§-(except temporary Items)§d]],
            detail = [[§gGain§d\§-Break§d\§rLose§d this Item, all other Items
§bWill be replaced randomly§-(except temporary Items)§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [136] = {
            stitle = [[Happiness this life]],
            sdes = [[In this game, §gan extra option appears each upgrade
Hold this Item at the end, you will gain §r"Eternal Echo" in future games]],
            detail = [[In this game, §gan extra option appears each upgrade
Hold this Item at the end, you will gain §r"Eternal Echo" in future games]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-Eternal Echo§d :
After obtaining §b"Endless Clock"§d in the previous game
It will be §rforced to be carried

Chaos §r+25%§d, prevents the appearance of §b"Endless Clock"§d
§r13%§d chance to get an Infringe upon Upgrading
EXP Rate §g+20%
Only §rwhen carrying it to clear one game§d, then the curse will go away]],
            unlockd = nil,
            condd = [[Will not appear in challenge mode]],
        },
        [137] = {
            stitle = [[Endless]],
            sdes = [[Chaos §r+25%§d, prevents the appearance of §b"Endless Clock"§d
§r13%§d chance to get an Infringe upon Upgrading]],
            detail = [[After obtaining §b"Endless Clock"§d in the previous game
It will be §rforced to be carried

Chaos value §r+25%§d, prevents the appearance of the Item §b"Endless Clock"§d
There is a §r13%§d chance to gain an Infringe upon Upgrading
EXP Rate §g+20%
Only §rwhen carrying it to clear one game§d, then the curse will go away]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[Appears unnaturally]],
        },
        [142] = {
            stitle = [[Universal gravitation]],
            sdes = [[Speed §r-0.25§d, Player's Bullets will gain §bacceleration towards Player
The further from Player, the greater the acceleration]],
            detail = [[Speed §r-0.25§d
Player's Bullet will gain §bacceleration towards Player
The further from Player, the greater the acceleration
Drops will be weakly §g attracted§d to Player]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [143] = {
            stitle = [[Friend to the end]],
            sdes = [[Gain a red ghost that follows Player
§rHas body dmg§d, §bblocks both enemy and Player bullets]],
            detail = [[Gain a red ghost that follows Player
Initially, the ghost does not have body dmg,
When the ghost is separated from Player, it §rhas body dmg§d
§bBlocks both enemy and Player bullets]],
            repeatd = nil,
            tags = { t.defend, t.baby, },
            collabd = [[§bAdamantine Body§d: The ghost becomes ineffective]],
            unlockd = GongFeng,
            condd = nil,
        },
        [151] = {
            stitle = [[Same root, But compete]],
            sdes = [[Prevents all §-0 Quality Items§d from appearing]],
            detail = [[Prevents all §-0 Quality Items§d from appearing]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [153] = {
            stitle = [[Zero star]],
            sdes = [[Range §g+7§d, Range Power §g+177%
Player's Bullet will §bconstantly rotate]],
            detail = [[Range §g+7§d, Range Power §g+177%
Player's Bullet will §bconstantly rotate]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [158] = {
            stitle = [[Structural-formula Error]],
            sdes = [[Player's Bullets become §ySpecial bullets
§-*Player's Bullets get unclear characteristics*]],
            detail = [[Player's Bullets randomly gain the following §b1~2§d characteristics:
bullet image size §b*50%~200%
bullet dmg §b*0%~250%
bullet speed §b*25~50%
bullet range §b*50%~200%
bullet color §brandom]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
    {
        [2] = {
            stitle = [[Lightweight, Fast, More Convenient!]],
            sdes = [[Spell Maxenergy §g-7%]],
            detail = [[§gSpell Maxenergy -7%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Use §p5§d Bombs in one game]],
            condd = nil,
        },
        [5] = {
            stitle = [[Joy of harvest]],
            sdes = [[Restores a small amount of Life each second]],
            detail = [[Note §ya=1
Restore §ga*0.1/60§d Life / f]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [6] = {
            stitle = [[Kamikaze!]],
            sdes = [[A large explosion will occurs if Player MISS
clearing bullets and causing dmg to the enemies]],
            detail = [[Note §ya=1
When Player MISS, creates a lasting §b45 f§d circle
with a radius of §ga*75§d, dealing §b10%a ATK§d dmg / f]],
            repeatd = [[§ya§d+1]],
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [20] = {
            stitle = [[Defensive attack]],
            sdes = [[When Player is in Invincibility, ATK §g+35%]],
            detail = [[Note §ya=1
When Player is in Invincibility, ATK §g+a*35%]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [23] = {
            stitle = [[Bloodthirsty fury]],
            sdes = [[The lower percentage of Maxlife, the higher dmg dealt to enemies]],
            detail = [[Note §ya=1§d, §yp=Current-life/Maxlife
dmg dealt to enemies is multiplied by §g1+(1-p)*(0.5+a/3)
§-This dmg Power will not be displayed in the ATK]],
            repeatd = [[§ya§d+1]],
            tags = t.sacrifice,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [35] = {
            stitle = [[Meow Meow Meow! Good Luck Comes!]],
            sdes = [[Each wave increases Luck based on current Luck]],
            detail = [[Note §ya=Luck
Each wave passed increases Luck by §g(-a+100)/60§d
with a maximum increase of §b1]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [38] = {
            stitle = [[Others can't see you]],
            sdes = [[Hitbox §gdecreases§d, Player's image becomes §rtransparent]],
            detail = [[Note §ya=1
Hitbox §g-0.1a
Player image opacity Power §r-a*33%]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [49] = {
            stitle = [[Fantasy mountain wind]],
            sdes = [[Speed §b+0.25
§g5%§d chance to make enemies' bullets semi-transparent, §glosing hitbox]],
            detail = [[Note §ya=1
Speed §b+0.25a
§g5%§d chance to make enemies' bullets semi-transparent, §glosing hitbox]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [57] = {
            stitle = [[Heavy collector]],
            sdes = [[Whenever an EXP is picked up, a random beneficial effect is gained
Multiple pickups unlock more §gbeneficial effects]],
            detail = [[Whenever an EXP is picked up, a random effect is triggered:
Life §g+0.03§d, EXP §g+0.2§d, score §g+0.01%
Spell Energy §g+0.2%§d, EXP §g+0.5§d, Luck §g+0.004§-(2)
Life §g+0.08§d, ATK §g+0.01§d, Maxlife §g+0.02§-(3)]],
            repeatd = [[Unlock §-(2)§d with 2 stacks, unlock §-(3)§d with 3 stacks]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [59] = {
            stitle = [[Backdoor country]],
            sdes = [[Adds a backdoor behind Player, which will §gclear§d bullets]],
            detail = [[Adds a backdoor behind Player
Any bullets that touch it will §gbe cleared]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [60] = {
            stitle = [[Connecting moon and sea]],
            sdes = [[Creates a collapse space around Player
Bullets close to Player have a §b20%§d chance to be §bteleported]],
            detail = [[Bullets close to Player have a §b20%§d chance to be §bteleported to any position
The speed and direction of the teleported bullets remain unchanged]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[Defeat §p"Yakumo Yukari" once]],
            condd = nil,
        },
        [70] = {
            stitle = [[Ground the Sun]],
            sdes = [[Forms a "Sun" at the bottom
             To avoid the "sun", many things will tend to §bmove upwards]],
            detail = [[Forms a sun at the bottom of the screen
Enemies with "life signs", enemy bullets, and EXP §bwill tend to move upwards
and will be directly cleared upon touching the bottom
§-They all want to avoid being destroyed by the Sun!]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [75] = {
            stitle = [[Secret burial]],
            sdes = [[All Bubbles §gno longer damage to Player]],
            detail = [[All Bubbles §gno longer damage to Player]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-Blood Magic§d: All Bubbles turn red]],
            unlockd = nil,
            condd = nil,
        },
        [79] = {
            stitle = [[Tooth for Tooth]],
            sdes = [[Whenever Player loses Life, deal §g35% ATK§d dmg to all enemies
Has a §b1.0 seconds§d cooldown]],
            detail = [[Whenever Player loses Life, deal §g35% ATK§d dmg to all enemies
Has a §b60 f§d cooldown]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = nil,
            unlockd = [[Die §p1§d time]],
            condd = nil,
        },
        [82] = {
            stitle = [[Quiet sea, Floating moon]],
            sdes = [[§gAllows Player to move outside the screen§d for a short time
Speed §b+0.35]],
            detail = [[§gAllows Player to move outside the screen
The longer Player stays outside
the stronger repulsion that forces Player back inside
Speed §b+0.35]],
            repeatd = nil,
            tags = t.tp,
            collabd = nil,
            unlockd = [[Obtain §g"The Riftzone"]],
            condd = nil,
        },
        [91] = {
            stitle = [[Automatic holistic shooting]],
            sdes = [[Every time §b110§d Player's Bullet appear, Player will fire bloom bullets]],
            detail = [[Note §ya=1
Every time §b110§d Player's Bullet appear on the screen
Player will fire §g9a§d bloom Player's Bullets]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [92] = {
            stitle = [[Winter is coming]],
            sdes = [[When enemy died, snowflakes will fall from the top, causing §g1+25% ATK§d dmg]],
            detail = [[When enemy died, §b1~2§d snowflakes fall from the top of the screen
each causing §g1+25% ATK§d dmg
§-The top of the screen slightly turns blue]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-Blood Magic§d: Snowflakes turn pink
§gSolar Flare§d: Snowflakes gradually become transparent]],
            unlockd = [[Have both §b"⑨ Blessings"§d and §p"Ice Fairy"§d in one game]],
            condd = nil,
        },
        [95] = {
            stitle = [[Terrifying gaze]],
            sdes = [[Generates 3 Sekibanki's heads that automatically rotate around the enemy
Deals §g960% ATK§d dmg / s]],
            detail = [[Generates §b3§d Sekibanki's heads
that automatically seek and rotate around the enemy
Deals §g16% ATK§d dmg / f]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [97] = {
            stitle = [[Multicolored bullets]],
            sdes = [[Surrounds an enemy with color bullets, each causing §g20% ATK§d dmg]],
            detail = [[Select an enemy and fire color bullets every §b5f§d
Each bullet causes §g20% ATK§d dmg]],
            repeatd = nil,
            tags = t.neet,
            collabd = [[§bMemory Forge§d: When color bullets reach §b50%§d of the range, reverse their speed direction]],
            unlockd = [[Cap §p"神宝「耀眼的龙玉」"]],
            condd = nil,
        },
        [99] = {
            stitle = [[Calm heart]],
            sdes = [[Fires fireballs backwards while moving, each causing §g48% ATK§d dmg]],
            detail = [[Whenever Player moves, fire tiny fireballs every §b3f§d in the opposite direction
Each fireballs causes §g48% ATK§d dmg]],
            repeatd = nil,
            tags = t.neet,
            collabd = [[§pRebirth's Tail§d: Reduced firing intervals after resurrect, with a minimum of §g1f§d
§pLured Yomi§d: Flame bullets gain a small tracking effect]],
            unlockd = [[Cap §p"神宝「火蜥蜴之盾」"]],
            condd = nil,
        },
        [103] = {
            stitle = [[Am I moving further from the Sun?]],
            sdes = [[Extend all seasons §b1 wave]],
            detail = [[Extend all seasons §b1 wave]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Cleared §b"Sea of Tranquility"§d scene once]],
            condd = [[Season system exists]],
        },
        [104] = {
            stitle = [[Weathering with you]],
            sdes = [["Auspicious" type weather has a §g25%§d higher chance of appearing]],
            detail = [["Auspicious" type weather appearance probability is §g25%§d higher]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[Season system exists]],
        },
        [109] = {
            stitle = [[Controllable future]],
            sdes = [[When clearing bullets, randomly clear §g1§d additional bullet of the same type]],
            detail = [[When clearing bullets, §grandomly clear 1 additional bullet of the same type]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [110] = {
            stitle = [[Remove your filth]],
            sdes = [[When enemies died, clear the closest §g1§d bullet
Clear all bullets on the screen when Player's Life reaches §r0§d]],
            detail = [[When enemies died, §gclear the closest 1 bullet
Clear all bullets on the screen when Player's Life reaches §r0§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [117] = {
            stitle = [[Unbreakable wall]],
            sdes = [[Invincibility time gained from MISS or Upgrading §g+0.43s]],
            detail = [[Invincibility time gained from MISS or Upgrading §g+26f]],
            repeatd = nil,
            tags =  { t.neet, t.defend },
            collabd = [[Pseudo Paradise: The doll gains an additional §g30 f§d
of Invincibility time upon generation]],
            unlockd = [[Cap §p"神宝「佛体的金刚石」"]],
            condd = nil,
        },
        [118] = {
            stitle = [[Injured?]],
            sdes = [[When Player MISS, just retain half of Invincibility time
Health is only lost after §b99f§d with full Invincibility time]],
            detail = [[When Player MISS, just retain half of Invincibility time
Health is only lost after §b99f§d with full Invincibility time]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [120] = {
            stitle = [[x = x]],
            sdes = [[When Player firing, §g7%§d chance to fire §b1§d Player's Bullet in random
Each Item §g+0.32% chance]],
            detail = [[When Player firing, §g7%§d chance to fire §b1§d Player's Bullet in random
Each Item §g+0.32% chance]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [121] = {
            stitle = [[I can't see forever!]],
            sdes = [[A black circular area appears around Player
Dmg dealt to enemies is multiplied by §g75%]],
            detail = [[A black circular area appears around Player
Dmg dealt to enemies is multiplied by §g75%]],
            repeatd = nil,
            tags = nil,
            collabd = [[§bThe Pagodlight§d: The black circle continuously expands outward]],
            unlockd = GongFeng,
            condd = nil,
        },
        [138] = {
            stitle = [[Forgotten abandoned thing]],
            sdes = [[Gain a following minion
Each wave, randomly gain §-(fully stacked)§d temporary Item]],
            detail = [[Gain a following minion
Each wave, randomly gain §-(fully stacked)§d temporary Item]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [141] = {
            stitle = [[Alice's baby]],
            sdes = [[Gain a doll following minion
Shoots small bullets in four diagonal directions, dealing §g1.0§d dmg]],
            detail = [[Gain a doll following minion
Shoots small bullets in four diagonal directions, dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [145] = {
            stitle = [[My Name is Fashion]],
            sdes = [[Gain a dumpling following minion
Fires short-range spread bullets, each dealing §g1.0§d dmg]],
            detail = [[Gain a dumpling following minion
Fires short-range spread bullets, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = { t.siyuan, t.baby },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [146] = {
            stitle = [[Bottomless indulgence]],
            sdes = [[Shootspeed §g+1.4
Rotate Player firing direction at a angular speed, §gauto-aiming at enemies]],
            detail = [[Note: §ya=BulletVel
Shootspeed §g+1.4
Rotate Player firing direction at a 2*a°/s speed, §gauto-aiming at enemies]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [148] = {
            stitle = [[Embarrassed]],
            sdes = [[Gain a cat following minion
Fires bullets downward, each dealing §g1.0§d dmg]],
            detail = [[Gain a cat following minion
Fires bullets downward, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [149] = {
            stitle = [[Someday...]],
            sdes = [[Gain a fume-shroom following minion
Fires bullets backwards from Player, each dealing §g1.0§d dmg]],
            detail = [[Gain a fume-shroom following minion
Fires bullets backwards from Player, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [154] = {
            stitle = [[Passionate shoooot]],
            sdes = [[ATK Power §r-80%§d
Shootspeed §g+1§d, Shootspeed Power §g+150%§d]],
            detail = [[ATK Power §r-80%§d
Shootspeed §g+1§d, Shootspeed Power §g+150%§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Passing §pChallenge 6]],
            condd = nil,
        },
        [156] = {
            stitle = [[Worship]],
            sdes = [[ATK §g+0.2§d, gain a GG following minion
Fires bullets downward, each dealing §g1.0§d dmg]],
            detail = [[ATK §g+0.2§d, gain a GG following minion
Fires bullets downward, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = { t.siyuan, t.baby },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [159] = {
            stitle = [[Shield from wind and rain]],
            sdes = [[Whenever Player MISS, generate an umbrella §gto clear bullets
Umbrella lasts §b75 f§d, cooldown time §b105 f§d]],
            detail = [[Whenever Player takes dmg, generate an umbrella §gto clear bullets
Umbrella lasts §b75 f§d, cooldown time §b105 f§d]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = [[§gSolar Flare§d: The umbrella floats upwards]],
            unlockd = [[Defeated §r"Tatara Kogasa" once]],
            condd = nil,
        },
        [160] = {
            stitle = [[...]],
            sdes = [[Generate §gauto-aiming bullets when gaining EXP
Each bullet deals §g0.7§d dmg]],
            detail = [[Generate §gauto-aiming bullets when gaining EXP
Each bullet deals §g0.7§d dmg]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Passing §pChallenge 2]],
            condd = nil,
        },
        [163] = {
            stitle = [[Going with the flow]],
            sdes = [[Gain a lazy child following minion, doing nothing
Gain §gthe same number of lazy child§d at the start of the next game]],
            detail = [[Gain a lazy child following minion, doing nothing
Gain §gthe same number of Dead Baby§d at the start of the next game]],
            repeatd = nil,
            tags = { t.siyuan, t.baby },
            collabd = nil,
            unlockd = [[Passing §pChallenge 4]],
            condd = nil,
        },
        [165] = {
            stitle = [[Irreversible]],
            sdes = [[Generate §g3§d disks that can clear bullets at each wave
After clearing bullets, they have a chance to shatter and shoot up many §gbullets]],
            detail = [[Note: §ya=Number of bullets cleared by the disk
Generate §g3§d disks that can clear bullets at each wave
After clearing bullets, they have a §b0.5a%§d chance of shattering
Shooting §ya§d bullets upward, each dealing §g120% ATK§d dmg]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [167] = {
            stitle = [[Cute, isn't it?]],
            sdes = [[Gain a rotating cat minion
Deals §g12% ATK§d contact dmg to enemies]],
            detail = [[Gain a rotating cat minion
Deals §g12% ATK§d contact dmg to enemies]],
            repeatd = nil,
            tags = t.siyuan,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [168] = {
            stitle = [[Yellow bean soul's bun]],
            sdes = [[Gain a yellow-bean cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            detail = [[Gain a yellow-bean cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Defeated §p"Ringo" once]],
            condd = nil,
        },
        [169] = {
            stitle = [[Seeker bun]],
            sdes = [[Gain a red-bean cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            detail = [[Gain a red-bean cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Defeated §p"Ringo" once]],
            condd = nil,
        },
        [170] = {
            stitle = [[Desirer bun]],
            sdes = [[Gain a green-bean Cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            detail = [[Gain a green-bean Cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Defeated §p"Ringo" once]],
            condd = nil,
        },
        [171] = {
            stitle = [[Lover bun]],
            sdes = [[Gain a blue-bean Cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            detail = [[Gain a blue-bean Cat minion, circling around Player
When shooting, the cat flies out to attack enemies, causing §g30% ATK§d dmg]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Defeated §p"Ringo" once]],
            condd = nil,
        },
        [172] = {
            stitle = [[/tp self ~ ~ ~]],
            sdes = [[Upgrade by §g1§d level upon pickup
Reduces EXP required for each level by §g1§d level]],
            detail = [[Upgrade by §g1§d level upon pickup
Reduces EXP required for each level by §g1§d level]],
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
            stitle = [[Perfectionist's knife show]],
            sdes = [[Shoots auto-aiming throwing knives from the bottom]],
            detail = [[Note: §ya=1
Throwing knife interval is §b({14,9,6})[a]§df,
Deals §g(a/3*0.5+0.3)*100% ATK§d dmg]],
            repeatd = [[§ya§d+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [17] = {
            stitle = [[Deadly embrace]],
            sdes = [[§gNo longer MISS by Enemy
and deals §g100% ATK§d dmg to enemies every §b15f§d when close]],
            detail = [[§gNo longer MISS by Enemy
and deals §g100% ATK§d dmg to enemies every §b15f§d when close]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[MISS by enemy §p5§d times]],
            condd = nil,
        },
        [22] = {
            stitle = [[Vampire Knives]],
            sdes = [[Restore Life based on the enemy's Life when killing enemies]],
            detail = [[Note: §ya=1
Restores §g16a%§d of Enemy's Maxlife when killing enemies]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [25] = {
            stitle = [[Magic aura of power]],
            sdes = [[A magic aura follows Player
While in the aura, ATK §g+50%§d, Speed §r-15%]],
            detail = [[A magic aura follows Player
While in the aura, ATK §g+50%§d, Speed §r-15%§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [30] = {
            stitle = [[...What's the cost?]],
            sdes = [[When the Spell Energy is sufficient, you can use Energy §gto negate MISS
But if Spell Energy is insufficient, it will increase the dmg received]],
            detail = [[Note: §ya=Number of Spell Stack
Whenever MISS, if Spell Energy > 70a%,
it will §gnot reduce Life§d, instead, §rsubtract 10a% of Energy§d
Each time this Item is triggered,
the next trigger will §rsubtract an extra 10a% of energy§d,
with a maximum of §b70a%§d energy deducted;
If Spell Energy is insufficient, the dmg received will be §r15a% higher]],
            repeatd = [[Maximum deducted energy amount §g-30a%
Reduced dmg when energy is insufficient §g-5a%]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[Use §p5§d Bombs]],
            condd = nil,
        },
        [44] = {
            stitle = [[Smooth sailing]],
            sdes = [[When Player MISS,
Only increase the §g66% of the originally added Chaos]],
            detail = [[When Player MISS,
Only increase the §g66% of the originally added Chaos]],
            repeatd = nil,
            tags = t.chaos,
            collabd = nil,
            unlockd = [[Chaos reach §r200%]],
            condd = nil,
        },
        [45] = {
            stitle = [[999999999]],
            sdes = [[Offer various bonuses from the little genius!
"Aren't you going to thank me yet?"]],
            detail = [[Spell energy §g-0.9%
Restore §g9§d Life
Maxlife §g+9
ATK & Speed §g+0.9
Hitbox §g-0.09
Chaos §g-0.9%
"Ice Fairy"§d's proba  §g+9x]],
            repeatd = nil,
            tags = t.nine,
            collabd = nil,
            unlockd = [[Obtain §b9§d Items with §-"9"§d tag]],
            condd = nil,
        },
        [52] = {
            stitle = [[Who?]],
            sdes = [[Creates a Fake Player at the screen shooting bullets
Moves differently from Player]],
            detail = [[Reduces Player Transparency Power §r-30%
Creates a Fake Player at Player's position, moving with Player
At the start of each wave, Fake Player returns to Player
At High-Speed, Fake Player's speed is §b1.5§d times Player's Speed,
and at Low-Speed, it is §b0.8§d times
Fake Player shoots bullets identical to Player's Bullet but at §b1/3§d ShootRate]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Upgrade any Character to §y5§d]],
            condd = nil,
        },
        [55] = {
            stitle = [[The fearsome secret of both sides]],
            sdes = [[ATK §g+0.5§d, ATK Power §g+25%
While shooting, Player's Life will slowly lose]],
            detail = [[ATK §g+0.5§d, ATK Power §g+25%
While shooting, Player's Life will slowly lose]],
            repeatd = nil,
            tags = t.sacrifice,
            collabd = nil,
            unlockd = [[Die §p10§d times]],
            condd = nil,
        },
        [61] = {
            stitle = [[Overflow of fantasy]],
            sdes = [[Enemy bullets have a chance to turn into §ySpecial Bullets
§-*These bullets can gain obscure characteristics*]],
            detail = [[Enemy bullets have a §b30%§d chance to turn into §ySpecial Bullets§d,
randomly gaining the following §b1~2§d characteristics:
Change bullet style every §b10~22f§d
Change bullet color every §b10~30f§d
Every §b120~300f§d, there's a §b50%§d chance to reverse speed
Every §b150~300f§d, bullet size changes to §b0.5~1.2§d times
May Stay in place for §b0~300f§d and disappear after §b120f§d
Every §g20f§d, there's a §g5%§d chance to turn into EXP]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [62] = {
            stitle = [[Primary mission: Extermination]],
            sdes = [[Each wave provides a §y"ToDo Graze"§d task,
Complete the task to receive a random 1 Quality or higher Item]],
            detail = [[Note: §ya=Current Wave
Each wave provides a §y"ToDo Graze"§d task,
complete it to receive a random 1 Quality or higher Item
§y"ToDo Graze"§d: During pickup, must graze §b100+5a§d bullets,
For other waves, must graze §b0.8*previous wave's graze count+a^2§d bullets]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Graze a total of §p1000§d bullets in one game]],
            condd = nil,
        },
        [71] = {
            stitle = [[The power of small wheelchair]],
            sdes = [[Range §g+7
Allows Player's Bullet to §gshuttle once]],
            detail = [[Range §g+7
Allows Player's Bullet to §gshuttle once]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Accumulate a total of §p5§d times for §g"The Hidden"]],
            condd = nil,
        },
        [73] = {
            stitle = [[Eight-tenths full]],
            sdes = [[Each Graze increases Graze Range by §g1%§d, up to a maximum of §r200%
If don't Graze within §b10f§d, Graze Range gradually decreases to the original state]],
            detail = [[Note: §ya=0§-(Maximum 200)
Graze Range increases by §ga%§d, Each Graze makes §ga+1
If don't Graze within §b10f§d,
Graze Range gradually decreases to the original state]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Graze a total of §p2000§d bullets in one game]],
            condd = nil,
        },
        [76] = {
            stitle = [[Local specialty of the mountain]],
            sdes = [[Restore §g25§d Life
Item collect line drops by §g64]],
            detail = [[Restore §g25§d Life
Item collect line drops by §g64]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Upgrade any Character to §y10§d]],
            condd = nil,
        },
        [78] = {
            stitle = [[Visualized self activity]],
            sdes = [[Generates §g3§d translucent circular minions that rotate around Player
Press §-Slow Key§d to shoot bullets, §gdealing certain dmg]],
            detail = [[Note §ya=Number of presses within one sec of §-Slow Key§y, §yb=3
Generates §gb§d translucent circular minions,
Which rotate around Player on a track, leaving a trailing line following Player
At High-Speed, these minions have a larger rotation radius;
At Low-Speed, they converge at Player's Hitbox.
Press §-Slow Key§d to shoot bullets,
Which spread outward from Player's position after §b60f§d.
Each bullet deals §g6a^2% ATK§d dmg]],
            repeatd = [[b+3]],
            tags = t.store,
            collabd = [[§bThe Pagodlight§d: Player loses the aura,
and the minion of The Pagodlight gains a smaller range aura]],
            unlockd = nil,
            condd = nil,
        },
        [80] = {
            stitle = [[Easily exploded!]],
            sdes = [[Restores §g7§d Life every time Player uses a bomb]],
            detail = [[Note §ya=1
Restores §g7a§d Life every time Player uses a bomb]],
            repeatd = [[§ya§d+1]],
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = [[Use §p15§d Bombs]],
            condd = nil,
        },
        [81] = {
            stitle = [[A drop of EXP, Ten drops of blood]],
            sdes = [[Restores §g(Current Level)%§d Life upon Upgrading
Maximum restoration is §b50%§d of Maxlife]],
            detail = [[Note §ya=Current Level§-(max 50)
Restores §ga%§d Life upon Upgrading]],
            repeatd = nil,
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = [[Reach level §p20§d in one game]],
            condd = nil,
        },
        [85] = {
            stitle = [[HP = EXP]],
            sdes = [[Generates §g1§d EXP in front of Player each time Player loses §b2.85% of Maxlife§d]],
            detail = [[Generates §g1§d EXP in front of Player each time Player loses §b2.85% of Maxlife§d]],
            repeatd = nil,
            tags = { t.sacrifice, t.store },
            collabd = nil,
            unlockd = [[Reach level §p25§d in one game]],
            condd = nil,
        },
        [87] = {
            stitle = [[Infinite growth]],
            sdes = [[Picking up Lifechips additionally increases Maxlife by §g7]],
            detail = [[Picking up Lifechips additionally increases Maxlife by §g7]],
            repeatd = nil,
            tags = { t.life, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [94] = {
            stitle = [[Power wide-coverage]],
            sdes = [[ATK Power §r-34%§d, ShootRate §g+1§d, ShootRate Power §g+50%§d
Player's Bullet scatter angle §b+15°§d]],
            detail = [[ATK Power §r-34%§d
ShootRate §g+1§d, ShootRate Power §g+50%§d
Player's Bullet scatter angle §b+15°§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [114] = {
            stitle = [[Eternal life line]],
            sdes = [[dmg taken increases by §r50%§d, and injured health turns into §pPhantom Blood
§pPhantom Blood§d can §gself-heal]],
            detail = [[dmg taken increases by §r50%§d
Injured health turns into dark green §pPhantom Blood§d,
 which recovers §g1/6§d of §pPhantom Blood§d every second
All §pPhantom Blood§r is reset to zero when taking dmg again
Collecting Lifechips will §gimmediately restore §pPhantom Blood]],
            repeatd = nil,
            tags = { t.defend, t.neet, t.life, },
            collabd = [[§bThe Bloodhex§d: Lost blood turns into Phantom Blood]],
            unlockd = [[Cap §p"神宝「无限的生命之泉」"]],
            condd = nil,
        },
        [116] = {
            stitle = [[Hitbox singularity]],
            sdes = [[Player image and hitbox §b*75%§d, Speed §r-0.45
Makes §b"Zephyros"§r"Typhoon"§d weather ineffective]],
            detail = [[Player image and hitbox §b*75%§d, Speed §r-0.45
Makes §b"Zephyros"§r"Typhoon"§d weather ineffective]],
            repeatd = nil,
            tags = nil,
            collabd = [[§-MAX M§d: Increased gravity]],
            unlockd = [[Cap §p"「阿波罗11的捏造」"]],
            condd = nil,
        },
        [119] = {
            stitle = [[Unity of nothingness]],
            sdes = [[Pressing §-Slow Key§d
can make the two closest bullets §breverse their hitboxes]],
            detail = [[Pressing §-Slow Key§d
can make the two closest bullets §breverse their hitboxes]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[Defeat §p"Yukari Yakumo"§d once]],
            condd = nil,
        },
        [122] = {
            stitle = [[Backtracking bullets]],
            sdes = [[ShootSpeed §g+0.7§d, Range Power §g+100%§d
When bullets reach §b50% range§d, they reverse their speed direction]],
            detail = [[ShootSpeed §g+0.7§d, Range Power §g+100%§d
When bullets reach §b50% range§d, they reverse their speed direction]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [135] = {
            stitle = [[Scarlet mourning]],
            sdes = [[When enemies died, leave a §rred aura§d at the spot
The aura deals §g3% ATK§d dmg every §g(66/ShootSpeed)f§d]],
            detail = [[When enemies died, leave a §rred aura§d at the spot
The aura deals §g3% ATK§d dmg every §g(66/ShootSpeed) f§d
and disappears after §g45 f§d
The aura size is proportional to the enemy's Hitbox]],
            repeatd = nil,
            tags = t.store,
            collabd = [[§pScarlet Focus§d: Increases aura range]],
            unlockd = nil,
            condd = nil,
        },
        [139] = {
            stitle = [[Reimu baby]],
            sdes = [[Gain a Reimu following baby
Shoots §gtracking bullet§d, dealing §g2.0§d dmg]],
            detail = [[Gain a Reimu following baby
Shoots §gtracking bullet§d, with a flight time of §b75f§d, dealing §g2.0§d dmg]],
            repeatd = nil,
            tags = { t.baby, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [140] = {
            stitle = [[Marisa baby]],
            sdes = [[Gain a Marisa following baby
Shoots §gsmall missiles§d, dealing §g6.0§d dmg]],
            detail = [[Gain a Marisa following baby
Shoots §gsmall missiles§d, with a flight time of §b112f§d, dealing §g6.0§d dmg]],
            repeatd = nil,
            tags = { t.baby, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [144] = {
            stitle = [[Fallback route]],
            sdes = [[Has a chance to additionally shoot Player's Bullet backward]],
            detail = [[Note: §ya=Luck
Has a §g9/(101-a)*100%§d chance to additionally shoot Player's Bullet backward]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [147] = {
            stitle = [[Shion Cat]],
            sdes = [[Gain a Cat-type following baby
Sprays small bullets rhythmically upward, each dealing §g1.0§d dmg]],
            detail = [[Gain a Cat-type following baby
Sprays small bullets rhythmically upward, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [152] = {
            stitle = [[Soaring skyward]],
            sdes = [[ATK §g+1.5§d, Player's Bullet changes to §yRocket§d,
starting with a speed of 0 and accelerating to 200% BulletVel]],
            detail = [[ATK §g+1.5§d, Player's Bullet changes to §yRocket§d,
starting with a speed of 0 and accelerating to 200% BulletVel]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Passing §pChallenge 3]],
            condd = nil,
        },
        [155] = {
            stitle = [[Blessing of the sea]],
            sdes = [[Randomly gain one of §g7 effects
Effects are §-non-repetitive]],
            detail = [[Randomly gain one of the following effects §-(non-repetitive)§d:
§rRed  Maxlife +10
§oOrange  Delete 3 Infringes
§yYellow  Shorten summer 1 wave
§gGreen  Restore 25 Life
§cCyan  Gain 3 Benefits
§bBlue  Shorten winter 1 wave
§pPurple  Fix 3 Broken Items]],
            repeatd = [[prob §g+5x]],
            tags = t.life,
            collabd = nil,
            unlockd = [[Passing §pChallenge 5]],
            condd = nil,
        },
        [157] = {
            stitle = [[Taunt]],
            sdes = [[ShootRate §g+0.9§d, gain a Cat-type following baby
Shoots tracking bullets, each dealing §g0.8§d dmg]],
            detail = [[ShootRate §g+0.9§d, gain a Cat-type following baby
Shoots tracking bullets, each dealing §g0.8§d dmg]],
            repeatd = nil,
            tags = t.baby,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [164] = {
            stitle = [[Inside the Moon]],
            sdes = [[Generate a §ybullet-dissipating moon§d at Player's position
When the moon touches bullets, it shrinks and disappears and regenerate]],
            detail = [[Generate a §ybullet-dissipating moon§d at Player's position
When the moon touches bullets, it shrinks and disappears
After disappearing for §b85 f§d, it will fully generate within §b120 f§d]],
            repeatd = nil,
            tags = t.defend,
            collabd = [[§bThe Eternalua§d: The moon turns red]],
            unlockd = [[Defeat §y"Luna Child"§d once]],
            condd = nil,
        },
        [166] = {
            stitle = [[No support for japanese]],
            sdes = [[Every §b200 f§d generates a §r"異議あり！"§d
Finds the highest Life non-boss enemy on the screen and §yinstant-kills§d it]],
            detail = [[Every §b200 f§d generates a §r"異議あり！"§d
Finds the highest Life non-boss enemy on the screen and §yinstant-kills§d it]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [173] = {
            stitle = [[EXP in the sky]],
            sdes = [[EXP Rate §g+50%
EXP falling speed §r+75%]],
            detail = [[EXP Rate §g+50%
EXP falling speed §r+75%]],
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
            stitle = [[Daring to face]],
            sdes = [[Add an Otter around Player that can §gclear bullets§d]],
            detail = [[Add an Otter around Player that can §gclear bullets§d]],
            repeatd = [[Otter +1]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [21] = {
            stitle = [[Turning nothing into something]],
            sdes = [[EXP may drop when Player grazes bullets]],
            detail = [[Note §ya=1
When grazing bullets, there is a §ga*15%§d chance to drop EXP]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [24] = {
            stitle = [[Omnidirectional shooting]],
            sdes = [[Gain 1 Ice Bullet Minion that shoots Ice Bullets
Each bullet deals §g35% ATK§d dmg]],
            detail = [[Note §ya=1
Gain 1 Ice Bullet Minion that shoots Ice Bullets,
each dealing §g35% ATK§d dmg
Shooting interval is §b({12,8,6})[a]§d f
Interval of shots is §b({9,9,12})[a]§d]],
            repeatd = [[§ya§d+1]],
            tags = t.nine,
            collabd = nil,
            unlockd = [[Defeat §b"Cirno"§d once]],
            condd = nil,
        },
        [26] = {
            stitle = [[Sensitive treasure hunter]],
            sdes = [[Periodically generates a rotating expanding golden pendulum
When it touches enemies, it §ggenerates some EXPs§d and deals §gdmg§d to the enemies]],
            detail = [[Note §ya=1
Every §b355-55*a f§d , generate §g3§d golden pendulums around Player
deals §g30+10*a% ATK§d dmg/f and §ggenerates some EXPs]],
            repeatd = [[§ya§d+1]],
            tags = t.store,
            collabd = nil,
            unlockd = [[Reach §pLevel 15§d in one game]],
            condd = nil,
        },
        [29] = {
            stitle = [[Clearance Sale!]],
            sdes = [[When shooting, an additional §yultra-flash penetrating prayer light§d is shooted.
Each time you obtain this Item, there is a chance to get an additional one]],
            detail = [[prob §g+10x
Note §ya=1
When Player don't move, a laser is generated within the range of
§b0°§d forward and §b(a/17*135)°§d to the left and right of Player
deals §g(50-a/17*30)%§d ATK dmg/f, lasting for §g(187-4a) f§d
The laser's opacity is §b(80-a/17*40)%
Each time you obtain this Item, there is a §g(17+6a)%§d chance to Buy for FREE
When a=17, a §ylight effect§d appears behind Player]],
            repeatd = [[a+1
prob §g+10x]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [37] = {
            stitle = [[United in hearts, Invincibility at costs]],
            sdes = [[When health is sufficient,
you can convert Life to charge and §grelease Spell]],
            detail = [[Note §ya=Spell Maxenergy - Spell Energy§d, §yb=Maxlife
When Spell Energy is insufficient to release Spell,
You can press the Spell button to consume §r(a+b)/8§d Life to
§grelease Spell§d and §rempty the Spell energy§d
§-(Does not count as dmg, ineffective if it would be fatal)]],
            repeatd = nil,
            tags = t.store,
            collabd = [[§gNitroglycerin§d: Using §pHeart-link§d to release Spell will restore §g5§d Life]],
            unlockd = nil,
            condd = nil,
        },
        [50] = {
            stitle = [[Destiny and underworld unified]],
            sdes = [[When taking fatal dmg,Restore §g50%§d Life, but Maxlife decreases by §r50%§d
Limited to once per wave]],
            detail = [[When taking fatal dmg, §gnegate that dmg§d,
Restore §g50%§d Life, but Maxlife decreases by §r50%§d
§rLimited to once per wave]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[Defeat §p"Yakumo Yukari"§d once]],
            condd = nil,
        },
        [53] = {
            stitle = [[Rolling in the deep]],
            sdes = [[§bAll entities on the screen gradually lose Life
Will lead to Player's §rdeath]],
            detail = [[§bAll entities on the screen gradually lose Life
The enemies lose §r min {33.33% of Maxlife, 54} /s.
Player loses §r max {1.03% of Maxlife, 0.514} /s.
Will lead to Player's §rdeath]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = [[Can only be obtained through §r"Lumia"§d drops]],
        },
        [63] = {
            stitle = [[Antiquated fantasy]],
            sdes = [[When Player donot MISS for a period of time, generate §g1§d doll, maximum is §b9§d
Dolls will §gattack enemies§d and also §gblock several bullets§d]],
            detail = [[Note §ya=Doll Count
When Player donot MISS for §b30+25a f§d, generate §g1§d doll, maximum is §b9§d
Each time Player MISS, §r110f§d cooldown is enforced,
during which no dolls are generated.
Dolls will shoot §g1§d bullet dealing §g0.5a+50% ATK§d dmg to enemies every §b75f§d
Dolls have a §g30-f§d Invincibility time when generated, can block bullets
In Non-Invincibility, they block §g3§d bullets or disappear if hit by enemy]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = [[§gVitaBlast Tonic§d: Generates a small explosion when dolls disappear
§gBuddhist Diamond§d: Extends the Invincibility time of dolls by §p30f]],
            unlockd = GongFeng,
            condd = nil,
        },
        [72] = {
            stitle = [[When I see you ...]],
            sdes = [[Range §g+7§d, BulletVel §r-2.5
Player's Bullet gains §gtracking effect]],
            detail = [[Range §g+7§d, BulletVel §r-2.5§d
Player's Bullet gains §gtracking effect]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [74] = {
            stitle = [["Revival"]],
            sdes = [[Upon death, Player can resurrect through a period of §y"Rebirth"§d
§gNo limit on the number of times]],
            detail = [[Upon death, enter §y"Rebirth"§d status
§y"Rebirth"§d:
§rSignificantly reduced ATK and cannot release Spells§d, lasts for §b4.43 s
If hit, Player will die immediately
Afterward, Player recovers §g50%§d Life.
§gThis Item has no usage limit]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[Resurrection priority is §y-1§-(higher priority triggers first)]],
            unlockd = [[Die §p5§d times]],
            condd = nil,
        },
        [77] = {
            stitle = [[Rebound bullet]],
            sdes = [[Range §g+7§d
Allows Player's Bullet to §grebound infinitely]],
            detail = [[Range §g+7§d
Allows Player's Bullet to §grebound infinitely]],
            repeatd = nil,
            tags = nil,
            collabd = [[§bPortal Back§d: Triggers shuttle first, then rebound]],
            unlockd = GongFeng,
            condd = nil,
        },
        [84] = {
            stitle = [[Rewind]],
            sdes = [[When Player dies, §grewinds to the previous wave§d, and this Item §-damaged]],
            detail = [[When Player dies, §grewinds to the previous wave§d, and this Item §-damaged
§-This Item is ineffective in the first wave
§-After rewinding, this Item has at least one wave of cooldown]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[Resurrection priority is §y2§-(higher means it triggers earlier)]],
            unlockd = GongFeng,
            condd = nil,
        },
        [89] = {
            stitle = [[Totem of Undying?]],
            sdes = [[When Chaos exceeds §r30%§d, reduces Chaos by §g30%
Triggers once, then §-breaks]],
            detail = [[When Chaos exceeds §b30%§d, reduces Chaos by §g30%
Triggers once, then §-breaks]],
            repeatd = nil,
            tags = { t.chaos, t.store },
            collabd = nil,
            unlockd = [[Chaos reach §p150%]],
            condd = nil,
        },
        [93] = {
            stitle = [[Blessing of the wind]],
            sdes = [[When Player's Bullet is close to the enemy and misses,
it will §gturn 90° to target the enemy]],
            detail = [[When Player's Bullet is close to the enemy and misses,
it will §gturn 90° to target the enemy]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [96] = {
            stitle = [[Firepower advantage theory]],
            sdes = [[Increases the number of Spell Stack by one]],
            detail = [[Increases the number of Spell Stack by one!]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Use §p30§d Bombs]],
            condd = nil,
        },
        [100] = {
            stitle = [[PPT]],
            sdes = [[Whatever a bullet is cleared, a §yClearPoint§d will be generated
Each §yClearPoint§d §g+0.01%§d Spell Energy]],
            detail = [[Whatever a bullet is cleared, a §yClearPoint§d will be generated
Each §yClearPoint§d §g+0.01%§d Spell Energy]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [101] = {
            stitle = [[Dreamland]],
            sdes = [[Shoots §yColorBall§d downward, which will target enemies after rebounding
§yColorBall§d hitting enemies will drop and can be collected and shot again]],
            detail = [[Shoots §g1~3§d §yColorBall§d downward at random angles every §g45f§d
Each deals §g120% ATK§d dmg
§yColorBall§d can rebound §g1§d time and will target enemies after rebounding
When §yColorBall§d hit enemies, it will drop as collectable §yColorBall§d
Collected §yColorBall§d will also target enemies and shoot
At most §b20§d §yColorBall§d on screen]],
            repeatd = nil,
            tags = t.neet,
            collabd = nil,
            unlockd = [[Cap §p"神宝「蓬莱的玉枝　-梦色之乡-」"]],
            condd = nil,
        },
        [105] = {
            stitle = [[Prism scatter]],
            sdes = [[When Player's Bullet hit enemies, it will divide into 4 §bSmall Player's Bullets
at 75% the size of Player's Bullet in all directions]],
            detail = [[When Player's Bullet hit enemies, it will divide into 4 §bSmall Player's Bullets
at 75% the size of Player's Bullet in all directions.
Each Small Player's Bullet deals §g20% ATK§d dmg
§-The dividing angle changes over time]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [106] = {
            stitle = [[Weedscattered]],
            sdes = [[§gResurruects§d after death, gaining §g120f§d of Invincibility and changing Maxlife to §r9§d
When §gResurruects§d, randomly §rbreaks§d 1 Item; After §g8§d times, this Item §-breaks]],
            detail = [[§gResurruects§d after death, gaining §g120f§d of Invincibility and
changing Maxlife to §r9§d
When §gResurruects§d, randomly §rbreaks§d 1 Item
 After §gResurruects 8§d times, this Item §-breaks]],
            repeatd = nil,
            tags = t.resurrection,
            collabd = [[Resurrection priority is §y1§-(higher means it triggers earlier)]],
            unlockd = [[After August 7, 2024]],
            condd = nil,
        },
        [108] = {
            stitle = [[Stars shining above vast plain fields]],
            sdes = [[Every time an enemy appears/dies, a random position generates §b1§d star
Stars deal §g20% ATK§d dmg or disappear after §b350f§d]],
            detail = [[Every time an enemy appears/dies, a random position generates §b1§d star
Stars deal §g20% ATK§d dmg or disappear after §b350f§d]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [111] = {
            stitle = [[Ceremony]],
            sdes = [[ATK §g+1§d, ShootRate Power §r-77%§d, Range §r-3.5§d, Range Power §r-34%§d
Player shoots §b150%ATK§d Large Player's Bullet, which would split into fireworks]],
            detail = [[ATK §g+1§d, ShootRate Power §r-77%§d, Range §r-3.5§d, Range Power §r-34%§d
Player will shoot a large Player's Bullet with §b150%§d ATK,
Large Player's Bullet splits into §b6~9§d Player's Bullet
when hitting enemies or disappearing
Player's Bullet inherits §b60%§d range but not less than §b5~8§d]],
            repeatd = nil,
            tags = nil,
            collabd = [[§pThe Kaleidoscope§d: Each Player's Bullet will split into §b4§d bullets]],
            unlockd = GongFeng,
            condd = nil,
        },
        [112] = {
            stitle = [[Dreamy colors]],
            sdes = [[Has a chance to §gnegate dmg from MISS]],
            detail = [[记§ya=1
Has §ga*23%§d chance to negate dmg from MISS]],
            repeatd = [[a+1
the proba §r-0.3x§d]],
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[MISS by enemy §p50§d times]],
            condd = nil,
        },
        [113] = {
            stitle = [[Charged shield]],
            sdes = [[Gain §g0.75§d layers of shield / Wave, each §b1§d layer can absorb §g1§d MISS
Up to §b3§d layers of shield]],
            detail = [[Gain §g0.75§d layers of shield / Wave, each §b1§d layer can absorb §g1§d MISS
Up to §b3§d layers of shield]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = [[Obtain §b"Magic Bottle"]],
            condd = nil,
        },
        [123] = {
            stitle = [[Unfailing aim]],
            sdes = [[After shooting for a period, shoot needle bullets forward, dealing §gmassive dmg§d,
but Player will misfire for a period]],
            detail = [[Note §ya=0§d, §ym=1§-(max 9)
After each shot §b(300-a*50-m*13)§-(no less than 75)§bf§d,
shoot §gm§d high-speed needle bullets in all directions
Needle bullets inherit Player's Range and deal §g25% ATK§d dmg / f to enemies
After shooting needle bullets, Player will misfire for §r(60-a*20) f§d, §ym§g+0.75
When Player MISS, §rm=1]],
            repeatd = [[a+1]],
            tags = nil,
            collabd = [[§pLuring Nether§d: Needle bullets gain §gtracking effect
§gPortal Back§d: Needle bullets §gcan shuttle once
§pAbyss Echoes§d: Needle bullets §gcan infinitely rebound
§bVampire's Fang§d: §ym§d max value changed to §g12]],
            unlockd = GongFeng,
            condd = nil,
        },
        [124] = {
            stitle = [[Secret in the water]],
            sdes = [[In low-speed state, ATK §g+0.5§d,  Hitbox §g-0.1§d
Additionally, §gshoot ripple bullets]],
            detail = [[When in low-speed, enter §y"Diving"§d mode, §-texture turns blue
§y"Diving"§d: ATK §g+0.5§d,  Hitbox §g-0.1§d
Every §b12f§d, shoot large ripple bullets dealing §g60% ATK§d dmg;
Every §b25f§d, shoot small ripple bullets dealing §g30% ATK§d dmg]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Defeat §b"Wakasagihime" once]],
            condd = nil,
        },
        [125] = {
            stitle = [[ProjectE]],
            sdes = [[Increase ATK and ShootRate based on collected EXPs
Reset EXP count upon Upgrading]],
            detail = [[Note §yn=Collected EXPs
Increase Player's ATK and ShootRate by §g0.012n
Reset §rn=0 upon Upgrading]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Reach §p30§d level in one game]],
            condd = nil,
        },
        [126] = {
            stitle = [[Supreme radiance]],
            sdes = [[A halo appears around Player,
Enemies within the halo take §g5% ATK§d dmg / f]],
            detail = [[A halo appears around Player,
Enemies within the halo take §g5% ATK§d dmg / f]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [127] = {
            stitle = [[Look at me!]],
            sdes = [[The faster Player kills enemies, the greater the §gATK increase§d]],
            detail = [[The faster Player kills enemies, the greater the §gATK increase§d
Note §yt=0§-(max 200)§d, §yn=0
Each  enemy died, §bn+0.3§d. §bt-1§d/ f
If §bt>=60§d: Each enemy died §bt+10§d; §bn-1§d/ 15f
If §bt<60§d: an enemy died, §bt=60
If §bt<30§d and §bn<=25§d, then §bn=0§d; else, §bn-2§d/ f
ATK §g+35%n]],
            repeatd = [[With 2 stacks, ATK §g+15%n§d;
With 3 stacks, each enemy died increases §bn+0.3§d]],
            tags = t.store,
            collabd = nil,
            unlockd = [[Killed a total of §p3333§d enemies]],
            condd = nil,
        },
        [128] = {
            stitle = [[Handle with care]],
            sdes = [[ATK Power §g+69%§d, Player's Bullet size §g+69%
Maxlife set to §r20§d, reducing §r2.5§d Maxlife for each dmg taken]],
            detail = [[ATK Power §g+69%§d, Player's Bullet size §g+69%
Maxlife is set to §r20§d and cannot be increased further
§-(including after resurrection)
Each time dmg is taken, §r2.5§d Maxlife is reduced]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Die §p15§d times]],
            condd = nil,
        },
        [129] = {
            stitle = [[Blazing blood]],
            sdes = [[§b16%§d chance to fire §rred Player's Bullet§d
Dealing §g3.3§d times dmg]],
            detail = [[§b16%§d chance to fire §rred Player's Bullet§d
Dealing §g3.3§d times dmg]],
            repeatd = nil,
            tags = t.RGB,
            collabd = [[When obtained 3 Items with §yRGB§d tag
Chance to fire white Player's Bullet, with §rred§ggreen§bblue§d bullets effect
Upon hitting enemies, it will pass through and
split into §rred§ggreen§bblue§d three Player's Bullet]],
            unlockd = GongFeng,
            condd = nil,
        },
        [130] = {
            stitle = [[CO2 filter]],
            sdes = [[§b17%§d chance to fire §ggreen Player's Bullet§d
Restores §g0.025§d Life upon hit]],
            detail = [[§b17%§d chance to fire §ggreen Player's Bullet§d
Restores §g0.025§d Life upon hit]],
            repeatd = nil,
            tags = { t.RGB, t.life, t.store },
            collabd = [[When obtained 3 Items with §yRGB§d tag
Chance to fire white Player's Bullet, with §rred§ggreen§bblue§d bullets effect
Upon hitting enemies, it will pass through and
split into §rred§ggreen§bblue§d three Player's Bullet]],
            unlockd = GongFeng,
            condd = nil,
        },
        [131] = {
            stitle = [[Bright rock-salt]],
            sdes = [[§b10%§d chance to fire §bblue Player's Bullet§d
Enemies hit will drop §g1§d EXP]],
            detail = [[§b10%§d chance to fire §bblue Player's Bullet§d
Enemies hit will drop §g1§d EXP]],
            repeatd = nil,
            tags = { t.RGB, t.store },
            collabd = [[When obtained 3 Items with §yRGB§d tag
Chance to fire white Player's Bullet, with §rred§ggreen§bblue§d bullets effect
Upon hitting enemies, it will pass through and
split into §rred§ggreen§bblue§d three Player's Bullet]],
            unlockd = GongFeng,
            condd = nil,
        },
        [150] = {
            stitle = [[Shion LaLa Team]],
            sdes = [[Obtain a LaLa Team follower-type baby
Rhythmically waves and fires bullets, each dealing §g1.0§d dmg]],
            detail = [[Obtain a LaLa Team follower-type baby
Rhythmically waves and fires bullets, each dealing §g1.0§d dmg]],
            repeatd = nil,
            tags = { t.siyuan, t.baby, },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [161] = {
            stitle = [[Shell of yellow bean's soul]],
            sdes = [[Collecting Lifechips additionally ATK §g+1§d and Spell Energy §g+25%]],
            detail = [[Collecting Lifechips additionally ATK §g+1§d and Spell Energy §g+25%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Defeat §p"Ringo" once]],
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
            stitle = [[Soul dispersal]],
            sdes = [[When grazing bullets, there is a chance to §gturn bullets into tracking ghost
Ghost deal §g1200% ATK§d dmg/s to enemies]],
            detail = [[When grazing bullets, there is a chance to §gturn bullets into tracking ghost
Ghost deal §g1200% ATK§d dmg/s to enemies
Note §ya=Luck§-(min 5)
§yb=-8§-(min -16, max 40)
§yx=Luck§-(min 1)
Chance of success §yp=(a+15/66+b)*x/100
On success, §rb-8§d, on failure §gb+8
Check once every 2 bullets grazed.
On success, the grazed bullets turn into tracking ghost,
Ghosts deal §g20% ATK§d dmg/f and last for §b288f§d
Up to §b36§d ghosts can exist]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [40] = {
            stitle = [[Eternal star]],
            sdes = [[When Life equals Maxlife,
Restoring Life will also increase Maxlife by a certain percentage]],
            detail = [[Note §ya=1
When Life equals Maxlife,
Restoring Life will also increase Maxlife by §g(20+a*10)%§d of the restored amount
Decrease the probability of Starlight Blessing (Blue) and (Red) to §r0]],
            repeatd = [[§ya§d+1]],
            tags = t.life,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [41] = {
            stitle = [[Quality star]],
            sdes = [[Each level-up allows §gtwice choices§d, §rbut reduces one option
EXP Rate §rdecreases§d, but increases after multiple gains]],
            detail = [[Note §ya=1
Each level-up allows §gtwice choices§d, §rbut reduces one option
EXP Rate §r-30%
Decrease the probability of Starlight Blessing (Green) and (Red) to §r0]],
            repeatd = [[EXP Rate §g+20%]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [42] = {
            stitle = [[Spirit star]],
            sdes = [[Each level-up randomly selects one from §yATK | ShootRate | BulletVel | Range§d
§gIncrease by a certain value, the effect is executed §y2§d times / level-up]],
            detail = [[Note §ya=1§d
Each level-up will sort §yattack power|shoot speed|bullet speed|range§d
from smallest to largest
There is a §g40%§d, §g30%§d, §g20%§d, §g10%§d chance to receive an increase in value
The value is §g0.5+a*0.5
This effect is executed §y2§d times / level-up
Decrease the probability of Starlight Blessing (Green) and (Blue) to §r0]],
            repeatd = [[a+1]],
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [47] = {
            stitle = [[Link of destiny]],
            sdes = [[Each time an enemy dies,
Deal §g4% of the dead enemy's Maxlife§d dmg to all enemies on the screen]],
            detail = [[Each time an enemy dies,
Deal §g4% of the dead enemy's Maxlife§d dmg to all enemies on the screen]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = [[Killed a total of §p10000§d enemies]],
            condd = nil,
        },
        [51] = {
            stitle = [[Western-wall]],
            sdes = [[Generate a blue barrier spanning the upper part of the screen
Enemy bullets that touch the barrier will be §gcleared§d]],
            detail = [[Generate a blue barrier spanning the upper part of the screen
Enemy bullets that touch the barrier will be §gcleared§d]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [58] = {
            stitle = [[She will protect you forever...]],
            sdes = [[Obtain the §y"Supernatural Border"§d system
Extend the spring duration by §b1§d wave]],
            detail = [[Obtain the §y"Supernatural Border"§d system
§y"Supernatural Border"§d:
Increase Cherry points when attacking enemies, more when in High-Speed
Cherry points are displayed on the right, and Border activates automatically
 when the progress bar is full
When Border activates, restores §g10§d Life, Border lasts for a period,
§ggrazing bullets grants a large amount of score
When Border <ends by bullet/active end>: §gClear bullets from the screen
When Border <expires>: §gReward a certain score
Press the Spell key to actively end Border
Extend Spring §b1§d wave]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Meet §p"Vernalize"§d weather]],
            condd = nil,
        },
        [64] = {
            stitle = [[I want it all!]],
            sdes = [[§gAttract all EXPs on the screen
Each level-up requires §g7 levels§d less EXP]],
            detail = [[§gAttract all EXPs on the screen
Each level-up requires §g7 levels§d less EXP]],
            repeatd = nil,
            tags = t.store,
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [86] = {
            stitle = [[Eternal full moon]],
            sdes = [[Player is §gimmune to 1.00§d dmg of any type
Player is §g50%§d immune to dmg of any type]],
            detail = [[Player is §gimmune to 1.00§d dmg of any type
Player is §g50%§d immune to dmg of any type]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[Defeat §r"Junko"§d once]],
            condd = nil,
        },
        [90] = {
            stitle = [[Sweet pain]],
            sdes = [[Each time the main gun hits an enemy, apply §g1§d layer of §y"SweetPoison"
§y"SweetPoison"§d: Additional §g0.19§d dmg / attack]],
            detail = [[Shoot Speed §g+0.7
Each time Player's Bullet hits an enemy, apply §g1§d layer of §y"SweetPoison"
§y"SweetPoison"§d: Additional §g0.19§d dmg / attack]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = [[Defeat §p"Medicine Melancholy"§d once]],
            condd = nil,
        },
        [115] = {
            stitle = [[Nourished by love]],
            sdes = [[Each time §b60§d bullets are cleared, gain §g60f§d of Invincibility
A certain size bullet-clearing circle will also appear around Player]],
            detail = [[When §b60§d bullets are cleared, gain §y"Guardian Lotus"
§y"Guardian Lotus"§d: Grants Player up to §g60 f§d of Invincibility
A certain size bullet-clearing circle will also appear around Player
Can store up to §b60§d cleared bullets for the next §y"Guardian Lotus"§d.
§-Attention: Laser clearances are not counted towards bullet-clearing totals]],
            repeatd = nil,
            tags = { t.defend, t.store },
            collabd = nil,
            unlockd = GongFeng,
            condd = nil,
        },
        [132] = {
            stitle = [[Energy surge]],
            sdes = [[ATK §g+1
ATK Power §g+100%]],
            detail = [[ATK §g+1
ATK Power §g+100%]],
            repeatd = nil,
            tags = nil,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
        [133] = {
            stitle = [[Power from author]],
            sdes = [[The first instance of being hit each wave is §gnot counted as dmg
and that type of bullet will not appear again in the same wave §-(color-coded)]],
            detail = [[The first instance of being hit each wave is §gnot counted as dmg
and that type of bullet will not appear again in the same wave §-(color-coded)]],
            repeatd = nil,
            tags = t.defend,
            collabd = nil,
            unlockd = [[Clear §yExtra§d difficulty in All scenes]],
            condd = nil,
        },
        [162] = {
            stitle = [[Nuclear fusion]],
            sdes = [[When enemies died,
there is a chance for a §yCross Laser§d to appear at the enemy's pos]],
            detail = [[Note §yb=1§d
When enemies died, there is a §g10%§d chance for a Cross Laser to appear at the
enemy's pos
The chance is §g100%§d when Luck is §g50§d
The Laser deals §g8% ATK§d dmg/f to enemies, lasting for §b30*b f]],
            repeatd = [[b+1]],
            tags = t.store,
            collabd = nil,
            unlockd = nil,
            condd = nil,
        },
    },
}