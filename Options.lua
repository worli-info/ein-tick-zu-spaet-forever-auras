local _,A=...
local L=A.L
local panel
local function Button(parent,text,x,y,click)
    local b=CreateFrame("Button",nil,parent,"UIPanelButtonTemplate")
    b:SetSize(135,24);b:SetPoint("TOPLEFT",x,y);b:SetText(text);b:SetScript("OnClick",click)
    return b
end
local function Label(parent,text,x,y)
    local f=parent:CreateFontString(nil,"OVERLAY","GameFontNormal")
    f:SetPoint("TOPLEFT",x,y);f:SetText(text)
    return f
end
local function Refresh()
    panel.enabled:SetChecked(A.db.enabled)
    panel.vertical:SetChecked(A.db.vertical)
    for key,box in pairs(panel.inputs) do box:SetText(tostring(A.db[key])) end
end
local function Apply()
    if InCombatLockdown() then A.Print(L.combat);return end
    local values={}
    for key,box in pairs(panel.inputs) do
        local number=tonumber((box:GetText():gsub(",",".")))
        if not A.Validate(key,number) then A.Print(L.invalid:format(L[key]));return end
        values[key]=number
    end
    for key,value in pairs(values) do A.db[key]=value end
    A.db.enabled=panel.enabled:GetChecked() and true or false
    A.db.vertical=panel.vertical:GetChecked() and true or false
    A.Apply();A.Print(L.applied)
end
function A.Open()
    if not A.db then return end
    if not panel then
        panel=CreateFrame("Frame","EinTickZuSpaetForeverAurasOptions",UIParent,"BackdropTemplate")
        panel:SetSize(580,480);panel:SetPoint("CENTER");panel:SetFrameStrata("DIALOG")
        panel:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=16,insets={left=4,right=4,top=4,bottom=4}})
        panel:EnableMouse(true);panel:SetMovable(true);panel:RegisterForDrag("LeftButton")
        panel:SetScript("OnDragStart",panel.StartMoving);panel:SetScript("OnDragStop",panel.StopMovingOrSizing)
        Label(panel,L.title,20,-20)
        local desc=Label(panel,L.description,20,-50);desc:SetWidth(540);desc:SetJustifyH("LEFT")
        for i,key in ipairs({"enabled","vertical"}) do
            local check=CreateFrame("CheckButton",nil,panel,"UICheckButtonTemplate")
            check:SetPoint("TOPLEFT",20,-90-(i-1)*32)
            check.Text:SetText(L[key]);panel[key]=check
        end
        panel.inputs={}
        for i,key in ipairs({"buffX","buffY","debuffX","debuffY","scale","stride","gap"}) do
            local y=-162-(i-1)*34
            Label(panel,L[key],24,y)
            local box=CreateFrame("EditBox",nil,panel,"InputBoxTemplate")
            box:SetSize(100,22);box:SetPoint("TOPRIGHT",-28,y+5);box:SetAutoFocus(false)
            box:SetScript("OnEscapePressed",function(self)self:ClearFocus()end)
            box:SetScript("OnEnterPressed",function(self)self:ClearFocus();Apply()end)
            panel.inputs[key]=box
        end
        Button(panel,L.apply,20,-430,Apply)
        Button(panel,L.reset,175,-430,function()
            if InCombatLockdown() then A.Print(L.combat);return end
            for key,value in pairs(A.defaults) do A.db[key]=value end
            Refresh();A.Apply()
        end)
        Button(panel,L.close,420,-430,function()panel:Hide()end)
        if UISpecialFrames then table.insert(UISpecialFrames,"EinTickZuSpaetForeverAurasOptions") end
    end
    Refresh();panel:Show()
end
SLASH_ETZSAURAS1="/fba"
SLASH_ETZSAURAS2="/etzsauras"
SlashCmdList.ETZSAURAS=A.Open
local registration=CreateFrame("Frame")
registration:RegisterEvent("PLAYER_LOGIN")
registration:SetScript("OnEvent",function()
    if not Settings or not Settings.RegisterCanvasLayoutCategory then return end
    local categoryPanel=CreateFrame("Frame")
    Label(categoryPanel,L.title,16,-16)
    local desc=Label(categoryPanel,L.description,16,-50);desc:SetWidth(550);desc:SetJustifyH("LEFT")
    Button(categoryPanel,L.open,16,-110,A.Open)
    local category=Settings.RegisterCanvasLayoutCategory(categoryPanel,L.title)
    Settings.RegisterAddOnCategory(category)
end)
