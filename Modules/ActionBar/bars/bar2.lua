local B, C, L, DB = unpack(select(2, ...))
local Bar = NDui:GetModule("Actionbar")
local cfg = C.bars.bar2
local padding, margin = 2, 2

function Bar:CreateBar2()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = NDuiDB["Actionbar"]["Style"]

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ActionBar2", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
	frame:SetHeight(cfg.size + 2*padding)
	if layout == 5 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -108, 60}
	else
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 60}
	end
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)

	for i = 1, num do
		local button = _G["MultiBarBottomLeftButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, padding, padding)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create drag frame and drag functionality
	if C.bars.userplaced then
		B.Mover(frame, SHOW_MULTIBAR1_TEXT, "Bar2", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		NDui.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
	
	-- 修复登录时动作条边框显示问题
	local function ToggleButtonGrid()
		if InCombatLockdown() then return end
		local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
		for _, button in next, buttonList do
			button:SetAttribute("showgrid", showgrid)
			ActionButton_ShowGrid(button)
		end
	end
	C_Timer.After(0.1, ToggleButtonGrid)
end