local addon, ns = ...

local autoRepair = ns.lib.class:extend({

	name = "AutoRepair",

	ctor = function(self)
		self:include(ns.lib.events)
	end,

	enable = function(self)
		self:register("MERCHANT_SHOW")
	end,

	disable = function(self)
		self:unregister("MERCHANT_SHOW")
	end,

	isEnabled = function(self)
		return self:isRegistered("MERCHANT_SHOW")
	end,

	MERCHANT_SHOW = function(self)

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

	end,
})

ns.features.add(autoRepair)
