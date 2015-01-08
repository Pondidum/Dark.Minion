local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local onOpen = function()

end

local onClose = function()

end

local onCrafterInfo = function()

end

ns.features.add({

	name = "AutoWorkOrder",

	enable = function()
		events.register("SHIPMENT_CRAFTER_OPENED", onOpen)
		events.register("SHIPMENT_CRAFTER_CLOSED", onClose)
		events.register("SHIPMENT_CRAFTER_INFO", onCrafterInfo)
	end,

	disable = function()
		events.unregister("SHIPMENT_CRAFTER_OPENED", onOpen)
		events.unregister("SHIPMENT_CRAFTER_CLOSED", onClose)
		events.unregister("SHIPMENT_CRAFTER_INFO", onCrafterInfo)
	end,

	isEnabled = function()
		return events.isRegistered("SHIPMENT_CRAFTER_OPENED")
	end,

})
