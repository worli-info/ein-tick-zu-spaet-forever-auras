unpack=unpack or table.unpack
local root=assert(arg[1])
for _,locale in ipairs({"deDE","enUS","frFR"}) do
    local A,handlers,timers={},{},{}
    local combat=false
    local methods={}
    function methods:GetWidth()return self.width or 2133 end
    function methods:GetHeight()return self.height or 1200 end
    function methods:GetScale()return self.scale or 1 end
    function methods:GetEffectiveScale()return self:GetScale() end
    function methods:SetScale(scale)self.scale=scale end
    function methods:GetNumPoints()return self.point and 1 or 0 end
    function methods:GetPoint()return unpack(self.point) end
    function methods:SetPoint(...)self.point={...} end
    function methods:ClearAllPoints()self.point=nil end
    function methods:UpdateGridLayout()self.updates=(self.updates or 0)+1 end
    function methods:UpdateAuraContainerAnchor()end
    function methods:HookScript(event,fn)self.hooks=self.hooks or {};self.hooks[event]=fn end
    function methods:SetScript(event,fn)self.scripts=self.scripts or {};self.scripts[event]=fn;if event=="OnEvent" then handlers[#handlers+1]=fn end end
    function methods:SetText(text)self.text=text end
    function methods:GetText()return self.text end
    function methods:SetChecked(value)self.checked=value end
    function methods:GetChecked()return self.checked end
    function methods:SetSize(w,h)self.width,self.height=w,h end
    function methods:Show()self.shown=true end
    function methods:Hide()self.shown=false end
    local function obj()return setmetatable({},{__index=methods})end
    function methods:CreateFontString()return obj()end
    setmetatable(methods,{__index=function(_,key)if key:match("^[A-Z]") then return function()end end end})
    UIParent=obj();BuffFrame=obj();DebuffFrame=obj()
    for _,frame in ipairs({BuffFrame,DebuffFrame}) do
        frame.AuraContainer={isHorizontal=true,iconStride=8,iconPadding=4,addIconsToTop=true,addIconsToRight=true}
        frame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",8,-8)
    end
    local oldBuffPoint=BuffFrame.point
    CreateFrame=function(kind,name)
        assert(kind~="AuraContainer" and kind~="StatusBar" and kind~="PlayerModel","must use native aura display")
        local frame=obj();frame.Text=obj()
        if name then _G[name]=frame end
        return frame
    end
    hooksecurefunc=function(object,method,fn)
        local original=object[method]
        object[method]=function(self,...)original(self,...);fn(self,...)end
    end
    GetLocale=function()return locale end
    InCombatLockdown=function()return combat end
    C_Timer={After=function(_,fn)timers[#timers+1]=fn end}
    UnitBuff=function()error("must not scan auras")end
    UnitDebuff=UnitBuff
    Settings={RegisterCanvasLayoutCategory=function()return {} end,RegisterAddOnCategory=function()end}
    SlashCmdList={};UISpecialFrames={}
    EinTickZuSpaetForeverAurasDB=nil
    for _,file in ipairs({"Locales.lua","Auras.lua","Options.lua"}) do assert(loadfile(root.."/"..file))("EinTickZuSpaetForeverAuras",A) end
    handlers[1](nil,"ADDON_LOADED","EinTickZuSpaetForeverAuras")
    assert(A.db.stride==12 and A.db.vertical)
    combat=true;A.Apply()
    assert(BuffFrame.point==oldBuffPoint,"combat changes must defer")
    combat=false;handlers[1](nil,"PLAYER_REGEN_ENABLED")
    assert(not BuffFrame.AuraContainer.isHorizontal and BuffFrame.AuraContainer.iconStride==12)
    assert(BuffFrame.point[4]==-16 and BuffFrame.point[5]==-45)
    assert(DebuffFrame.point[2]==BuffFrame.AuraContainer and DebuffFrame.point[4]==-96)
    assert(DebuffFrame.point[5]==0,"debuffs align below collapse button with buff icons")
    BuffFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",0,0)
    assert(BuffFrame.point[1]=="TOPRIGHT","native/Edit Mode resets must be corrected")
    A.db.scale=0.8;A.db.stride=10;A.db.vertical=false;A.Apply()
    assert(BuffFrame.AuraContainer.isHorizontal and BuffFrame.AuraContainer.iconStride==10)
    assert(math.abs(BuffFrame.point[4]*0.8+16)<0.001,"respect effective scale")
    combat=true;BuffFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",4,4)
    assert(BuffFrame.point[1]=="TOPLEFT")
    combat=false;handlers[1](nil,"PLAYER_REGEN_ENABLED")
    assert(BuffFrame.point[1]=="TOPRIGHT")
    A.db.enabled=false;A.Apply()
    assert(BuffFrame.point[1]=="TOPLEFT" and BuffFrame:GetScale()==1)
    assert(BuffFrame.AuraContainer.isHorizontal and BuffFrame.AuraContainer.iconStride==8,"disable restores native container settings")
    assert(BuffFrame.AuraContainer.addIconsToTop and BuffFrame.AuraContainer.addIconsToRight)
    A.db.enabled=true;A.Apply()
    assert(BuffFrame.point[1]=="TOPRIGHT")
    SlashCmdList.ETZSAURAS()
    assert(EinTickZuSpaetForeverAurasOptions.shown)
    assert(A.L.apply==(locale=="deDE" and "Übernehmen" or "Apply"),"German/English fallback")
    handlers[2](nil,"PLAYER_LOGIN")
    assert(not A.Validate("scale",0) and not A.Validate("stride",1.5))
    A.db.scale=0/0;A.Initialize();assert(A.db.scale==1,"invalid saved settings use defaults")
    A.db.buffX=25;A.Initialize();assert(A.db.buffX==25,"preserve account settings")
    print("PASS: "..locale.." native layout, scale, hooks, restoration, combat deferral, config and saved settings")
end
