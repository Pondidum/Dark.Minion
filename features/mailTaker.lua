local addon, ns = ...

local mailer = ns.lib.class:extend({

	ctor = function(self)
		self:include(ns.lib.events)
	end,

	enable = function(self)

		self:buildInterface()
		self:setupTimer()

	end,

	buildInterface = function(self)

		local itemsButton = CreateFrame("Button", "DarkMinionTakeAll", InboxFrame, "UIPanelButtonTemplate")
		itemsButton:SetSize(60, 25)
		itemsButton:SetText("Take All")

		local goldButton = CreateFrame("Button", "DarkMinionTakeGold", InboxFrame, "UIPanelButtonTemplate")
		goldButton:SetSize(60, 25)
		goldButton:SetText("Take Gold")

		itemsButton:SetPoint("TOPLEFT", InboxFrame, "TOPLEFT", 80, -28)
		goldButton:SetPoint("LEFT", itemsButton, "RIGHT", 10, 0)


		itemsButton:SetScript("OnClick", function(button)

			self.action = function(index)
				AutoLootMailItem(index)
			end

			self:process()

		end)

		goldButton:SetScript("OnClick", function(button)

			self.action = function(index)
				TakeInboxMoney(index)
			end

			self:process()

		end)

		self.parent = InboxFrame
		self.itemsButton = itemsButton
		self.goldButton = goldButton

	end,

	setupTimer = function(self)

		local searcher = self.parent:CreateAnimationGroup()
		searcher:SetLooping("REPEAT")

		local a = searcher:CreateAnimation()
		a:SetDuration(0.8)

		self.currentItem = 0
		self.action = function() end

		searcher:SetScript("OnLoop", function()

			if self.currentItem <= 0 then
				self:finally("Reached the end.")
				return
			end

			if not InboxFrame:IsVisible() then
				self:finally("No Inbox in range.")
				return
			end

			local mailIcon, stationaryIcon, sender, subject, money, cod, daysLeft, numItems = GetInboxHeaderInfo(self.currentItem)

			if ((numItems and numItems > 0) or (money and money > 0)) and cod <= 0 then
				self.action(self.currentItem)
			end

			self.currentItem = self.currentItem - 1

		end)

		self.searcher = searcher
	end,


	process = function(self)
		self:register("UI_ERROR_MESSAGE", onError)
		self.currentItem = GetInboxNumItems()
		self.searcher:Play()
	end,

	finally = function(self, message)

		self.searcher:Stop()
		self:unregister("UI_ERROR_MESSAGE")

		print("Dark.MinionMail:", message)

	end,

	UI_ERROR_MESSAGE = function(sender, event, message)
		if message == ERR_INV_FULL then
			self:finally("Stopped, Inventory was full.")
		end
	end
})

ns.features.add(mailer)
