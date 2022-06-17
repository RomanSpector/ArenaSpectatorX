---@diagnostic disable: undefined-global

---@class ArenaSpectatorXArenaTypeButtonTemplate
---@field ArenaTypeText FontString

local MAX_ARENASPECTATORX_BUTTONS = 10;

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

local ArenaSpectatorX = CreateFrame("Frame", "ArenaSpectatorX", GossipGreetingScrollFrame);
ArenaSpectatorX:SetSize(322, 403);
ArenaSpectatorX:SetPoint("TOPLEFT");

ArenaSpectatorX.Background = ArenaSpectatorX:CreateTexture("$parentBackground", "BACKGROUND");
ArenaSpectatorX.Background:SetAllPoints();
ArenaSpectatorX.Background:SetTexture("Interface\\AddOns\\ArenaSpectatorX\\texture\\UI-Background-Marble");

ArenaSpectatorX.ScrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", ArenaSpectatorX, "ArenaSpectatorXScrollFrameTemplate");
ArenaSpectatorX.ScrollFrame:SetSize(297, 403);
ArenaSpectatorX.ScrollFrame:SetPoint("TOPLEFT");

DynamicScrollFrame_CreateButtons(ArenaSpectatorXScrollFrame, "ArenaSpectatorXArenaNumButtonTemplate", 38)

local ARENA_TEAM_INFO = {}

local function OnClick(self)
    wipe(ARENA_TEAM_INFO);
    SelectGossipOption(self.id)
    ArenaSpectatorX.ScrollFrame:Show();
    ArenaSpectatorXScrollFrame_Update();
end

local Refresh = CreateFrame("Button", "GossipRefresh", GossipFrame, "UIPanelButtonTemplate");
Refresh:SetSize(78, 22);
Refresh:SetPoint("TOP", 0, -50);
Refresh:SetText("Обновить");
Refresh:SetScript("OnClick",function(self)
    SelectGossipOption(self.id);
    ArenaSpectatorXScrollFrame_Update();
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
Prev:SetScript("OnClick", OnClick);
Prev:Hide();

local Next = CreateFrame("Button", "GossipNext", GossipFrame, "UIPanelButtonTemplate");
Next:SetSize(33,22);
Next:SetPoint("TOPLEFT", Refresh, "TOPRIGHT", 3, 0);
Next:SetText("Вперед");
Next:SetScript("OnClick", OnClick);
Next:Hide();

local Back = CreateFrame("Button", "GossipBack", GossipFrame, "UIPanelButtonTemplate");
Back:SetSize(53,22);
Back:SetPoint("RIGHT", Refresh, "LEFT", -24, 0);
Back:SetText("Назад");
Back:Hide();
Back:SetScript("OnClick", function(self)
    wipe(ARENA_TEAM_INFO);
    SelectGossipOption(self.id);
    ArenaSpectatorX.ScrollFrame:Hide();
end);

local Arena1v1Button = CreateFrame("Button", "$parena1v1Button", ArenaSpectatorX, "ArenaSpectatorXArenaTypeButtonTemplate");
Arena1v1Button:SetPoint("TOPLEFT", 0, 0);
Arena1v1Button.ArenaTypeText:SetText("1 против 1");

local Arena2v2Button = CreateFrame("Button", "$parena2v2Button", ArenaSpectatorX, "ArenaSpectatorXArenaTypeButtonTemplate");
Arena2v2Button:SetPoint("TOPLEFT", Arena1v1Button, "BOTTOMLEFT", 0, 0);
Arena2v2Button.ArenaTypeText:SetText("2 против 2");

local Arena3v3Button = CreateFrame("Button", "$parena3v3Button", ArenaSpectatorX, "ArenaSpectatorXArenaTypeButtonTemplate");
Arena3v3Button:SetPoint("TOPLEFT", Arena2v2Button, "BOTTOMLEFT", 0, 0);
Arena3v3Button.ArenaTypeText:SetText("3 против 3");

local ArenaSoloQButton = CreateFrame("Button", "$parenaSoloQButton", ArenaSpectatorX, "ArenaSpectatorXArenaTypeButtonTemplate");
ArenaSoloQButton:SetPoint("TOPLEFT", Arena3v3Button, "BOTTOMLEFT", 0, 0);
ArenaSoloQButton.ArenaTypeText:SetText("SoloQ");

function ArenaSpectatorXScrollFrame_Update()
    sort(ARENA_TEAM_INFO,function(a,b) return (a[1][1] + a[2][1]) > (b[1][1] + b[2][1]) end)
    local numArenaTeams = MAX_ARENASPECTATORX_BUTTONS;
    local arenaTeamIndex = 0;
    local offset = FauxScrollFrame_GetOffset(ArenaSpectatorXScrollFrame);
    local button, arenaInfo;

    for i = 1, MAX_ARENASPECTATORX_BUTTONS do
        arenaTeamIndex = i + offset;
        arenaInfo = ARENA_TEAM_INFO[arenaTeamIndex];
        button = _G["ArenaSpectatorXScrollFrameButton"..i];
        if ( not arenaInfo ) then
            button:Hide();
        else
            button:Show();
            button.SpecializationIcon1:SetTexture(SPECIALIZATION_ICONS[arenaInfo[1][2][1]]);
            button.SpecializationIcon2:SetTexture(SPECIALIZATION_ICONS[arenaInfo[1][2][2]]);
            button.SpecializationIcon3:SetTexture(SPECIALIZATION_ICONS[arenaInfo[1][2][3]]);
            button.RatingText:SetText("["..arenaInfo[1][1].."] vs ["..arenaInfo[2][1].."]")
            button.SpecializationIcon4:SetTexture(SPECIALIZATION_ICONS[arenaInfo[2][2][1]]);
            button.SpecializationIcon5:SetTexture(SPECIALIZATION_ICONS[arenaInfo[2][2][2]]);
            button.SpecializationIcon6:SetTexture(SPECIALIZATION_ICONS[arenaInfo[2][2][3]]);

            button.arenaID = arenaInfo.id;
        end
    end

    FauxScrollFrame_Update(ArenaSpectatorXScrollFrame, numArenaTeams, MAX_ARENASPECTATORX_BUTTONS, 38, nil, nil, nil, nil, nil, nil, true);
end

local ARENASPECTATORX_ALL_BUTTONS =
{
    Refresh;
    Next;
    Prev;
    Back;
    Arena1v1Button;
    Arena2v2Button;
    Arena3v3Button;
    ArenaSoloQButton;
}

local ARENASPECTATORX_ARENA_TYPE_BUTTONS =
{
    Arena1v1Button;
    Arena2v2Button;
    Arena3v3Button;
    ArenaSoloQButton;
}

local function getTeamInfo(text)
    local tbl = {}
    for s in text:gmatch("(%a+)") do
        if SPECIALIZATION_ICONS[s] then tinsert(tbl,s) end
    end
    return tbl
end

local MyGossipFrameUpdate = function(...)
    for _, button in ipairs(ARENASPECTATORX_ALL_BUTTONS) do
        button:Hide();
    end

    wipe(ARENA_TEAM_INFO);

    for i = 1, select("#", ...), 2 do
        local index = (i + 1) / 2;
        local text = select(i, ...);

        if text:sub(1,3) == "1x1" then
            for arenaID, button in ipairs(ARENASPECTATORX_ARENA_TYPE_BUTTONS) do
                button.id = arenaID;
                button:Show();
            end
            return;
        elseif text == "Refresh"  then Refresh.id  = 1; Refresh:Show();
        elseif text == "Next..."  then Next.id = index; Next:Show();
        elseif text == "Prev..."  then Prev.id = index; Prev:Show();
        elseif text == "Back"     then Back.id = index; Back:Show();
        else
            local left, right = strsplit("-", text, 2);
            local team_info1, team_info2 = getTeamInfo(left or ""), getTeamInfo(right or "");

            if #team_info1 == #team_info2 and #team_info1 ~= 0 then
                tinsert(ARENA_TEAM_INFO, { id = index, { left:match("(%d+)"), team_info1 }, { right:match("(%d+)"), team_info2 } });
            end
        end
    end

    ArenaSpectatorXScrollFrame_Update();
end

local ARENASPECTATOR_FRAMES =
{
    Refresh,
    Next,
    Prev,
    Back,
    ArenaSpectatorX,
    GossipFrameGreetingPanelMaterialTopLeft,
    GossipFrameGreetingPanelMaterialTopRight,
};

ArenaSpectatorX:SetScript("OnEvent", function()
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

        ArenaSpectatorX:Show();
        ArenaSpectatorX.ScrollFrame:Hide();

        GossipGreetingText:Hide();
        GossipGreetingScrollFrameScrollBar:Hide();
        GossipGreetingScrollFrameScrollBar:SetAlpha(0);

        for i=1, 32 do _G["GossipTitleButton"..i]:Hide() end

        MyGossipFrameUpdate(GetGossipOptions());
    else
        wipe(ARENA_TEAM_INFO);

        for _, frame in ipairs(ARENASPECTATOR_FRAMES) do
            frame:Hide();
        end

        ArenaSpectatorX.ScrollFrame:Hide();
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

ArenaSpectatorX:RegisterEvent("GOSSIP_SHOW");
