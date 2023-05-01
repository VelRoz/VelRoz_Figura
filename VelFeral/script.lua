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
    body   = models.vel.Vel.D_Body
    head   = body.D_Neck.D_Head
    tail_0 = body.D_Tail
    tail_1 = tail_0.Tail2
    tail_2 = tail_1.Tail3
    tail_3 = tail_2.Tail4


    tex = models.vel:getTextures()
    body.D_ForeLeft:setPrimaryTexture("CUSTOM",tex[2]) --_tex[2] is default
    body.D_ForeRight:setPrimaryTexture("CUSTOM",tex[2]) --tex[5] is socks
    body.D_HindLeftLeg:setPrimaryTexture("CUSTOM",tex[2])
    body.D_HindRightLeg:setPrimaryTexture("CUSTOM",tex[2])
    --body.D_Tail.Slit:setVisible(false)
    body.D_Tail.Slit.Cocc:setVisible(false)
    --body.D_Tail.Donut:setVisible(false)
    animations.vel.genitals_leave:play()
    animations.vel.cock_leave:play()
    
    log("MODEL_PARTS_INIT FINISHED")
end

--Actions
function action_wheel_init()
    _my_page                        = action_wheel:newPage()
    local _action_sleep             = _my_page:newAction()
    local _action_toggle_genitals   = _my_page:newAction()
    local _action_toggle_erection   = _my_page:newAction()
    local _action_toggle_throb      = _my_page:newAction()
    local _action_toggle_socks      = _my_page:newAction()
    local _action_toggle_snout      = _my_page:newAction()
    local _col                      = vectors.vec3(255/255,128/255,0/255) --Vel's eye color in RGB
    local _hover_col                = vectors.vec3(255/255,0/255,0/255) --Red
    
    --_action_sleep
    _action_sleep:setItem("red_bed")
    _action_sleep:title("Sleep")
    _action_sleep:onToggle(pings.toggle_sleeping)
    _action_sleep:setToggleColor(_col)
    _action_sleep:setHoverColor(_hover_col)

    --_action_toggle_genitals
    _action_toggle_genitals:setItem("cake")
    _action_toggle_genitals:title("Toggle Genitals")
    _action_toggle_genitals:onToggle(pings.toggle_genitals)
    _action_toggle_genitals:toggled(false)
    _action_toggle_genitals:setToggleColor(_col)
    _action_toggle_genitals:setHoverColor(_hover_col)

    --_action_toggle_erection
    _action_toggle_erection:setItem("carrot")
    _action_toggle_erection:title("Toggle Erection")
    _action_toggle_erection:onToggle(pings.toggle_erection)
    _action_toggle_erection:toggled(false)
    _action_toggle_erection:setToggleColor(_col)
    _action_toggle_erection:setHoverColor(_hover_col)

    --_action_toggle_throb
    _action_toggle_throb:setItem("golden_carrot")
    _action_toggle_throb:title("Toggle Throb")
    _action_toggle_throb:onToggle(pings.toggle_throb)
    _action_toggle_throb:toggled(false)
    _action_toggle_throb:setToggleColor(_col)
    _action_toggle_throb:setHoverColor(_hover_col)

    --_action_toggle_throb
    _action_toggle_socks:setItem("leather_boots")
    _action_toggle_socks:title("Toggle Programmer Mode")
    _action_toggle_socks:onToggle(pings.toggle_socks)
    _action_toggle_socks:toggled(false)
    _action_toggle_socks:setToggleColor(_col)
    _action_toggle_socks:setHoverColor(_hover_col)

    --_action_toggle_snout
    _action_toggle_snout:setItem("player_head{SkullOwner:wowMemeify}")
    _action_toggle_snout:title("Toggle Visible Snout")
    _action_toggle_snout:onToggle(pings.toggle_snout)
    _action_toggle_snout:toggled(false)
    _action_toggle_snout:setToggleColor(_col)
    _action_toggle_snout:setHoverColor(_hover_col)
    log("ACTIONS: ",_my_page:getActions())

    action_wheel:setPage(_my_page)
    log("ACTION_WHEEL_INIT FINISHED")
end

function pings.random_sleep()
    if (math.random() < 0.5) then
        laydown = animations.vel.laydown
        laydown:speed(0.7)
    else
        laydown = animations.vel.laydown2
        laydown:speed(0.7)
    end

    walk:stop()
    laydown:play()
end

function pings.toggle_sleeping()
    PREVIOUS_STATE = STATE
    --local _act2 = _my_page:getAction(1) --toggle_sleeping
    --log(_act2:getToggleColor())
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
    --log(STATE)
end

function pings.toggle_genitals(is_toggled)
    --body.D_Tail.Slit:setVisible(is_toggled)
    --body.D_Tail.Donut:setVisible(is_toggled)
    local _act = _my_page:getAction(2) --toggle_genitals
    local _act2 = _my_page:getAction(3) --toggle_erection
    if (is_toggled == true) then
        animations.vel.genitals_leave:stop()
        animations.vel.genitals_squish:play()
    else
        animations.vel.genitals_squish:stop()
        animations.vel.genitals_leave:play()
    end

    if (_act2:isToggled()) and not (is_toggled) then
        animations.vel.cock_leave:play()
        _act2:toggled(false)
    end
end

function pings.toggle_erection(is_toggled)
    local _act = _my_page:getAction(2) --toggle_genitals
    local _act2 = _my_page:getAction(3) --toggle_erection
    body.D_Tail.Slit.Cocc:setVisible(true)
    if (_act:isToggled()) then
        if (is_toggled == true) then
            animations.vel.cock_leave:stop()
            animations.vel.cock_erect:stop()
            animations.vel.cock_erect:play()
        else
            animations.vel.cock_erect:stop()
            animations.vel.cock_leave:stop()
            animations.vel.cock_leave:play()
        end
    else
        _act2:toggled(false)
    end
end

function pings.toggle_throb(is_toggled)
    if (is_toggled == true) then
        animations.vel.cock_throb:play()
    else
        animations.vel.cock_throb:stop()
    end
end

function pings.toggle_socks(is_togged)
    if (is_togged == true) then
        body.D_ForeLeft:setPrimaryTexture("CUSTOM",tex[5]) --_tex[2] is default
        body.D_ForeRight:setPrimaryTexture("CUSTOM",tex[5]) --tex[5] is socks
        body.D_HindLeftLeg:setPrimaryTexture("CUSTOM",tex[5])
        body.D_HindRightLeg:setPrimaryTexture("CUSTOM",tex[5])
    else
        body.D_ForeLeft:setPrimaryTexture("CUSTOM",tex[2]) --_tex[2] is default
        body.D_ForeRight:setPrimaryTexture("CUSTOM",tex[2]) --tex[5] is socks
        body.D_HindLeftLeg:setPrimaryTexture("CUSTOM",tex[2])
        body.D_HindRightLeg:setPrimaryTexture("CUSTOM",tex[2])
    end
end

function pings.toggle_snout(is_toggled)
end
--  START   --
log("MAIN LOADED")
model_parts_init()
action_wheel_init()

--log(models.vel:getPrimaryTexture())

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
    player_speed = vectors.vec3(player_vel.x, 0, player_vel.z):length()
    --log(player_vel)
end)

--  TICK    --
events.TICK:register(function ()
    player_vel = player:getVelocity()
    player_speed = vectors.vec3(player_vel.x, 0, player_vel.z):length()
    --log_wait(player:getRot(),60)
    --log_wait(models.vel.Vel:getRot(),60)
    laydown:setOverride(true)

    --models.vel_head.D_Head:setPos(vanilla_model.HEAD:getPos())
    --log_wait(animations.vel.genitals_squish:getPlayState(),60)
    --local part_mat = head:partToWorldMatrix()
    --nameplate.ENTITY:setPivot(part_mat[1][1],3+part_mat[2][2],part_mat[3][3])
    --nameplate.ENTITY:setPivot(0,3,0)
    
    
    --log(animations.vel.laydown2:getBlend())
    --log_wait("test",60)
    --log_wait(models.vel.Vel:getParentType(),30)
    if not (STATE == SLEEPING) then
        if (player:isUnderwater()) then
            body:setRot(90,0,0)
            animations.vel.swimming_slow:play()
            if (player:isVisuallySwimming()) then
                animations.vel.swimming_slow:stop()
            end
        else
            body:setRot(0,0,0)
            animations.vel.swimming_slow:stop()
        end
    end
    if (STATE == IDLE) then
        if (player:isSneaking()) then
            STATE = SNEAKING
        else 

        end
        
    elseif (STATE == SLEEPING) or (STATE == SLEEPING_BED) then
        animations.vel.idle:stop()
        if not (original_rot == head_rot) then
            head:setRot(original_rot)
        end
    
    elseif (STATE == SNEAKING) then
        if not (player:isSneaking()) then
            STATE = IDLE
        end
    end
    
    if (player:isSneaking()) then
        --[[if (animations.vel.laydown:getPlayState() == "PLAYING") or (animations.vel.idle:getPlayState() == "PLAYING") then
            body:setPos(0,2,0) --do not change this. 2 seems to be pretty good to still be in the ground
        elseif (animations.vel.laydown2:getPlayState() == "PLAYING") then
            body:setPos(-2,0,0)
        end--]]
        if not (STATE == SLEEPING) then
            body:setPos(0,2,0) --do not change this. 2 seems to be pretty good to still be in the ground
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
    local _vec2 = vectors.vec3(0,0,0)
    _vec2 = player:getPos(delta):scale(16)
    
    --fuck it im hard coding the values in
    local _values = {vectors.vec3(0,23,0),      --normal
                    vectors.vec3(0,20,0),   --sneak
                    vectors.vec3(0,10,0)}    --sleeping
    local _v = 1

    if (STATE == IDLE) then
        _v = 1
    elseif (STATE == SNEAKING) then
        _v = 2
    elseif (STATE == SLEEPING) then
        _v = 3
    end
    local _target = vectors.vec3(_vec2.x+_values[_v].x, _vec2.y+_values[_v].y, _vec2.z+_values[_v].z)
    models.vel_head.World.D_Head:setPos(math.lerp(models.vel_head.World.D_Head:getPos(), 
                                                _target,
                                                 0.3)) --hard coded vals
    models.vel_head.World.D_Head:setRot(-(player:getRot().x), -(player:getRot().y+180), 0)
    
    local _act = _my_page:getAction(6) --toggle_snout
    local _is_toggled = _act:isToggled()
  
    if (renderer:isFirstPerson()) then
        vanilla_model.HELD_ITEMS:setVisible(true and not _is_toggled)
        models.vel_head.World.D_Head:setVisible(true and _is_toggled)
        if (client.isPaused()) then
            models.vel.Vel:setVisible(context == "FIGURA_GUI")
        else
            models.vel.Vel:setVisible(context == "PAPERDOLL")
        end
        
        if (STATE == SLEEPING) then
            models.vel.Vel:setVisible(false)
        end
    else
        vanilla_model.HELD_ITEMS:setVisible(true)
        models.vel.Vel:setVisible(true) 
        models.vel_head.World.D_Head:setVisible(false)
        
    end
   
    --models.vel.Vel:setVisible(context == "PAPERDOLL")
    renderer:shadowRadius(1.2) --DONOT CHANGE
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
        if (math.abs(player_speed) > 0) then
            local _speed_mult = 12
            walk:speed(_speed_mult*player_speed)
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
        --[[if (player:isSneaking()) then
            if (animations.vel.laydown:getPlayState() == "PLAYING") or (animations.vel.idle:getPlayState() == "PLAYING") then
                body:setPos(0,2,0) --do not change this. 2 seems to be pretty good to still be in the ground
            elseif (animations.vel.laydown2:getPlayState() == "PLAYING") then
                body:setPos(-2,0,0)
            end
        end--]]
        local _vec = vectors.vec3(0,0,0)
        _vec = player:getPos(delta):scale(16)
        models.vel.Vel:setPos(_vec)
        if (animations.vel.laydown:getPlayState() == "PLAYING") then
            models.vel.Vel:setRot(0, -(orignial_player_rot.y+180), 0)
        elseif (animations.vel.laydown2:getPlayState() == "PLAYING") then
            models.vel.Vel:setRot(orignial_player_rot.y+180, 0, 0)
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