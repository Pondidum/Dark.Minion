local addon, ns = ...

local core = Dark.core

ns.lib = {
	events = core.events,
}

local features = {}

ns.features = {

	add = function(feature)
		table.insert(features, feature)
	end,

	each = function(action)

		for i, feature in ipairs(features) do
			action(feature)
		end

	end,
}
