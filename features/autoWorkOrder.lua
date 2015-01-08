local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local createUi = function()

	local parent = GarrisonCapacitiveDisplayFrame
	local startButton = GarrisonCapacitiveDisplayFrame.StartWorkOrderButton

	local extraWidth = 40
	local extraHeight = startButton:GetHeight()

	local extra = CreateFrame("Button", "DarkMinionAutoWorkOrder", parent, "MagicButtonTemplate")
	extra:SetSize(extraWidth, extraHeight)
	extra:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -6, 4)
	extra:SetText("All")

	startButton:SetWidth(startButton:GetWidth() - extraWidth)
	startButton:ClearAllPoints()
	startButton:SetPoint("RIGHT", extra, "LEFT", 0, 0)

	local throttle = 0.3
	local total = 0
	local maxShipments = 0

	local onCrafterInfo = function(self, event, success, active, max, plotID)
		maxShipments = max
	end

	local onDisplay = function()
		startButton:SetScript("OnUpdate", nil)
	end

	events.register("SHIPMENT_CRAFTER_OPENED", onDisplay)
	events.register("SHIPMENT_CRAFTER_CLOSED", onDisplay)
	events.register("SHIPMENT_CRAFTER_INFO", onCrafterInfo)

	local queueOrders = function(self, elapsed)
		total = total + elapsed

		if total > throttle then
			total = 0

			C_Garrison.RequestShipmentCreation()

			 if C_Garrison.GetNumPendingShipments() == maxShipments then
		        self:SetScript("OnUpdate", nil)
     		end
		end
	end

	startButton:SetScript("OnClick", function()
		total = 0
		startButton:SetScript("OnUpdate", queueOrders)
	end)

end

ns.features.add({

	name = "AutoWorkOrder",

	initialise = function()
		createUi()
	end,

	enable = function()
	end,

	disable = function()
	end,

	isEnabled = function()
	end,

})
