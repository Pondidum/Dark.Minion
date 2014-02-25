local addon, ns = ...
local config = ns.config

local GetMerchantItemLink = GetMerchantItemLink
local GetItemInfo = GetItemInfo
local BuyMerchantItem = BuyMerchantItem

local original = MerchantItemButton_OnModifiedClick
local custom = function(self, ...)

	if IsAltKeyDown() then

		local itemLink = GetMerchantItemLink(self:GetID())
		local maxStack = select(8, GetItemInfo(itemLink))

		if maxStack and maxStack > 1 then
			BuyMerchantItem(self:GetID(), maxStack)
		end

	end

	original(self, ...)

end

ns.features.add({

	name = "Buy Whole Stack",

	enable = function()
		MerchantItemButton_OnModifiedClick = custom
	end,

	disable = function()
		MerchantItemButton_OnModifiedClick = original
	end,

	isEnabled = function()
		return MerchantItemButton_OnModifiedClick == custom
	end,

})
