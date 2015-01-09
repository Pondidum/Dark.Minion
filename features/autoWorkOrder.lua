local addon, ns = ...

local autoWorkOrder = Darker.class:extend({

	ctor = function(self)
		self:include(Darker.events)

		self:register("ADDON_LOADED")
	end,

	ADDON_LOADED = function(self, addonName)

		if addonName ~= "Blizzard_GarrisonUI" then
			return
		end

		self:unregister("ADDON_LOADED")
		self:buildInterface()

		self:register("SHIPMENT_CRAFTER_OPENED")
		self:register("SHIPMENT_CRAFTER_CLOSED")
		self:register("SHIPMENT_CRAFTER_INFO")

	end,

	SHIPMENT_CRAFTER_OPENED = function(self)
		self:stopProcessing()
	end,

	SHIPMENT_CRAFTER_CLOSED = function(self)
		self:stopProcessing()
	end,

	SHIPMENT_CRAFTER_INFO = function(self, success, active, max, plotID)

		self.maxShipments = max

		if self:isMaxedOut() then
			self.button:Disable()
		else
			self.button:Enable()
		end

	end,

	buildInterface = function(self)

		local parent = GarrisonCapacitiveDisplayFrame
		local startButton = GarrisonCapacitiveDisplayFrame.StartWorkOrderButton

		local extraWidth = 40
		local extraHeight = startButton:GetHeight()

		local autoButton = CreateFrame("Button", "DarkMinionAutoWorkOrder", parent, "MagicButtonTemplate")
		autoButton:SetSize(extraWidth, extraHeight)
		autoButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -6, 4)
		autoButton:SetText("All")

		startButton:SetWidth(startButton:GetWidth() - extraWidth)
		startButton:ClearAllPoints()
		startButton:SetPoint("RIGHT", autoButton, "LEFT", 0, 0)

		autoButton:SetScript("OnClick", function()
			self:startProcessing()
		end)

		self.button = autoButton

	end,

	isMaxedOut = function(self)
		return C_Garrison.GetNumPendingShipments() == self.maxShipments
	end,

	stopProcessing = function(self)
		self.button:SetScript("OnUpdate", nil)
	end,

	startProcessing = function(self)

		local throttle = 0.3
		local total = 0
		local maxShipments = 0

		self.button:SetScript("OnUpdate", function(s, elapsed)
			total = total + elapsed

			if total > throttle then
				total = 0

				C_Garrison.RequestShipmentCreation()

				 if self:isMaxedOut() then
			        self:stopProcessing()
					self.button:Disable()
	     		end
			end
		end)

	end,

})

ns.features.add({

	name = "AutoWorkOrder",

	initialise = function()
		autoWorkOrder:new()
	end
})
