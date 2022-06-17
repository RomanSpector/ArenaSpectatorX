---@diagnostic disable: undefined-global

---@class ArenaSpectatorXSpecializationIconTemplate: Texture
---@class ArenaSpectatorXButtonFontTemplate: Font

---@class ArenaSpectatorXButtonTemplate: Button
---@field NormalTexture Texture
---@field HighlightTexture Texture

---@class ArenaSpectatorXArenaNumButtonTemplate: ArenaSpectatorXButtonTemplate
---@field RatingText ArenaSpectatorXButtonFontTemplate
---@field SpecializationIcon1 ArenaSpectatorXSpecializationIconTemplate
---@field SpecializationIcon2 ArenaSpectatorXSpecializationIconTemplate
---@field SpecializationIcon3 ArenaSpectatorXSpecializationIconTemplate
---@field SpecializationIcon4 ArenaSpectatorXSpecializationIconTemplate
---@field SpecializationIcon5 ArenaSpectatorXSpecializationIconTemplate
---@field SpecializationIcon6 ArenaSpectatorXSpecializationIconTemplate


local MAX_ARENA_SPECTATOR_BUTTONS = 20;

local SPECIALIZATION_ICONS = {
    PWarrior  = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
    AWarrior  = "Interface\\Icons\\Ability_Warrior_Bladestorm",
    FWarrior  = "Interface\\Icons\\Ability_Warrior_InnerRage",
    BDk       = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
    FDk       = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
    UDk       = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
    HPala     = "Interface\\Icons\\Spell_Holy_HolyBolt",
    PPala     = "Interface\\Icons\\Spell_Holy_DevotionAura",
    RPala     = "Interface\\Icons\\Spell_Holy_AuraOfLight",
    DPriest   = "Interface\\Icons\\Spell_Holy_WordFortitude",
    HPriest   = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
    SPriest   = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
    ELShaman  = "Interface\\Icons\\Spell_Nature_Lightning",
    ENShaman  = "Interface\\Icons\\Spell_Nature_LightningShield",
    RShaman   = "Interface\\Icons\\Spell_Nature_MagicImmunity",
    BDruid    = "Interface\\Icons\\Spell_Nature_StarFall",
    FDruid    = "Interface\\Icons\\Ability_Druid_CatForm",
    RDruid    = "Interface\\Icons\\Spell_Nature_HealingTouch",
    ARogue    = "Interface\\Icons\\Ability_Rogue_ShadowStrikes",
    CRogue    = "Interface\\Icons\\Ability_BackStab",
    SRogue    = "Interface\\Icons\\Ability_Stealth",
    AMage     = "Interface\\Icons\\Spell_Holy_MagicalSentry",
    FIMage    = "Interface\\Icons\\Spell_Fire_FlameBolt",
    FRMage    = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    ALock     = "Interface\\Icons\\Spell_Shadow_DeathCoil",
    DemoLock  = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
    DestLock  = "Interface\\Icons\\Spell_Shadow_RainOfFire",
    BHunt     = "Interface\\Icons\\Ability_Hunter_BeastTaming",
    MHunt     = "Interface\\Icons\\Ability_Marksmanship",
    SHunt     = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
}

local _GossipGreeting = CreateFrame("Frame", nil, GossipGreetingScrollFrame);
_GossipGreeting:SetSize(322, 403);
_GossipGreeting:SetPoint("TOPLEFT");
local bg = _GossipGreeting:CreateTexture(nil,"ARTWORK");
bg:SetTexture("Interface\\AddOns\\CompactRaidFrame\\Media\\FrameGeneral\\UI-Background-Marble");
bg:SetAllPoints();

local Refresh = CreateFrame("Button", "GossipRefresh", GossipFrame, "UIPanelButtonTemplate");
Refresh:SetSize(78, 22);
Refresh:SetPoint("TOP", 0, -50);
Refresh:SetText("Обновить");
Refresh:SetScript("OnClick",function(self)
    SelectGossipOption(self.id);
    self:Disable();
    local timeSinceUpdate = 0;
    self:SetScript("OnUpdate", function(this, elapsede)
        timeSinceUpdate = timeSinceUpdate + elapsede;
        if timeSinceUpdate > 0.5 then
            timeSinceUpdate = 0;
            this:Enable();
            this:SetScript("OnUpdate", nil);
        end
    end)
end)
Refresh:Hide();

local Prev = CreateFrame("Button", "GossipPrev", GossipFrame, "UIPanelButtonTemplate");
Prev:SetSize(33,22);
Prev:SetPoint("TOPRIGHT", Refresh, "TOPLEFT", -3, 0);
Prev:SetText("Назад");
Prev:SetScript("OnClick",function(self) SelectGossipOption(self.id) end);
Prev:Hide();

local Next = CreateFrame("Button", "GossipNext", GossipFrame, "UIPanelButtonTemplate");
Next:SetSize(33,22);
Next:SetPoint("TOPLEFT", Refresh, "TOPRIGHT", 3, 0);
Next:SetText("Вперед");
Next:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);
Next:Hide();

local Back = CreateFrame("Button", "GossipBack", GossipFrame, "UIPanelButtonTemplate");
Back:SetSize(53,22);
Back:SetPoint("RIGHT", Refresh, "LEFT", -24, 0);
Back:SetText("Назад");
Back:Hide();
Back:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);

local function CreateButton(i)
    local button = CreateFrame("Button", (i and "GossipNewButton"..i), _GossipGreeting);

    button:SetNormalTexture("Interface\\Buttons\\WHITE8X8");
    button:GetNormalTexture():SetVertexColor(.155, .155, .155, 0.8);

    button:SetHighlightTexture("Interface\\Buttons\\WHITE8X8");
    button:GetHighlightTexture():SetVertexColor(.155, .155, .155, 0.6);

    local text = button:CreateFontString(nil, "OVERLAY");
    text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE");
    text:SetTextColor(.655, .655, .655, 1);
    text:SetPoint("CENTER");
    text:SetJustifyH("CENTER");
    text:SetJustifyV("CENTER");

    button.text = text;
    button:SetFontString(text);

    local function OnMouseDown(self)
        self.text:SetPoint("CENTER", 0, 1);
        self.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
        for k = 1, 6 do
            local icon = self["icon"..k];
            if icon then
                icon:SetSize(14, 14);
            end
        end
    end

    local function OnMouseUp(self)
        self.text:SetPoint("CENTER");
        self.text:SetFont("Fonts\\FRIZQT__.TTF",11,"OUTLINE");
        for k = 1, 6 do
            local icon = self["icon"..k];
            if icon then
                icon:SetSize(15, 15);
            end
        end
    end

    button:SetScript("OnMouseDown", OnMouseDown);
    button:SetScript("OnMouseUp", OnMouseUp);

    return button;
end

local Arena1v1Button = CreateButton();
Arena1v1Button:SetSize(320, 99);
Arena1v1Button:SetPoint("TOPLEFT",1,-1);
Arena1v1Button:SetText("( 1 против 1 )");
Arena1v1Button:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);
Arena1v1Button:Hide();

local Arena2v2Button = CreateButton();
Arena2v2Button:SetSize(320, 99);
Arena2v2Button:SetPoint("TOPLEFT", Arena1v1Button, "BOTTOMLEFT", 0, -1);
Arena2v2Button:SetText("( 2 против 2 )");
Arena2v2Button:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);
Arena2v2Button:Hide();

local Arena3v3Button = CreateButton();
Arena3v3Button:SetSize(320, 99);
Arena3v3Button:SetPoint("TOPLEFT", Arena2v2Button, "BOTTOMLEFT", 0, -1);
Arena3v3Button:SetText("( 3 против 3 )");
Arena3v3Button:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);
Arena3v3Button:Hide();

local ArenaSolOQButton = CreateButton();
ArenaSolOQButton:SetSize(320, 99);
ArenaSolOQButton:SetPoint("TOPLEFT", Arena3v3Button, "BOTTOMLEFT", 0, -1);
ArenaSolOQButton:SetText("( SoloQ )");
ArenaSolOQButton:SetScript("OnClick", function(self) SelectGossipOption(self.id) end);
ArenaSolOQButton:Hide();

local offset = 1;

for numericButton = 1, MAX_ARENA_SPECTATOR_BUTTONS do
    local button = CreateButton(numericButton);
    button:SetSize(320, 18);
    button:SetPoint("TOPLEFT", 1, -offset);
    button:SetScript("OnClick",function(self) SelectGossipOption(self.id) end);
    button:Hide();

    for index = 1, 6 do
        local ClassIcon = button:CreateTexture(nil, "OVERLAY");
        ClassIcon:SetTexCoord(.08, .92, .08, .92);
        ClassIcon:SetSize(15,15);
        button["icon"..index] = ClassIcon;
    end

    local padding = 20;

    button.icon1:SetPoint("TOPLEFT",  button.text,  "TOPLEFT",  -padding, 2);
    button.icon2:SetPoint("TOPLEFT",  button.icon1, "TOPLEFT",  -padding, 0);
    button.icon3:SetPoint("TOPLEFT",  button.icon2, "TOPLEFT",  -padding, 0);
    button.icon4:SetPoint("TOPRIGHT", button.text,  "TOPRIGHT",  padding, 2);
    button.icon5:SetPoint("TOPRIGHT", button.icon4, "TOPRIGHT",  padding, 0);
    button.icon6:SetPoint("TOPRIGHT", button.icon5, "TOPRIGHT",  padding, 0);

    offset = offset + 20;
end

local function razbit(text)
    local tbl = {}
    for s in text:gmatch("(%a+)") do
        if SPECIALIZATION_ICONS[s] then tinsert(tbl,s) end
    end
    return tbl
end

local data = {}
local function update()
    sort(data,function(a,b) return (a[1][1] + a[2][1]) > (b[1][1] + b[2][1]) end)

    for i=1, MAX_ARENA_SPECTATOR_BUTTONS do
        local b = _G["GossipNewButton" .. i]
        local d = data[i]
        if d then
            b.icon1:SetTexture(SPECIALIZATION_ICONS[d[1][2][1]])
            b.icon2:SetTexture(SPECIALIZATION_ICONS[d[1][2][2]])
            b.icon3:SetTexture(SPECIALIZATION_ICONS[d[1][2][3]])
            b.text:SetText("["..d[1][1].."] vs ["..d[2][1].."]")
            b.icon4:SetTexture(SPECIALIZATION_ICONS[d[2][2][1]])
            b.icon5:SetTexture(SPECIALIZATION_ICONS[d[2][2][2]])
            b.icon6:SetTexture(SPECIALIZATION_ICONS[d[2][2][3]])
            b.id = d.id
            b:Show()
        end
    end
end

local ARENA_SPECTATOR_BUTTONS =
{
    Refresh;
    Next;
    Prev;
    Back;
    Arena1v1Button;
    Arena2v2Button;
    Arena3v3Button;
    ArenaSolOQButton;
}

local ARENA_SPECTATOR_ARRENA_BUTTONS =
{
    Arena1v1Button;
    Arena2v2Button;
    Arena3v3Button;
    ArenaSolOQButton;
}

local MyGossipFrameUpdate = function(...)
    for _, button in ipairs(ARENA_SPECTATOR_BUTTONS) do
        button.id = false;
        button:Hide();
    end

    for numbericButton = 1, MAX_ARENA_SPECTATOR_BUTTONS do
        local button = _G["GossipNewButton"..numbericButton];
        button.id = false;
        button:Hide();
    end

    wipe(data);

    for i = 1, select("#", ...), 2 do
        local index = (i + 1) / 2;
        local text = select(i, ...);

        if text:sub(1,3) == "1x1" then
            for arenaID, button in ipairs(ARENA_SPECTATOR_ARRENA_BUTTONS) do
                button.id = arenaID;
                button:Show();
            end
            return;
        elseif text == "Refresh"  then Refresh.id  = 1; Refresh:Show();
        elseif text == "Next..."  then Next.id = index; Next:Show();
        elseif text == "Prev..."  then Prev.id = index; Prev:Show();
        elseif text == "Back"     then Back.id = index; Back:Show();
        else
            local left, right   = strsplit("-", text, 2);
            local _left, _right = razbit(left or ""), razbit(right or "");

            if #_left == #_right and #_left ~= 0 then
                local arenaInfo = { id = index,
                    { left:match("(%d+)"), _left   },
                    { right:match("(%d+)"), _right },
                }
                tinsert(data, arenaInfo);
            end
        end
    end
    update();
end

local ARENA_SPECTATOR_FRAMES =
{
    Refresh,
    Next,
    Prev,
    Back,
    GossipFrameGreetingPanelMaterialTopLeft,
    GossipFrameGreetingPanelMaterialTopRight,
    _GossipGreeting
};

_GossipGreeting:SetScript("OnEvent", function()
    if UnitName("npc") == "Arena Spectator" then
        GossipGreetingScrollFrame:SetSize(300, 400);
        GossipFrameGreetingPanel:SetSize(384, 578);
        GossipFrameGreetingPanelMaterialTopLeft:SetTexture("Interface\\QuestFrame\\UI-QuestGreeting-TopLeft");
        GossipFrameGreetingPanelMaterialTopLeft:SetSize(256, 241);
        GossipFrameGreetingPanelMaterialTopLeft:SetTexCoord(0, 1,  .5,  1);
        GossipFrameGreetingPanelMaterialTopLeft:SetPoint("TOPLEFT", 0, -200);
        GossipFrameGreetingPanelMaterialTopRight:SetTexture("Interface\\QuestFrame\\UI-QuestGreeting-TopRight");
        GossipFrameGreetingPanelMaterialTopRight:SetTexCoord(0, 1,  .5,  1);
        GossipFrameGreetingPanelMaterialTopRight:SetPoint("TOPLEFT", 256, -90);
        GossipFrameGreetingPanelMaterialTopRight:SetSize(128, 241);
        GossipFrameGreetingPanelMaterialTopLeft:Show();
        GossipFrameGreetingPanelMaterialTopRight:Show();

        GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", GossipFrame, "BOTTOMRIGHT", -39, 7);

        GossipFrameNpcNameText:SetPoint("LEFT", GossipNpcNameFrame, "LEFT", -40, 0);
        GossipFrameNpcNameText:SetText("|cff878787ArenaSpectatorX");

        _GossipGreeting:Show();

        GossipGreetingText:Hide();
        GossipGreetingScrollFrameScrollBar:Hide();
        GossipGreetingScrollFrameScrollBar:SetAlpha(0);

        for i=1, 32 do _G["GossipTitleButton"..i]:Hide() end

        MyGossipFrameUpdate(GetGossipOptions());
    else
        for _, frame in ipairs(ARENA_SPECTATOR_FRAMES) do
            frame:Hide();
        end

        GossipGreetingScrollFrame:SetSize(300, 334);
        GossipFrameGreetingPanel:SetSize(384, 512);
        GossipGreetingScrollFrameScrollBar:Show();
        GossipGreetingScrollFrameScrollBar:SetAlpha(1);
        GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", GossipFrame, "BOTTOMRIGHT", -39, 73);
        GossipTitleButton1:SetPoint("TOPLEFT", GossipGreetingText, "BOTTOMLEFT", -10, -20);
        GossipGreetingText:Show();
        GossipFrameNpcNameText:SetPoint("LEFT", GossipNpcNameFrame, "LEFT", 0, 0);
    end
end)

_GossipGreeting:RegisterEvent("GOSSIP_SHOW");


