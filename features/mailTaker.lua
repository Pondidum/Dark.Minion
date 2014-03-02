local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()

local mailProcessor = {

	new = function(host, action)

		local searcher = host:CreateAnimationGroup()
		searcher:SetLooping("REPEAT")

		local a = searcher:CreateAnimation()
		a:SetDuration(0.5)

		local currentItem = 0

		local finally = function(message)
			print("Dark.MinionMail:", message)
			searcher:Stop()
			events.unregister("UI_ERROR_MESSAGE")
		end

		local onError = function(sender, event, message)
			if message == ERR_INV_FULL then
				finally("Stopped, Inventory was full.")
			end
		end

		local process = function()
			currentItem = GetInboxNumItems()
			events.register("UI_ERROR_MESSAGE", onError)
			searcher:Play()
		end

		searcher:SetScript("OnLoop", function()

			if currentItem <= 0 then
				finally("Reached the end.")
				return
			end

			if not InboxFrame:IsVisible() then
				finally("No Inbox in range.")
				return
			end

			local mailIcon, stationaryIcon, sender, subject, money, cod, daysLeft, numItems = GetInboxHeaderInfo(currentItem)

			if ((numItems and numItems > 0) or (money and money > 0)) and cod <= 0 then
				action(currentItem)
			end

			currentItem = currentItem - 1

		end)

		local this = {
			process = process,
		}

		return this

	end,

}



local takeAll = function(self)

	local action = function(index)
		AutoLootMailItem(index)
	end

	local mailbox = mailProcessor.new(self, action)
	mailbox.process()

end

local takeGold = function(self)

	local action = function(index)
		TakeInboxMoney(index)
	end

	local mailbox = mailProcessor.new(self, action)
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
