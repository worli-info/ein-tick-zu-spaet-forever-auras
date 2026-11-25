local _,A=...
A.defaults={enabled=true,vertical=true,buffX=16,buffY=45,debuffX=112,debuffY=45,scale=1,stride=12,gap=6}
A.limits={buffX={0,4000},buffY={0,4000},debuffX={0,4000},debuffY={0,4000},scale={0.5,2},stride={1,40},gap={0,32}}
local applying,pending=false,false
local snapshots,hooks={},{}
local fields={"isHorizontal","iconStride","iconPadding","addIconsToTop","addIconsToRight"}
function A.Print(message) print("|cffd9a441"..A.L.title..":|r "..message) end
function A.Validate(key,value)
    local limits=A.limits[key]
    return type(value)=="number" and value==value and value>=limits[1] and value<=limits[2]
        and (key=="scale" or value%1==0)
end
function A.Initialize()
    if type(EinTickZuSpaetForeverAurasDB)~="table" then EinTickZuSpaetForeverAurasDB={} end
    A.db=EinTickZuSpaetForeverAurasDB
    for key,value in pairs(A.defaults) do
        if type(value)=="boolean" then
            if type(A.db[key])~="boolean" then A.db[key]=value end
        elseif not A.Validate(key,A.db[key]) then A.db[key]=value end
    end
end
local function Capture(frame)
    if snapshots[frame] then return end
    local s={scale=frame:GetScale(),points={},container={}}
    for i=1,frame:GetNumPoints() do s.points[i]={frame:GetPoint(i)} end
    for _,key in ipairs(fields) do s.container[key]=frame.AuraContainer[key] end
    snapshots[frame]=s
end
local function Restore(frame)
    local s=snapshots[frame]
    if not s then return end
    frame:SetScale(s.scale)
    frame:ClearAllPoints()
    for _,point in ipairs(s.points) do frame:SetPoint(unpack(point)) end
    for _,key in ipairs(fields) do frame.AuraContainer[key]=s.container[key] end
    frame:UpdateAuraContainerAnchor()
    frame:UpdateGridLayout()
    snapshots[frame]=nil
end
function A.Apply()
    if applying or not A.db then return end
    if InCombatLockdown() then pending=true; return end
    pending=false
    if not BuffFrame or not BuffFrame.AuraContainer or not DebuffFrame or not DebuffFrame.AuraContainer then return end
    applying=true
    if not A.db.enabled then
        Restore(BuffFrame);Restore(DebuffFrame)
        applying=false
        return
    end
    for _,frame in ipairs({BuffFrame,DebuffFrame}) do
        Capture(frame)
        frame:SetScale(A.db.scale)
        local c=frame.AuraContainer
        c.isHorizontal=not A.db.vertical
        c.iconStride=A.db.stride
        c.iconPadding=A.db.gap
        c.addIconsToTop=false
        c.addIconsToRight=false
        frame:UpdateAuraContainerAnchor()
        frame:UpdateGridLayout()
        if not hooks[frame] then
            local function Correct() if A.db.enabled and not applying then A.Apply() end end
            hooksecurefunc(frame,"SetPoint",Correct)
            hooksecurefunc(frame,"SetScale",Correct)
            hooksecurefunc(frame,"UpdateGridLayout",Correct)
            frame:HookScript("OnShow",Correct)
            hooks[frame]=true
        end
    end
    local scale=BuffFrame:GetEffectiveScale()/UIParent:GetEffectiveScale()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",-A.db.buffX/scale,-A.db.buffY/scale)
    -- Align with actual buff icons, below Blizzard's collapse/expand control.
    scale=DebuffFrame:GetEffectiveScale()/UIParent:GetEffectiveScale()
    DebuffFrame:ClearAllPoints()
    DebuffFrame:SetPoint("TOPRIGHT",BuffFrame.AuraContainer,"TOPRIGHT",
        (A.db.buffX-A.db.debuffX)/scale,(A.db.buffY-A.db.debuffY)/scale)
    applying=false
end
local events=CreateFrame("Frame")
for _,event in ipairs({"ADDON_LOADED","PLAYER_LOGIN","PLAYER_ENTERING_WORLD","DISPLAY_SIZE_CHANGED","PLAYER_REGEN_ENABLED"}) do events:RegisterEvent(event) end
events:SetScript("OnEvent",function(_,event,name)
    if event=="ADDON_LOADED" then
        if name=="EinTickZuSpaetForeverAuras" then A.Initialize() end
    elseif event=="PLAYER_REGEN_ENABLED" then
        if pending then A.Apply() end
    else
        C_Timer.After(event=="PLAYER_LOGIN" and 5 or 1,A.Apply)
    end
end)
