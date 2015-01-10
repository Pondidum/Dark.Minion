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

		local total = 0

		for bag = 0, NUM_BAG_FRAMES do

			for slot = 1, GetContainerNumSlots(bag) do

				local itemLink = GetContainerItemLink(bag, slot)
				local itemID = GetContainerItemID(bag, slot)

				if itemLink and itemID then

					local _, _, quality, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(itemLink)

					if quality == LE_ITEM_QUALITY_POOR then

						local _, count = GetContainerItemInfo(bag, slot)
						local price = vendorPrice * count

						UseContainerItem(bag, slot)
						PickupMerchantItem()

						total = total + price

					end

				end

			end

		end

		if total > 0 then

			local gold = math.floor(total / 10000) or 0
			local silver = math.floor((total % 10000) / 100) or 0
			local copper = total % 100

			DEFAULT_CHAT_FRAME:AddMessage("Your trash has been sold for |cffffffff"..gold.."g "..silver.."s "..copper.."c|r.", 255, 255, 0)

		end

	end,

})

ns.features.add(autoRepair)
