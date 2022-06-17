---@diagnostic disable: undefined-global

local MAX_ARENA_SPECTATOR_BUTTONS = 10;

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
ArenaSpectatorX:SetAllPoints();

ArenaSpectatorX.Background = ArenaSpectatorX:CreateTexture("$parentBackground", "BACKGROUND");
ArenaSpectatorX.Background:SetAllPoints();
ArenaSpectatorX.Background:SetTexture("Interface\\AddOns\\ArenaSpectatorX\\texture\\UI-Background-Marble");

ArenaSpectatorX.ScrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", ArenaSpectatorX, "ArenaSpectatorXScrollFrameTemplate");
ArenaSpectatorX.ScrollFrame:SetAllPoints();

DynamicScrollFrame_CreateButtons(ArenaSpectatorXScrollFrame, "ArenaSpectatorXArenaNumButtonTemplate", 38)

local function CreateButton(name)
    local button = CreateFrame("Button", "$parent" .. name .. "Button", ArenaSpectatorX);

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
    end

    local function OnMouseUp(self)
        self.text:SetPoint("CENTER");
        self.text:SetFont("Fonts\\FRIZQT__.TTF",11,"OUTLINE");
    end

    button:SetScript("OnMouseDown", OnMouseDown);
    button:SetScript("OnMouseUp", OnMouseUp);

    return button;
end

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

local Arena1v1Button = CreateButton("1v1");
Arena1v1Button:SetSize(320, 99);
Arena1v1Button:SetPoint("TOPLEFT",1,-1);
Arena1v1Button:SetText("( 1 против 1 )");
Arena1v1Button:SetScript("OnClick", OnClick);
Arena1v1Button:Hide();

local Arena2v2Button = CreateButton("2v2");
Arena2v2Button:SetSize(320, 99);
Arena2v2Button:SetPoint("TOPLEFT", Arena1v1Button, "BOTTOMLEFT", 0, -1);
Arena2v2Button:SetText("( 2 против 2 )");
Arena2v2Button:SetScript("OnClick", OnClick);
Arena2v2Button:Hide();

local Arena3v3Button = CreateButton("3v3");
Arena3v3Button:SetSize(320, 99);
Arena3v3Button:SetPoint("TOPLEFT", Arena2v2Button, "BOTTOMLEFT", 0, -1);
Arena3v3Button:SetText("( 3 против 3 )");
Arena3v3Button:SetScript("OnClick", OnClick);
Arena3v3Button:Hide();

local ArenaSoloQButton = CreateButton("SoloQ");
ArenaSoloQButton:SetSize(320, 99);
ArenaSoloQButton:SetPoint("TOPLEFT", Arena3v3Button, "BOTTOMLEFT", 0, -1);
ArenaSoloQButton:SetText("( SoloQ )");
ArenaSoloQButton:SetScript("OnClick", OnClick);
ArenaSoloQButton:Hide();

local function razbit(text)
    local tbl = {}
    for s in text:gmatch("(%a+)") do
        if SPECIALIZATION_ICONS[s] then tinsert(tbl,s) end
    end
    return tbl
end

function ArenaSpectatorXScrollFrame_Update()
    sort(ARENA_TEAM_INFO,function(a,b) return (a[1][1] + a[2][1]) > (b[1][1] + b[2][1]) end)
    local numArenaTeams = MAX_ARENA_SPECTATOR_BUTTONS;
    local arenaTeamIndex = 0;
    local offset = FauxScrollFrame_GetOffset(ArenaSpectatorXScrollFrame);
    local button, arenaInfo;

    for i = 1, MAX_ARENA_SPECTATOR_BUTTONS do
        arenaInfo = ARENA_TEAM_INFO[i];
        arenaTeamIndex = i + offset;
        button = _G["ArenaSpectatorXScrollFrameButton"..i];
        if ( arenaTeamIndex > numArenaTeams or not arenaInfo ) then
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

    FauxScrollFrame_Update(ArenaSpectatorXScrollFrame, numArenaTeams, MAX_ARENA_SPECTATOR_BUTTONS, 38, nil, nil, nil, nil, nil, nil, true);
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
    ArenaSoloQButton;
}

local ARENA_SPECTATOR_ARRENA_BUTTONS =
{
    Arena1v1Button;
    Arena2v2Button;
    Arena3v3Button;
    ArenaSoloQButton;
}

local MyGossipFrameUpdate = function(...)
    for _, button in ipairs(ARENA_SPECTATOR_BUTTONS) do
        button:Hide();
    end

    wipe(ARENA_TEAM_INFO);

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
                tinsert(ARENA_TEAM_INFO, arenaInfo);
            end
        end
    end

    ArenaSpectatorXScrollFrame_Update();
end

local ARENA_SPECTATOR_FRAMES =
{
    Refresh,
    Next,
    Prev,
    Back,
    GossipFrameGreetingPanelMaterialTopLeft,
    GossipFrameGreetingPanelMaterialTopRight,
    ArenaSpectatorX
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

        for _, frame in ipairs(ARENA_SPECTATOR_FRAMES) do
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
