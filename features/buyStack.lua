local addon, ns = ...

local buyStack = ns.lib.class:extend({

	name = "Buy Whole Stack",

	ctor = function(self)

		self.original = MerchantItemButton_OnModifiedClick

		self.custom = function(button, ...)

			if IsAltKeyDown() then

				local itemLink = GetMerchantItemLink(button:GetID())
				local maxStack = select(8, GetItemInfo(itemLink))

				if maxStack and maxStack > 1 then
					BuyMerchantItem(button:GetID(), maxStack)
				end

			end

			self.original(button, ...)

		end

	end,

	enable = function(self)
		MerchantItemButton_OnModifiedClick = self.custom
	end,

	disable = function(self)
		MerchantItemButton_OnModifiedClick = self.original
	end,

	isEnabled = function()
		return MerchantItemButton_OnModifiedClick ~= self.original
	end,

})

ns.features.add(buyStack)
