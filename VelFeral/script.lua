require("log_and_wait")
RELEASE         = 0
PRESS           = 1
HOLD            = 2

SHIFT           = 340


IDLE            = "0"
SLEEPING        = "1"
SLEEPING_BED    = "2"
SNEAKING        = "3"

STATE           = IDLE
PREVIOUS_STATE  = STATE

--IDLE      -> SLEEPING
--IDLE      -> SNEAKING

--SNEAKING  -> IDLE
--SNEAKING  -> SLEEPING

--SLEEPING  -> IDLE

--Animations
laydown = animations.vel.laydown
walk = animations.vel.walking_normal
function model_parts_init()
    body = models.vel.Vel.D_Body
    head   = body.D_Neck.D_Head
    tail_0 = body.D_Tail
    tail_1 = tail_0.Tail2
    tail_2 = tail_1.Tail3
    tail_3 = tail_2.Tail4

    body.D_Tail.Slit:setVisible(false)
    body.D_Tail.Donut:setVisible(false)
end

--Actions
function action_wheel_init()
    local _my_page = action_wheel:newPage()
    local _action_sleep = _my_page:newAction()

    local _action_toggle_genitals = _my_page:newAction()

    --_action_sleep
    _action_sleep:setItem("red_bed")
    _action_sleep:title("Sleep")
    _action_sleep:onToggle(pings.toggle_sleeping)

    --_action_toggle_genitals
    _action_toggle_genitals:setItem("cake")
    _action_toggle_genitals:title("Toggle Genitals")
    _action_toggle_genitals:onToggle(pings.toggle_genitals)
    _action_toggle_genitals:toggled(false)

    action_wheel:setPage(_my_page)
end

function pings.random_sleep()
    if (math.random() < 0.5) then
        laydown = animations.vel.laydown
        laydown:speed(0.3)
    else
        laydown = animations.vel.laydown2
        laydown:speed(0.7)
    end

    animations:stopAll()
    laydown:play()
end

function pings.toggle_genitals(is_toggled)
    body.D_Tail.Slit:setVisible(is_toggled)
    body.D_Tail.Donut:setVisible(is_toggled)
    if (is_toggled == true) then
        animations.vel.cock_erect:play()
    else
        animations.vel.cock_erect:stop()
    end
end

function pings.toggle_sleeping()
    PREVIOUS_STATE = STATE
    if (STATE == SLEEPING) then
        STATE = IDLE
        
        laydown:stop()
        animations.vel.idle:play()
        --blend = animations.vel.laydown2:getBlend()
        --blend_dir = -1
    else
        orignial_player_rot = player:getRot()
        STATE = SLEEPING
        pings.random_sleep()
        
        --blend = animations.vel.laydown2:getBlend()
        --blend_dir = 1
    end
    log(STATE)
end

--  START   --
model_parts_init()
action_wheel_init()

player_vel = vectors.vec3(0,0,0)
animations.vel.idle:play()

local nameplate_pos = vectors.vec3(0,0.5,1)
vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)

--log(head:getTruePivot())
nameplate.ALL:setText('{"text":"Vel\'Roz"}')
nameplate.ENTITY:setPos(nameplate_pos)
nameplate.ENTITY:setScale(vectors.vec3(1.5,1.5,1.5))
--log(head:getRot())

original_rot = head:getRot()
head_rot = vectors.vec3(0,0,0)

original_pos = models.vel.Vel:getPos()
orignial_player_rot = vectors.vec3(0,0,0)
--X -> Y | Y -> X | Z -> Z
--log(nameplate.ENTITY:getPos())

--animations.vel.laydown2:setBlend(0.0)
--  ENTITY_INIT --
events.ENTITY_INIT:register(function ()
    --log(player:isSneaking())
    --log(player:getPos())
    player_vel = player:getVelocity()
    --log(player_vel)
end)

--  TICK    --
events.TICK:register(function ()
    player_vel = player:getVelocity()
    laydown:setOverride(true)
    --local part_mat = head:partToWorldMatrix()
    --nameplate.ENTITY:setPivot(part_mat[1][1],3+part_mat[2][2],part_mat[3][3])
    --nameplate.ENTITY:setPivot(0,3,0)
    
    
    --log(animations.vel.laydown2:getBlend())
    --log_wait("test",60)
    --log_wait(models.vel.Vel:getParentType(),30)
    if (STATE == IDLE) then
        if (player:isSneaking()) then
            STATE = SNEAKING
        else 

        end
        
    elseif (STATE == SLEEPING) or (STATE == SLEEPING_BED) then
        
        if not (original_rot == head_rot) then
            head:setRot(original_rot)
        end
    
    elseif (STATE == SNEAKING) then
        if not (player:isSneaking()) then
            STATE = IDLE
        end
    end
    
    if (player:isSneaking()) then
        if (animations.vel.laydown:getPlayState() == "PLAYING") or (animations.vel.idle:getPlayState() == "PLAYING") then
            body:setPos(0,2,0) --do not change this. 2 seems to be pretty good to still be in the ground
        elseif (animations.vel.laydown2:getPlayState() == "PLAYING") then
            body:setPos(-2,0,0)
        end
        
                            -- -2 for other
        
    elseif not (STATE == SLEEPING_BED) then
        body:setPos(0,0,0)
    end

    if (player:getPose() == "SLEEPING") and not (STATE == SLEEPING_BED) then
        PREVIOUS_STATE = STATE
        STATE = SLEEPING_BED
        pings.random_sleep()
        body:setPos(0,0,0)
        body:setRot(0,90,0)
        
    elseif not (player:getPose() == "SLEEPING") and (STATE == SLEEPING_BED) then
        STATE = PREVIOUS_STATE
        laydown:stop()
        animations.vel.idle:play()
        body:setRot(0,0,0)
    end
end)

--  RENDER  --
events.RENDER:register(function (delta, context)
    --models.vel.Vel:setVisible(context == "FIRST_PERSON")
    --I HATE BLENDING
    if not (blend == nil) and not (blend_dir == nil) then
        --blend = animations.vel.laydown2:getBlend()
        --animations.vel.laydown2:setBlend(math.min(1.0, blend+blend_dir*0.1))
    end
        
    if (STATE == SNEAKING) then
        --log("test")
        nameplate.ENTITY:setVisible(false)
        animations.vel.sneak:play()
        animations.vel.sneaktailwag:play()
        
    else
        nameplate.ENTITY:setVisible(true)
        animations.vel.sneak:stop()
        animations.vel.sneaktailwag:stop()
    end
    
    if not (STATE == SLEEPING) or (STATE == SLEEPING_BED) then
        --local player_rot = vectors.vec3(-player:getRot().x, -player:getRot().y, 0)
        --local look_dir = player:getLookDir()
        --local trans_dir = vectors.vec3(math.clamp(look_dir.y,-0.75,0.85),
        --                                look_dir.x,
        --                                0)
        --local mult = 100
        if (math.abs(player_vel:length()) > 0) then
            local _speed_mult = 12
            walk:speed(_speed_mult*player_vel:length())
            walk:play()
        else
            walk:speed(0)
            walk:stop()
        end
        
        head_rot = vanilla_model.HEAD:getOriginRot()+original_rot
        
        head:setRot(math.clamp(head_rot.x,-50,100), -- -50
                    head_rot.y,
                    head_rot.z)
        --log(head:getRot())
    end
    
    if (STATE == SLEEPING) then
        models.vel.Vel:setParentType("World")
        --models.vel.Vel:setVisible(context ~= "FIRST_PERSON")
        
        models.vel.Vel:setPos(player:getPos(delta):scale(16))
        if (animations.vel.laydown:getPlayState() == "PLAYING") then
            models.vel.Vel:setRot(0, orignial_player_rot.y*16, 0)
        elseif (animations.vel.laydown2:getPlayState() == "PLAYING") then
            models.vel.Vel:setRot(orignial_player_rot.x*(-16), 0, 0)
        end
        renderer:setOffsetCameraPivot(0,-1,0)
    else
        --models.vel.Vel:setVisible(context == "FIRST_PERSON")
        models.vel.Vel:setParentType("None")
        models.vel.Vel:setPos(original_pos)
        models.vel.Vel:setRot(0,0,0)
        renderer:setOffsetCameraPivot(0,0,0)
        
    end
    

end)

--  KEY_PRESS   --
--[[events.KEY_PRESS:register(function (key, action, modifier)
    
    if (STATE == IDLE) then
        --Check to see what button
        if (key == SHIFT and action == PRESS) then
            PREVIOUS_STATE = STATE
            STATE = SNEAKING
        elseif (action == RELEASE) then
            log("HERE")
            STATE = PREVIOUS_STATE
        end
    else

    end
end)--]]
--str = NameplateCustomization:getText()
--local rot = vectors.vec4(0,0,0,0)
--print(animations:getAnimations())
--print(animations["1"])

--Animation:getOverrideRot()

--print(animations.vel.laydown2:getOverrideRot())