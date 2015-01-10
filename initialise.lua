local addon, ns = ...

local dark = Darker

ns.lib = {
	class = dark.class,
	events = dark.events,
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
