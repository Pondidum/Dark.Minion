local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local NUM_BAG_FRAMES = NUM_BAG_FRAMES
local LE_ITEM_QUALITY_POOR = LE_ITEM_QUALITY_POOR

local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemID = GetContainerItemID
local GetItemInfo = GetItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local UseContainerItem = UseContainerItem
local PickupMerchantItem = PickupMerchantItem

local autoSell = function()

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

end

ns.features.add({

	name = "AutoSell",

	enable = function()
		events.register("MERCHANT_SHOW", autoSell)
	end,

	disable = function()
		events.unregister("MERCHANT_SHOW", autoSell)
	end,

	isEnabled = function()
		return events.isRegistered("MERCHANT_SHOW")
	end,

})
