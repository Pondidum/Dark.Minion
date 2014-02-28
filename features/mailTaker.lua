local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local mailProcessor = {

	new = function(action)

		local this = {}

		local printMessage = function(message)
			print("Dark.Minion: Mail:", message)
		end

		local onErrorMessage = function(self, event, message)
			if message == ERR_INV_FULL then
				finally()
				printMessage("Stopped, Inventory was full.")
			end
		end

		local finally = function()
			events.unregister("UI_ERROR_MESSAGE")
			events.unregisterOnUpdate()
		end

		local lastItem

		local onUpdate = function()

			if not InboxFrame:IsVisible() then
				finally()
				printMessage("No mailbox open/in range.")
			end

			local mailIcon, stationaryIcon, sender, subject, money, cod, daysLeft, numItems = GetInboxHeaderInfo(lastItem)

			if numItems > 0 or (money and not cod) then
				action(index)
			end

			lastItem = lastItem - 1

		end

		this.process = function()

			lastItem = GetInboxNumItems()

			events.register("UI_ERROR_MESSAGE", onErrorMessage)
			events.registerOnUpdate(onUpdate)
		end

		return this

	end,

}



local takeAll = function()

	local action = function(index)
		AutoLootMailItem(index)
	end

	local mailbox = mailProcessor.new(action)
	mailbox.process()

end

local takeGold = function()

	local action = function(index)
		TakeInboxMoney(index)
	end

	local mailbox = mailProcessor.new(action)
	mailbox.process()

end

local createUi = function()

	local itemsButton = CreateFrame("Button", "DarkMinionTakeAll", InboxFrame, "UIPanelButtonTemplate")
	itemsButton:SetSize(60, 25)
	itemsButton:SetText("Take All")
	itemsButton:SetScript("OnClick", takeAll)

	local goldButton = CreateFrame("Button", "DarkMinionTakeGold", InboxFrame, "UIPanelButtonTemplate")
	goldButton:SetSize(60, 25)
	goldButton:SetText("Take Gold")
	goldButton:SetScript("OnClick", takeGold)

	itemsButton:SetPoint("TOPLEFT", InboxFrame, "TOPLEFT", 80, -40)
	goldButton:SetPoint("LEFT", itemsButton, "RIGHT", 10, 0)

end


ns.features.add({

	name = "Mail Taker",

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
