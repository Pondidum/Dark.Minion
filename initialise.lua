local addon, ns = ...

local core = Dark.core

ns.lib = {
	events = core.events,
}

local featureMeta = {
	name = "Unknown",
	enable = function() end,
	disable = function() end,
	initialise = function() end,
}

local features = {}

ns.features = {

	add = function(feature)

		setmetatable(feature, { __index = featureMeta })

		table.insert(features, feature)

	end,

	each = function(action)

		for i, feature in ipairs(features) do
			action(feature)
		end

	end,
}
