local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local IsShiftKeyDown = IsShiftKeyDown
local CanMerchantRepair = CanMerchantRepair
local GetRepairAllCost = GetRepairAllCost
local CanGuildBankRepair = CanGuildBankRepair
local RepairAllItems = RepairAllItems

local autoRepair = function()

	if IsShiftKeyDown() then
		return
	end

	if not CanMerchantRepair() then
		return
	end

	local cost, possible = GetRepairAllCost()
	local useGuildBank = CanGuildBankRepair()


	if cost > 0 then

		if possible then

			RepairAllItems(useGuildBank)

			local copper = cost % 100
			local silver = math.floor((cost % 10000) / 100)
			local gold = math.floor(cost / 10000)

			DEFAULT_CHAT_FRAME:AddMessage("Your gear has been repaired for |cffffffff"..gold.."g "..silver.."s "..copper.."c|r.", 255, 255, 0)

		else

			DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money to repair!", 255, 0, 0)

		end

	end

end

local controller = {
	enable = function()
		events.register("MERCHANT_SHOW", autoRepair)
	end,

	disable = function()
		events.unregister("MERCHANT_SHOW", autoRepair)
	end,

	isEnabled = function()
		return events.isRegistered("MERCHANT_SHOW")
	end,
}

ns.features.add({

	name = "AutoRepair",

	enable = controller.enable,
	disable = controller.disable,
	isEnabled = controller.isEnabled,

})
