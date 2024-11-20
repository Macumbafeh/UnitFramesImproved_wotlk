-- Credits to stassart on curse.com for suggesting to use InCombatLockdown() checks in the code

-- Debug function. Adds message to the chatbox (only visible to the loacl player)
function dout(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function tokenize(str)
	local tbl = {};
	for v in string.gmatch(str, "[^ ]+") do
		tinsert(tbl, v);
	end
	return tbl;
end

-- Create the addon main instance
local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');

-- Event listener to make sure we enable the addon at the right time
function UnitFramesImproved:PLAYER_ENTERING_WORLD()
	-- Set some default settings
	if (characterSettings == nil) then
		UnitFramesImproved_LoadDefaultSettings();
	end
	
	EnableUnitFramesImproved();
	
-- Macumba's changes
BuffFrame:SetScale(1.6)

for i=1,4 do _G["PartyMemberFrame"..i.."HealthBarText"]:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("TOP", 20, -13)end
for i=1,4 do _G["PartyMemberFrame"..i.."ManaBarText"]:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame"..i]:SetScale(1.6)end
for i=1,4 do _G["PartyMemberFrame"..i.."Name"]:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")end
for i=1,4 do _G["PartyMemberFrame"..i.."PVPIcon"]:Hide()end

PlayerPVPIcon:Hide()
PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
PlayerName:SetPoint("CENTER",50,38);
PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
PlayerFrameHealthBarText:SetPoint("CENTER", 50, 13);
PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");


TargetFrameTextureFrameName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
TargetFrameTextureFrameName:SetPoint("CENTER",-50,38);
TargetFrameTextureFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
TargetFrameTextureFrameHealthBarText:SetPoint("CENTER", -50, 13);
TargetFrameTextureFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
TargetFrameSpellBarText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")

FocusFrameTextureFrameName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
FocusFrameTextureFrameName:SetPoint("CENTER",-50,38);
FocusFrameTextureFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
FocusFrameTextureFrameHealthBarText:SetPoint("CENTER", -50, 13);
FocusFrameTextureFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
end

-- Event listener to make sure we've loaded our settings and thta we apply them
function UnitFramesImproved:VARIABLES_LOADED()
	dout("UnitFramesImproved settings loaded!");
	
	-- Set some default settings
	if (characterSettings == nil) then
		UnitFramesImproved_LoadDefaultSettings();
	end
	
	if (not (characterSettings["PlayerFrameAnchor"] == nil)) then
		StaticPopup_Show("LAYOUT_RESETDEFAULT");
		characterSettings["PlayerFrameX"] = nil;
		characterSettings["PlayerFrameY"] = nil;
		characterSettings["PlayerFrameMoved"] = nil;
		characterSettings["PlayerFrameAnchor"] = nil;
	end
	
	UnitFramesImproved_ApplySettings(characterSettings);
end

function UnitFramesImproved_ApplySettings(settings)
	UnitFramesImproved_SetFrameScale(settings["FrameScale"])
end

function UnitFramesImproved_LoadDefaultSettings()
	characterSettings = {}
	characterSettings["FrameScale"] = "1.0";
	
	if not TargetFrame:IsUserPlaced() then
		TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 36, 0);
	end
end

function EnableUnitFramesImproved()
	-- Generic status text hook
	hooksecurefunc("TextStatusBar_UpdateTextString", UnitFramesImproved_TextStatusBar_UpdateTextString);
	
	-- Hook PlayerFrame functions
	hooksecurefunc("PlayerFrame_ToPlayerArt", UnitFramesImproved_PlayerFrame_ToPlayerArt);
	hooksecurefunc("PlayerFrame_ToVehicleArt", UnitFramesImproved_PlayerFrame_ToVehicleArt);
	
	-- Hook TargetFrame functions
	hooksecurefunc("TargetFrame_Update", UnitFramesImproved_TargetFrame_Update);
	hooksecurefunc("TargetFrame_CheckFaction", UnitFramesImproved_TargetFrame_CheckFaction);
	hooksecurefunc("TargetFrame_CheckClassification", UnitFramesImproved_TargetFrame_CheckClassification);
	
	-- BossFrame hooks
	hooksecurefunc("BossTargetFrame_OnLoad", UnitFramesImproved_BossTargetFrame_Style);

	-- Setup relative layout for targetframe compared to PlayerFrame
	if not TargetFrame:IsUserPlaced() then
		if not InCombatLockdown() then 
			TargetFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPRIGHT", 36, 0);
		end
	end
	
	-- Set up some stylings
	UnitFramesImproved_Style_PlayerFrame();
	UnitFramesImproved_BossTargetFrame_Style(Boss1TargetFrame);
	UnitFramesImproved_BossTargetFrame_Style(Boss2TargetFrame);
	UnitFramesImproved_BossTargetFrame_Style(Boss3TargetFrame);
	UnitFramesImproved_BossTargetFrame_Style(Boss4TargetFrame);
	UnitFramesImproved_Style_TargetFrame(TargetFrame);
	UnitFramesImproved_Style_TargetFrame(FocusFrame);
end

function UnitFramesImproved_Style_PlayerFrame()
	if not InCombatLockdown() then 
		PlayerFrameHealthBar.lockColor = true;
		PlayerFrameHealthBar.capNumericDisplay = true;
		PlayerFrameHealthBar:SetWidth(119);
		PlayerFrameHealthBar:SetHeight(29);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-22);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,6);
	end
	
	PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved\\Textures\\UI-TargetingFrame");
	PlayerStatusTexture:SetTexture("Interface\\Addons\\UnitFramesImproved\\Textures\\UI-Player-Status");
	PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
	
                 for i,v in pairs({

		PlayerFrameTexture,
   		TargetFrameTextureFrameTexture,
  		PetFrameTexture,
		PartyMemberFrame1Texture,
		PartyMemberFrame2Texture,
		PartyMemberFrame3Texture,
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture,
		PartyMemberFrame2PetFrameTexture,
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
   		FocusFrameTextureFrameTexture,
   		TargetFrameToTTextureFrameTexture,
   		FocusFrameToTTextureFrameTexture,
   		
		CastingBarFrameBorder,
		FocusFrameSpellBarBorder,
		TargetFrameSpellBarBorder,
	

              }) do
  
                 v:SetVertexColor(.05, .05, .05)
		
	end  

end

function UnitFramesImproved_Style_TargetFrame(self)
	if not InCombatLockdown() then 
		self.healthbar.lockColor = true;
		self.healthbar:SetWidth(119);
		self.healthbar:SetHeight(29);
		self.healthbar:SetPoint("TOPLEFT",7,-22);
		self.healthbar.TextString:SetPoint("CENTER",-50,6);
		self.deadText:SetPoint("CENTER",-50,6);
		self.nameBackground:Hide();
	end
end

function UnitFramesImproved_BossTargetFrame_Style(self)
	self.borderTexture:SetTexture("Interface\\Addons\\UnitFramesImproved\\Textures\\UI-UnitFrame-Boss");

	UnitFramesImproved_Style_TargetFrame(self);
	if (not (characterSettings["FrameScale"] == nil)) then
		if not InCombatLockdown() then 
			self:SetScale(characterSettings["FrameScale"] * 0.9);
		end
	end
end

function UnitFramesImproved_SetFrameScale(scale)
	if not InCombatLockdown() then 
		-- Scale the main frames
		PlayerFrame:SetScale(scale);
		TargetFrame:SetScale(scale);
		FocusFrame:SetScale(scale);
		
		-- Scale sub-frames
		ComboFrame:SetScale(scale);
		--RuneFrame:SetScale(scale); -- Can't do this as it messes up the scale horribly
		RuneButtonIndividual1:SetScale(scale);
		RuneButtonIndividual2:SetScale(scale);
		RuneButtonIndividual3:SetScale(scale);
		RuneButtonIndividual4:SetScale(scale);
		RuneButtonIndividual5:SetScale(scale);
		RuneButtonIndividual6:SetScale(scale);
		
		-- Scale the BossFrames
		Boss1TargetFrame:SetScale(scale*0.9);
		Boss2TargetFrame:SetScale(scale*0.9);
		Boss3TargetFrame:SetScale(scale*0.9);
		Boss4TargetFrame:SetScale(scale*0.9);
		
		characterSettings["FrameScale"] = scale;
	end
end

local function ApplyThicknessToFocusFrame(self)
    if not self or not UnitExists("focus") then return end

    local classification = UnitClassification("focus")
    if (classification == "worldboss" or classification == "elite") then
        FocusFrame.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Elite")
        FocusFrame.borderTexture:SetVertexColor(1, 1, 1)
    elseif (classification == "rareelite") then
        FocusFrame.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare-Elite")
        FocusFrame.borderTexture:SetVertexColor(1, 1, 1)
    elseif (classification == "rare") then
        FocusFrame.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare")
        FocusFrame.borderTexture:SetVertexColor(1, 1, 1)
    else
        FocusFrame.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetingFrame")
        FocusFrame.borderTexture:SetVertexColor(0.05, 0.05, 0.05)
    end

    -- Adjust the health and mana bars, name, and other elements
    FocusFrame.highLevelTexture:SetPoint("CENTER", FocusFrame.levelText, "CENTER", 0, 0)
    FocusFrame.nameBackground:Hide()
    FocusFrame.name:SetPoint("LEFT", FocusFrame, 13, 40)
    FocusFrame.healthbar:SetSize(119, 27)
    FocusFrame.healthbar:SetPoint("TOPLEFT", 5, -24)
    FocusFrame.manabar:SetPoint("TOPLEFT", 7, -52)
    FocusFrame.manabar:SetSize(119, 13)

    if FocusFrame.Background then
        FocusFrame.Background:SetSize(119, 42)
        FocusFrame.Background:SetPoint("BOTTOMLEFT", FocusFrame, "BOTTOMLEFT", 7, 35)
    end
end

local function OnEvent(self, event, arg1)
    if event == "PLAYER_FOCUS_CHANGED" then
        ApplyThicknessToFocusFrame(FocusFrame)
    elseif event == "UNIT_CLASSIFICATION_CHANGED" and arg1 == "focus" then
        ApplyThicknessToFocusFrame(FocusFrame)
    end
end

local function InitializeFocusFrameCustomization()
    -- Create a frame to listen for events
    local focusFrameEventHandler = CreateFrame("Frame")
    focusFrameEventHandler:RegisterEvent("PLAYER_FOCUS_CHANGED")
    focusFrameEventHandler:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")

    -- Set the event handler function
    focusFrameEventHandler:SetScript("OnEvent", OnEvent)
end

-- Call this function during the PLAYER_LOGIN or ADDON_LOADED event
InitializeFocusFrameCustomization()

-- Slashcommand stuff
SLASH_UNITFRAMESIMPROVED1 = "/unitframesimproved";
SLASH_UNITFRAMESIMPROVED2 = "/ufi";
SlashCmdList["UNITFRAMESIMPROVED"] = function(msg, editBox)
	local tokens = tokenize(msg);
	if(table.getn(tokens) > 0 and strlower(tokens[1]) == "reset") then
		StaticPopup_Show("LAYOUT_RESET");
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "settings") then
		InterfaceOptionsFrame_OpenToCategory(UnitFramesImproved.panelSettings);
	elseif(table.getn(tokens) > 0 and strlower(tokens[1]) == "scale") then
		if(table.getn(tokens) > 1) then
			UnitFramesImproved_SetFrameScale(tokens[2]);
		else
			dout("Please supply a number, between 0.0 and 10.0 as the second parameter.");
		end
	else
		dout("Valid commands for UnitFramesImproved are:")
		dout("    help    (shows this message)");
		dout("    scale # (scales the player frames)");
		dout("    reset   (resets the scale of the player frames)");
		dout("");
	end
end

-- Setup the static popup dialog for resetting the UI
StaticPopupDialogs["LAYOUT_RESET"] = {
	text = "Are you sure you want to reset your scale?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		UnitFramesImproved_LoadDefaultSettings();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

StaticPopupDialogs["LAYOUT_RESETDEFAULT"] = {
	text = "In order for UnitFramesImproved to work properly,\nyour old layout settings need to be reset.\nThis will reload your UI.",
	button1 = "Reset",
	button2 = "Ignore",
	OnAccept = function()
		PlayerFrame:SetUserPlaced(false);
		ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

function UnitFramesImproved_TextStatusBar_UpdateTextString(textStatusBar)
	local textString = textStatusBar.TextString;
	if(textString) then
		local value = textStatusBar:GetValue();
		local valueMin, valueMax = textStatusBar:GetMinMaxValues();

		if ( ( tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not ( textStatusBar.pauseUpdates ) ) then
			textStatusBar:Show();
			if ( value and valueMax > 0 and ( GetCVarBool("statusTextPercentage") or textStatusBar.showPercentage ) and not textStatusBar.showNumeric) then
				if ( value == 0 and textStatusBar.zeroText ) then
					textString:SetText(textStatusBar.zeroText);
					textStatusBar.isZero = 1;
					textString:Show();
					return;
				end
				value = tostring(math.ceil((value / valueMax) * 100)) .. "%";
				--[[if ( textStatusBar.prefix and (textStatusBar.alwaysPrefix or not (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) ) ) then
					textString:SetText(textStatusBar.prefix.." "..UnitFramesImproved_CapDisplayOfNumericValue(textStatusBar:GetValue()).." ("..value..")");
				else
					textString:SetText(UnitFramesImproved_CapDisplayOfNumericValue(textStatusBar:GetValue()).." ("..value..")");
				end]]
			elseif ( value == 0 and textStatusBar.zeroText ) then
				textString:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				textString:Show();
				return;
			else
				textStatusBar.isZero = nil;
				--local percent = tostring(math.ceil((value / valueMax) * 100)) .. "%";
				--[[if ( textStatusBar.capNumericDisplay ) then
					value = UnitFramesImproved_CapDisplayOfNumericValue(value);
					valueMax = UnitFramesImproved_CapDisplayOfNumericValue(valueMax);
				end ]]
				if ( textStatusBar.prefix and (textStatusBar.alwaysPrefix or not (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) ) ) then
					textString:SetText(textStatusBar.prefix.." "..value.."/"..valueMax);
				else
					textString:SetText(value.."/"..valueMax);
				end
			end
			
			if ( (textStatusBar.cvar and GetCVar(textStatusBar.cvar) == "1" and textStatusBar.textLockable) or textStatusBar.forceShow ) then
				textString:Show();
			elseif ( textStatusBar.lockShow > 0 and (not textStatusBar.forceHideText) ) then
				textString:Show();
			else
				textString:Hide();
			end
		else
			textString:Hide();
			textString:SetText("");
			--[[if ( not textStatusBar.alwaysShow ) then
				textStatusBar:Hide();
			else
				textStatusBar:SetValue(0);
			end ]]
		end
	end
end

function UnitFramesImproved_PlayerFrame_ToPlayerArt(self)
	if not InCombatLockdown() then
		UnitFramesImproved_Style_PlayerFrame();
	end
end

function UnitFramesImproved_PlayerFrame_ToVehicleArt(self)
	if not InCombatLockdown() then
		PlayerFrameHealthBar:SetHeight(12);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,3);
	end
end

function UnitFramesImproved_TargetFrame_Update(self)
	-- Set back color of health bar
	if ( not UnitPlayerControlled(self.unit) and UnitIsTapped(self.unit) and not UnitIsTappedByPlayer(self.unit) and not UnitIsTappedByAllThreatList(self.unit) ) then
		-- Gray if npc is tapped by other player
		self.healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
	else
		-- Standard by class etc if not
		self.healthbar:SetStatusBarColor(UnitColor(self.healthbar.unit));
	end
end

function UnitFramesImproved_TargetFrame_CheckClassification(self, forceNormalTexture)
	local texture;
	local classification = UnitClassification(self.unit);
	if ( classification == "worldboss" or classification == "elite" ) then
		texture = "Interface\\Addons\\UnitFramesImproved\\Textures\\UI-TargetingFrame-Elite";
		TargetFrameToTTextureFrameTexture:SetVertexColor(1, 1, 1)
		TargetFrameTextureFrameTexture:SetVertexColor(1, 1, 1)
	elseif ( classification == "rareelite" ) then
		texture = "Interface\\Addons\\UnitFramesImproved\\Textures\\UI-TargetingFrame-Rare-Elite";
		TargetFrameToTTextureFrameTexture:SetVertexColor(1, 1, 1)
		TargetFrameTextureFrameTexture:SetVertexColor(1, 1, 1)
	elseif ( classification == "rare" ) then
		texture = "Interface\\Addons\\UnitFramesImproved\\Textures\\UI-TargetingFrame-Rare";
		TargetFrameToTTextureFrameTexture:SetVertexColor(1, 1, 1)
		TargetFrameTextureFrameTexture:SetVertexColor(1, 1, 1)
	else
		TargetFrameToTTextureFrameTexture:SetVertexColor(.05, .05, .05)
		TargetFrameTextureFrameTexture:SetVertexColor(.05, .05, .05)
	end
	if ( texture and not forceNormalTexture) then
		self.borderTexture:SetTexture(texture);
	else
		self.borderTexture:SetTexture("Interface\\Addons\\UnitFramesImproved\\Textures\\UI-TargetingFrame");
	end
end

function UnitFramesImproved_TargetFrame_CheckFaction(self)
	local factionGroup = UnitFactionGroup(self.unit);
	if ( UnitIsPVPFreeForAll(self.unit) ) then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		self.pvpIcon:Hide();
	elseif ( factionGroup and UnitIsPVP(self.unit) and UnitIsEnemy("player", self.unit) ) then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		self.pvpIcon:Hide();
	elseif ( factionGroup ) then
		self.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		self.pvpIcon:Hide();
	else
		self.pvpIcon:Hide();
	end
end

-- Utility functions
function UnitColor(unit)
	local r, g, b;
	if ( ( not UnitIsPlayer(unit) ) and ( ( not UnitIsConnected(unit) ) or ( UnitIsDeadOrGhost(unit) ) ) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif (UnitIsPlayer(unit) and UnitExists(unit) and not UnitIsDead(unit) and not UnitIsDeadOrGhost(unit) and not UnitIsGhost(unit) and UnitIsConnected(unit) and UnitIsFriend("player", unit)) then
            
		--Try to color it by class.
		local localizedClass, englishClass = UnitClass(unit);
		local classColor = RAID_CLASS_COLORS[englishClass];
		if ( classColor ) then
			r, g, b = classColor.r, classColor.g, classColor.b;
		else
			if ( UnitIsFriend("player", unit) or UnitIsFriend("pet", unit) ) then
				r, g, b = 0.0, 1.0, 0.0;
			else
				r, g, b = 1.0, 0.0, 0.0;
			end
		end
	else
		r, g, b = UnitSelectionColor(unit);
	end
	
	return r, g, b;
end


-- Party class color
--[[ local function UpdatePartyFramesColor()
    for i = 1, MAX_PARTY_MEMBERS do
        local frame = _G["PartyMemberFrame" .. i]
        if frame and frame:IsShown() then
            local _, class = UnitClass("party" .. i)
            if class then
                local color = RAID_CLASS_COLORS[class]
                frame.healthbar:SetStatusBarColor(color.r, color.g, color.b)
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:SetScript("OnEvent", UpdatePartyFramesColor) ]]

--[[ function UnitFramesImproved_CapDisplayOfNumericValue(value)
	local strLen = strlen(value);
	local retString = value;
	if (true) then
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."."..string.sub(value, -9, -9).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."."..string.sub(value, -6, -6).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."."..string.sub(value, -3, -3).."k";
		end
	else
		if ( strLen >= 10 ) then
			retString = string.sub(value, 1, -10).."G";
		elseif ( strLen >= 7 ) then
			retString = string.sub(value, 1, -7).."M";
		elseif ( strLen >= 4 ) then
			retString = string.sub(value, 1, -4).."k";
		end
	end
	return retString;
end  ]]

-- Bootstrap
function UnitFramesImproved_StartUp(self)
	self:SetScript('OnEvent', function(self, event) self[event](self) end);
	self:RegisterEvent('PLAYER_ENTERING_WORLD');
	self:RegisterEvent('VARIABLES_LOADED');
end

UnitFramesImproved_StartUp(UnitFramesImproved);

-- Table Dump Functions -- http://lua-users.org/wiki/TableSerialization
function print_r (t, indent, done)
  done = done or {}
  indent = indent or ''
  local nextIndent -- Storage for next indentation value
  for key, value in pairs (t) do
    if type (value) == "table" and not done [value] then
      nextIndent = nextIndent or
          (indent .. string.rep(' ',string.len(tostring (key))+2))
          -- Shortcut conditional allocation
      done [value] = true
      print (indent .. "[" .. tostring (key) .. "] => Table {");
      print  (nextIndent .. "{");
      print_r (value, nextIndent .. string.rep(' ',2), done)
      print  (nextIndent .. "}");
    else
      print  (indent .. "[" .. tostring (key) .. "] => " .. tostring (value).."")
    end
  end
end
